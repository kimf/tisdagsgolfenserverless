# frozen_string_literal: true
require 'one_signal'
require 'json'

class Notifier
  class << self
    def send_push(params)
      OneSignal::OneSignal.api_key = ENV['ONESIGNAL_API_KEY']
      OneSignal::OneSignal.user_auth_key = ENV['ONESIGNAL_USER_AUTH_KEY']

      begin
        response = OneSignal::Notification.create(params: params)
        notification_id = JSON.parse(response.body)['id']
        notification_id
      rescue OneSignal::OneSignalError => e
        puts '--- OneSignalError  :'
        puts "-- message : #{e.message}"
        puts "-- status : #{e.http_status}"
        puts "-- body : #{e.http_body}"
      end
    end
  end
end
