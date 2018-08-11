# frozen_string_literal: true

Before do
  Capybara.app_host = ENV['MOBILE_BASE_URL'] || 'https://m.bukalapak.com'
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.webkit_options = {
    width: 412,
    height: 732
  }
  Capybara.save_path = 'screenshots'

  page.driver.browser.manage.window.resize_to(412, 732)
end
