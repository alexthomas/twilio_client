module TwilioClientHelper
  
  def twilio_app_id
    app_id = "AP8eaeda65de06e3755b86e47009f84c30"
  end
  
  def get_client_name(client_name)
    client_name.nil? ? default_client : client_name
  end
  
  def default_client
      'emsey'
  end
    
end
