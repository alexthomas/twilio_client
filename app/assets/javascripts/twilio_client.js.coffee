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
  _app_id: false
  _twilio_token: false
  _client_ready: false
  
  constructor: ( ) ->
    @params = @split_url_params(window.location.search)
    @set_attr_from_params('client','_client_name')
    # @get_twilio_token()

  set_client_name: (client_name) ->
    @_client_name = client_name
  
  set_client_ready: (status) ->
    @_client_ready = status
  
  set_app_id: () ->
    if app_id = $( "#twilio-client" ).attr( "data-app-id" )
      @_app_id = app_id
    console.log "app id: "  + @_app_id
    
  setup_device: () ->
    try 
      console.log "token in setup " + @_twilio_token
      Twilio.Device.setup(@_twilio_token, {debug: true})
      Twilio.Device.ready(() =>
        $("#twilio-client").removeClass('hidden')     
      )

    catch
      console.log "unable to setup device"
      @set_client_ready(false)
      
  start_call: () ->
    console.log "starting call"
    params = {"PhoneNumber": $("#number").val()}
    Twilio.Device.connect(params)
  
  end_call: () ->
    console.log "ending call"
    Twilio.Device.disconnectAll()
  
  setup_call_callback_handler: () ->
    Twilio.Device.connect( (conn) ->
      $("#log").text("Successfully established call")
      $(".call").toggleClass('hidden')
      $(".hangup").toggleClass('hidden')
    )
    
  setup_disconnect_callback_handler: () ->
    Twilio.Device.disconnect( (conn) ->
      $("#log").text("Successfully terminated call")
      $(".call").toggleClass('hidden')
      $(".hangup").toggleClass('hidden')
          
    )
  setup_error_callback_handler: () ->
    Twilio.Device.error( (error) ->
          $("#log").text("Error: " + error.message.message)
    )
  
  setup_incoming_call_listener: () ->
    Twilio.Device.incoming( (conn) ->
      $("#log").text("Incoming connection from " + conn.parameters.From)
      conn.accept()
    )
  
  setup_connected_clients_listener: () ->
    Twilio.Device.presence( (pres) =>
      if (pres.available) 
        $("<li>", {id: pres.from, text: pres.from}).click( () =>
          $("#number").val(pres.from)
          @start_call()
        ).prependTo("#people")

      else 
        $("#" + pres.from).remove()

    )
  twilio_token: () ->
    @_twilio_token
  
  setup_client: () ->
    @get_twilio_token()
  
  get_twilio_token: () ->
    if !@twilio_token()
      console.log("twilio token is empty - get from api")
      $.ajax({
        url: '/api/twilio/client/capability_token.js'
        type: "POST"
        dataType: 'script'
        data: {allow_outgoing: @_app_id,allow_incoming: @_client_name}
        success: (data) =>
          token_response = $.parseJSON(data)
          @_twilio_token = token_response[0]['token']
          @setup_device()
          @setup_error_callback_handler()
          @setup_call_callback_handler()
          @setup_error_callback_handler()
          @setup_incoming_call_listener()
          @setup_connected_clients_listener()
          console.log "successfully got twilio token " + @_twilio_token
        error: (jqXHR, textStatus,errorThrown) => 
          console.log "failed to get twilio token " + jqXHR.responseText
      })
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
$(document).ready(() ->
    tc.set_app_id()
    tc.setup_client()
    
    $('body').delegate('.call', 'click', () ->
      tc.start_call()
      return false
    )
    
    $('body').delegate('.hangup', 'click', () ->
      tc.end_call()
      return false
    )
)