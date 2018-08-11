# frozen_string_literal: true

Before do
  Capybara.app_host = ENV['BBM_BASE_URL'] || 'https://bbm.bukalapak.com'
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.webkit_options = {
    width: 412,
    height: 732
  }
  Capybara.save_path = 'screenshots/web/bbm'

  page.driver.browser.manage.window.resize_to(412, 732)
end
