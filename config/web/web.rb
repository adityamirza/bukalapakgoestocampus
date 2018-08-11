# frozen_string_literal: true

# configuration for desktop and mobile web
browser = (ENV['BROWSER'] || 'firefox').to_sym
user_agent = ENV['USER_AGENT'] || 'blstresstest'
wait_time = 60 * 5

puts "Browser   : #{browser}"
puts "User Agent: #{user_agent}"

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['general.useragent.override'] = user_agent
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_preference 'dom.webnotifications.enabled', false
  options.add_preference 'dom.push.enabled', false
  options.profile = profile
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options,
    http_client: client
  )
end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  args = "--user-agent=#{user_agent} --disable-notifications"
  options.add_argument(args)
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    http_client: client
  )
end

Capybara::Screenshot.register_driver(browser) do |driver, path|
  driver.browser.save_screenshot path
end

Capybara.default_driver = browser
Capybara::Screenshot.autosave_on_failure = false

Capybara::Screenshot.prune_strategy = { keep: 50 }
Capybara::Screenshot.append_timestamp = true