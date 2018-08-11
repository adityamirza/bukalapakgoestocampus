# frozen_string_literal: true

Before do
  Capybara.app_host = ENV['BASE_URL'] || 'https://www.bukalapak.com'
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.webkit_options = {
    width: 1366,
    height: 780
  }
  Capybara.save_path = 'screenshots'

  page.driver.browser.manage.window.resize_to(1366, 780)
end
