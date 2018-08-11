$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'dotenv/load'
require 'httparty'
require 'json'

require 'cinta'

def emoji(emoji)
  URI.encode(emoji)
end

namespace :cinta do
  desc "Send automation summary result as Cinta Laura"
  task :automation_multijob_summary do
    ARGV.each { |arg| task arg.to_sym do; end }

    require 'jenkins/multijob'

    multijob = Jenkins::MultiJob.new(ARGV[1])

    message = "Hai kaka, automation untuk <a href=\"#{multijob.last_build['url']}\">#{multijob.title}</a>"
    message += " commit terakhir <code>#{ENV['BRANCH']}</code>" unless ENV['BRANCH'].to_s.empty?
    message += " dengan user agent <code>#{ENV['USER_AGENT']}</code>" unless ENV['USER_AGENT'].to_s.empty?
    message += " udah selesai nih. Ini list fitur-fitur yang dijalanin:\n"

    jobs = {}
    multijob.last_build_sub_builds.each do |build|
      job = Jenkins::Job.new(build['jobName'], build['buildNumber'])
      result = build['result'] == 'SUCCESS'

      next if ENV['REPORT_ERROR_JOBS_ONLY'] == 'true' && result

      txt  = emoji(result ? "✅" : "❌")
      txt += " <a href=\"#{job.last_build['url']}\">#{job.title}</a>"

      jobs[job.title] = txt
    end
    message += Hash[jobs.sort].values.join("\n")

    message += "\n\nKalo ada yang gagal (#{emoji("❌")}) tolong di-cek manual dulu ya, kali aja beneran error. Kalo sukses (#{emoji("✅")}) berarti aman-aman aja~"
    puts Cinta.send_message(message)
  end

  desc "Send automation summary squad result as Cinta Laura"
  task :automation_multijob_squad_summary do
    ARGV.each { |arg| task arg.to_sym do; end }

    require 'jenkins/view'
    require 'yaml'

    assignees = YAML.load_file('./lib/jenkins/assignee.yml')
    on_duty = []
    unlisted_squads = []
    view = Jenkins::View.new(ARGV[1])

    get_nick_name = lambda do |username|
      nick = assignees['nick_names'][username]
      nick ? "#{nick} (#{username})" : username
    end

    message = "Hai kaka, Smoke Test" \
              "#{" dengan user agent <code>#{ENV['USER_AGENT']}</code>" unless ENV['USER_AGENT'].to_s.empty?} " \
              "udah selesai nih, Tolong di Cek ya kakak Smoke Test nya merah tuh #{emoji("😥")}\n\n"

    view.jobs.each do |build|
      if build['color'].include?('red')
        next if assignees['exclude'].include?(build['name'])

        names = assignees['squads'][build['name']]
        message += "<a href=\"#{build['url']}\">#{build['name']}</a> #{names}\n"

        if names
          on_duty += names.split
        else
          unlisted_squads << "<code>#{build['name']}</code>"
        end
      end
    end

    message += "\nKalau ada Issue segera raise d grup ya kakak.. Semangat #{emoji("😘")}"

    unlisted_squad_message = unlisted_squads.empty? ? '' : "\n\nAda squad yang belum terdaftar nih: #{unlisted_squads.join(', ')}"

    on_duty = on_duty.uniq.sample(3)
    smoke_test_message = if on_duty.empty? then ''
                         else
                           "\n\nYang piket buat smoke test kali ini:" \
                           "#{"\n1. " + get_nick_name.call(on_duty[0]) + " [primary]" if on_duty[0]}" \
                           "#{"\n2. " + get_nick_name.call(on_duty[1]) if on_duty[1]}" \
                           "#{"\n3. " + get_nick_name.call(on_duty[2]) if on_duty[2]}"
                         end

    puts Cinta.send_message(message + smoke_test_message + unlisted_squad_message)
    puts Cinta.send_message(
      "Smoke-Testing untuk " \
        "#{"<code>" + ENV['BRANCH'] + "</code>" if ENV['BRANCH']} " \
        "sudah selesai... Tolong dicek ya... #{emoji("😘")}" + smoke_test_message,
      target: ENV['OPS_TELEGRAM_CHAT_ID']
    ) if ENV['OPS_TELEGRAM_CHAT_ID']
  end

  desc 'Send multi job disabled jobs reminder'
  task :automation_disabled_reminder do
    ARGV.each { |arg| task(arg.to_sym {}) }

    require 'jenkins/view'
    require 'jenkins/multijob'
    require 'yaml'

    view = Jenkins::View.new('smoke-testing-squad')
    assignees = YAML.load_file('./lib/jenkins/assignee.yml')

    message = 'Ada beberapa job yang ke-disable nih. ' \
              "Tolong dicek ya #{emoji('😘')}\n"

    view.jobs.each do |job|
      name = job['name']
      projects = Jenkins::MultiJob.new(name).downstream_projects

      next unless %w[red blue].include?(job['color'])

      projects.select! { |proj| proj['color'] == 'disabled' }
              &.map! { |proj| proj['name'] }

      puts "#{name} => #{projects}"

      unless projects.empty?
        message += "\n#{name} (#{assignees['squads'][name]})\n" \
                   "- #{projects.join("\n- ")}\n"
      end
    end

    puts Cinta.send_message(message)
  end
end

namespace :send do
  desc 'Send cucumber.json to server'
  require 'dotenv'
  require 'net/scp'
  Dotenv.load

  ARGV.each { |arg| task(arg.to_sym {}) }
  task :cucumber_json_report do
    host = '172.16.70.67'
    username = ENV['CUCUMBER_REPORT_USERNAME']
    password = ENV['CUCUMBER_REPORT_PASSWORD']
    dir = File.expand_path('.', Dir.pwd)
    my_dir = Dir["#{dir}/cucumber-*.json"]
    my_dir.each do |filename|
      puts filename
      remote = '/home/bukalapak/jenkins-slave-8/workspace/smoke-testing-report/'
      Net::SCP.start(host, username, password: password, timeout: 15) do |scp|
        scp.upload!(filename, remote) do |name, sent, total|
          puts "#{name}: #{sent}/#{total}"
        end
      end
    end
  end
end

namespace :generate do
  desc 'generate smoke testing summary'
  require 'selenium-webdriver'
  require 'report_builder'
  require_relative './features/support/telegram/telegram'
  Dotenv.load
  ARGV.each { |arg| task(arg.to_sym {}) }
  task :smoke_testing_summary do
    browser = Selenium::WebDriver.for :firefox
    browser.get 'http://localhost:8000/test_report.html'
    sleep 5
    browser.manage.window.resize_to(1366, 1366)
    img = browser.screenshot_as(:png)
    file = 'full-page.png'
    File.open(file, 'w+') do |fh|
      fh.write img
    end
    browser.quit
    message = 'Hai kaka, Cinta mau kasih tau summary smoke test tadi nih!'
    @token    = ENV['TELEGRAM_TOKEN']
    @receiver = ENV['TELEGRAM_CHAT_ID']
    path = "#{Dir.pwd}/#{file}"
    send_image_to_telegram(File.absolute_path(path), message)
  end
end
