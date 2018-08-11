def resize_window_to_desktop
  page.driver.browser.manage.window.resize_to(1366, 768)
end

def resize_window_to_mobile
  page.driver.browser.manage.window.resize_to(412, 732) #nexus 5
end

def open_new_window
  page.driver.browser.open_new_window
end

def resize_based_on_tag
  if @mobile
    resize_window_to_mobile
  else
    resize_window_to_desktop
  end
end

def close_browser
  page.driver.browser.close_window
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end
