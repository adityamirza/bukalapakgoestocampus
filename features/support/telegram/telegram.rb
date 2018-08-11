def body_send_image_to_telegram(file, boundary)
  post_body = []
  post_body << "--#{boundary}\r\n"
  post_body << "Content-Disposition: form-data; name=\"photo\"; filename=\"#{file}\"\r\n"
  post_body << "Content-Type: image/png\r\n"
  post_body << "\r\n"
  post_body << File.read(file)
  post_body << "\r\n--#{boundary}--\r\n"
  return post_body
end

def send_image_to_telegram(file, caption)
  if caption.length > 200
    caption = "#{caption[0..195]}..."
  end
  boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
  url = URI("https://api.telegram.org/bot#{@token}/sendPhoto?chat_id=-#{@receiver}&caption=#{caption}")
  post_body = body_send_image_to_telegram(file, boundary)
  request = Net::HTTP::Post.new(url)
  request.body = post_body.join
  request["Content-Type"] = "multipart/form-data, boundary=#{boundary}"
  resp = send_message_to_telegram(request, url)
  if resp.code == 400
    send_text_to_telegram(caption)
  end
end

def send_text_to_telegram(text, token = @token, receiver = @receiver)
  url = URI("https://api.telegram.org/bot#{token}/sendMessage?chat_id=-#{receiver}&text=#{text}")
  send_message_to_telegram(Net::HTTP::Post.new(url), url)
end

def send_failed_scenario_to_telegram(scenario)
  exceptions = scenario.exception
  scenario_name = scenario.name
  if exceptions
    message = "Failed: #{scenario_name} \n\nERROR MESSAGE : #{exceptions.message}"
  else
    message = "Failed: #{scenario_name}"
  end
  escaped_text = CGI.escape(message)
  begin
    file = save_image_to_path(scenario_name)
    if file
      send_image_to_telegram(File.absolute_path(file), escaped_text)
    end
  rescue
    send_text_to_telegram(escaped_text)
  end
end

def save_image_to_path(scenario)
  puts scenario
  now = DateTime.now.strftime("%H_%M_%S")
  screenshot_name = "#{scenario}_#{now}.png"
  Capybara.page.save_screenshot(screenshot_name)
  file = "#{Capybara.save_path}/#{screenshot_name}"
  return file
end

def send_message_to_telegram(request, url)
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_NONE
  response=https.request(request)
  puts response.read_body
  response
end
