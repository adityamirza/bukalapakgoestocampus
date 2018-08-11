# frozen_string_literal: true

PATH = ENV['ANDROID_APK_PATH']
apk_path = "#{Dir.pwd}#{PATH}"

desired_caps = {
  caps: {
    appiumVersion: '1.7.2',
    platformName: 'Android',
    platformVersion: ENV['ANDROID_VERSION'],
    browserName: '',
    deviceName: ENV['ANDROID_DEVICE_NAME'],
    app: apk_path,
    name: 'Bukalapak',
    autoGrantPermissions: true
  }
}

Before('@android') do
  Appium::Driver.new(desired_caps)
  Appium.promote_appium_methods Object
  ScreenObject::Load_App.start_driver
end

After('@android') do
  ScreenObject::Load_App.quit_driver
end
