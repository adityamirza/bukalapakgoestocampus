$LOAD_PATH.unshift File.expand_path('../../object_abstractions/web', __FILE__)

require 'appium_lib'
require 'appium_capybara'
require "capybara/cucumber"
require "capybara-screenshot/cucumber"
require "capybara/rspec"
require "selenium-webdriver"
require "rspec/retry"
require "pry"
require "securerandom"
require "yaml"
require "dotenv"
require "site_prism"
require "httparty"
require "uri"
require "net/http"
require "headless"
require "nokogiri"
require "open-uri"
require "filesize"
require "fileutils"
require "net/http/post/multipart"
require "logger"
require "uri"
require "net/ssh"
require 'screen-object'


Dotenv.load

def browser_specification(width = 1366, height = 768, prune = 50, user_agent = "", wait_time = 3, timeout = 10, host = "", append_timestamp = true)
  Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["general.useragent.override"] = user_agent.to_s
    profile['dom.max_script_run_time'] = 60
    options = Selenium::WebDriver::Firefox::Options.new
    options.profile = profile
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.open_timeout = timeout
    client.read_timeout = timeout
    Capybara::Selenium::Driver.new(app, options: options, http_client: client)
  end
  Capybara::Screenshot.register_driver(:selenium) do |driver, path|
    driver.browser.save_screenshot path
  end

  puts "Host       : #{host}"
  puts "User-Agent : #{user_agent}"
  Capybara.app_host = host
  Capybara.default_driver = :selenium
  Capybara.default_max_wait_time = wait_time
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.webkit_options = { width:width, height: height}
  Capybara::Screenshot.prune_strategy = { keep:prune }
  Capybara::Screenshot.append_timestamp = false if append_timestamp == false
  Capybara.save_path = "screenshots"
  page.driver.browser.manage.window.resize_to(width, height)
end

def client_specification(user_agent, api = true, timeout, api_url,apiv4_url)
  @client_id = ENV['API_CLIENT_ID']
  @client_secret = ENV['API_CLIENT_SECRET']
  @accounts_url = ENV['ACCOUNTS_URL']
  @omniscience_url= ENV['OMNISCIENCE_URL']
  @user_agent = user_agent
  @api = api
  @timeout = timeout
  @api_url = api_url
  @apiv4_url = apiv4_url
  puts "Host       : #{@api_url}"
  puts "Host v4    : #{@apiv4_url}"
  puts "Accounts   : #{@accounts_url}"
  puts "User-Agent : #{@user_agent}"
end

Before("@video") do
  @video = true
  executor_number = ENV['EXECUTOR_NUMBER'] ? 600 + ENV['EXECUTOR_NUMBER'].to_i : 99
  puts "Executor Number = #{executor_number}"
  @headless = Headless.new(dimensions: "1366x768x24", display: executor_number)
  @headless.start
  @headless.video.start_capture
end

After("@video") do |scenario|
  if scenario.failed?
    dir_path = "#{Dir.pwd}/video/#{scenario.name.split.join("_")}.mov"
    puts "Video save to #{dir_path}"
    @headless.video.stop_and_save(dir_path)
  else
    @headless.video.stop_and_discard
  end
end

Before('@db-test') do
  mysql_db_connection
end

After("@db-test") do
  @client.close
end

Before('@agent-lite') do
  host = ENV['AGENT_LITE_BASE_URL'] || 'http://agen.staging96.vm'
  browser_specification(412, 732, 50, ENV['MOBILE_USER_AGENT'], 3, 120, host)
end

Before('@penggerak') do
  host = ENV['PENGGERAK_BASE_URL'] || 'https://penggerak.bukalapak.com'
  user_agent = ENV['MOBILE_USER_AGENT'] || 'android'
  browser_specification(412, 732, 50, user_agent, 3, 120, host)
end

Before('@api') do
  user_agent = ENV['MOBILE_USER_AGENT'] || 'android'
  apiv2_url = ENV['API_SMOKE_TEST_URL'] || ENV['API_URL']
  apiv4_url = ENV['APIV4_SMOKE_TEST_URL'] || ENV['APIV4_URL']
  client_specification(user_agent, true, 480, apiv2_url, apiv4_url)
end

Before do
  @token    = ENV['TELEGRAM_TOKEN']
  @receiver = ENV['TELEGRAM_CHAT_ID']
end

After do |scenario|
  if scenario.failed?
    if !@api
      puts("ERROR REPORT")
      url = URI.parse(current_url)
      puts("URL = " + url.to_s)
    end
    if !@token.nil? && !@receiver.nil?
      puts "TELEGRAM TOKEN = #{@token}"
      puts "TELEGRAM CHAT ID = #{@receiver}"
      send_failed_scenario_to_telegram(scenario)
    end
  end
end
