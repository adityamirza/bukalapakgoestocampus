# frozen_string_literal: true

Before do
  @client_id = ENV['API_CLIENT_ID']
  @client_secret = ENV['API_CLIENT_SECRET']
  @accounts_url = ENV['ACCOUNTS_BASE_URL']
  @omniscience_url = ENV['OMNISCIENCE_BASE_URL']
  @user_agent = ENV['USER_AGENT'] || 'android'
  @api = true
  @timeout = 480
  @api_url = ENV['API_BASE_URL'] || ENV['API_SMOKE_TEST_URL']
  @apiv4_url = ENV['APIV4_BASE_URL'] || ENV['APIV4_SMOKE_TEST_URL']
  puts "Host       : #{@api_url}"
  puts "Host v4    : #{@apiv4_url}"
  puts "Accounts   : #{@accounts_url}"
  puts "User-Agent : #{@user_agent}"
end
