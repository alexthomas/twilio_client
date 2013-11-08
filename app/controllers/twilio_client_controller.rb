class TwilioClientController < ApplicationController

  def index
    @client = Twilio::REST::Client.new "ACaf0eee667926566569d4ce3c9abc458e", "2229b2c0a5b6442d7c31a2c1791d6b92"
    @response = @client.account.sms.messages.create(
      :from => '+15005550006',
      :to => '+61404100419',
      :body => 'Hey there twilio test!'
    )
  end
  
end


