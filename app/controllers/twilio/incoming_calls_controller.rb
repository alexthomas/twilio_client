module Twilio
  class IncomingCallsController < ApplicationController

    def index
      default_client = 'Emsey'
      @response = Twilio::TwiML.build do |r|
             # Should be your Twilio Number or a verified Caller ID
        r.dial :callerId => Twilio.twilio_phone_number do |d|
            if /^[\d\+\-\(\) ]+$/.match(number)
                d.number(CGI::escapeHTML number)
            else
                d.client default_client
            end
        end
      end
    end
  
  end
end


