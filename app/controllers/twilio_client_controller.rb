class TwilioClientController < ApplicationController
  respond_to :js
  def index
    default_client = "Emsey"
    @client_name = params[:client]
    if @client_name.nil?
        @client_name = default_client
    end
    @token = Twilio::CapabilityToken.create({
      :allow_outgoing => 'AP8eaeda65de06e3755b86e47009f84c30',
      :allow_incoming => @client_name
    })
    respond_to do |format|
      
      format.js {Rails.logger.debug "format: js"}
      format.html {Rails.logger.debug "format: html"}
      # render "index.js"
    end
    
  end
  
end


