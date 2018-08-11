# frozen_string_literal: true

PATH = ENV['IOS_APK_PATH']
app_path = "#{Dir.pwd}#{PATH}"

caps = {
  caps: {
    automationName: 'XCUITest',
    platformName: 'ios',
    deviceName: ENV['IOS_DEVICE_NAME'],
    iosVersion: ENV['IOS_VERSION'],
    noReset: 'false',
    udid: '',
    app: app_path
  }
}

Before('@ios') do
  Appium::Driver.new(caps)
  Appium.promote_appium_methods Object
  ScreenObject::Load_App.start_driver
end

After('@ios') do
  ScreenObject::Load_App.quit_driver
end
