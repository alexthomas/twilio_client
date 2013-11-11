module ApplicationHelper
  
  def twilio_javascript_include_tag(*allowed_controllers)
      if allowed_controllers.include?(controller_name.to_sym) || allowed_controllers.empty?
        javascript_include_tag "http://static.twilio.com/libs/twiliojs/1.1/twilio.min.js" 
      end
  end
    
end
