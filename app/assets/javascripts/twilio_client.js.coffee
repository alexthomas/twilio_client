moduleKeywords = ['extended', 'included']

class BaseClass

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this

class Singleton extends BaseClass
  @_instance = undefined
  @getInstance: (args) -> # Must be a static method
    @_instance ?= new @(args)
    
class TwilioClient extends Singleton
  
  params = {}
  _client_name: "browser"
  _twilio_token: false
  _client_ready: false
  
  constructor: ( ) ->
    @params = @split_url_params(window.location.search)
    @set_attr_from_params('client','_client_name')
    @get_twilio_token()

  set_client_name: (client_name) ->
    @_client_name = client_name
  
  set_client_ready: (status) ->
    @_client_ready = status
  
  setup_device: () ->
    try 
      Twilio.Device.setup("token", {debug: true})

    catch
      console.log "unable to setup device"
      @set_client_ready(false)

  twilio_token: () ->
    @_twilio_token
  
  get_twilio_token: () ->
    if !@twilio_token()
      console.log("twilio token is empty - get from api")
    else
      @twilio_token()

  
  set_attr_from_params: (param,attr) ->
    if included = ((param of @params) & (attr of @))
      @[attr] = @params[param]

      
  split_url_params: (search) ->
    params = {}
    parts = search.substring(1).split("&")
    for part in parts
      key_value = part.split("=")
      
      if key_value.length == 2
        console.log("part: " + part)
        params[key_value[0]] = key_value[1]
    params
      
      
    

root = exports ? this
tc = TwilioClient.getInstance()
root.tc = tc