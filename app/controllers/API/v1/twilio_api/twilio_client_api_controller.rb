module Api 
  module V1
    module TwilioApi
      class TwilioClientApiController < ApiController
      
        respond_to :json
        
        def index
          
        end
        
        def capability_token
          allowed_keys = params.keys & %w(allow_outgoing allow_incoming expires)
          allowed_params = params.slice(*allowed_keys)
          @token = Twilio::CapabilityToken.create(allowed_params)
          Rails.logger.debug "token: #{@token}"
          render :json => [{ :token => Twilio::CapabilityToken.create(allowed_params) }].to_json
        end

      
      end 
    end
  end
  
end