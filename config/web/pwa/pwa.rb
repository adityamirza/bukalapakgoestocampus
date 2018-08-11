Before do
  DEVICE_ID = ENV['DEVICE_ID']
  APPIUM_URL = ENV['APPIUM_URL']
  HIVE_QUEUE_NAME = ENV['HIVE_QUEUE_NAME']
  BROWSER = ENV['BROWSER']
  def appium_caps
    {
      'MY_DEVICE' => {
        platformName: 'Android', deviceName: HIVE_QUEUE_NAME,
        udid: DEVICE_ID, browserName: BROWSER
      }
    }
  end
  Capybara.register_driver :appium do |app|
    caps = appium_caps.fetch('MY_DEVICE')
    appium_lib_options = { server_url: APPIUM_URL }
    all_options = { appium_lib: appium_lib_options, caps: caps }
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote, url: APPIUM_URL,
      desired_capabilities: caps
    )
    Appium::Capybara::Driver.new app, all_options
  end
  Capybara.default_driver = :appium
  Capybara.app_host = ENV['PWA_BASE_URL']
end
