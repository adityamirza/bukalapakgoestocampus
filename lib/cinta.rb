require 'openssl'
require 'net/http'

# cinta laura representative
class Cinta
  API_URL = "https://api.telegram.org/bot#{ENV['TELEGRAM_BOT_TOKEN']}/sendMessage"

  def self.send_to_telegram(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.request(Net::HTTP::Post.new(url)).read_body
  end

  def self.send_message(message, target: ENV['TELEGRAM_CHAT_ID'])
    message.gsub!("\n", '%0A')
    message.gsub!('#', '%23')
    message.gsub!('&', '%26')

    message = URI("#{API_URL}?chat_id=#{target}&parse_mode=HTML&text=#{message}")
    send_to_telegram(message)
  end
end
