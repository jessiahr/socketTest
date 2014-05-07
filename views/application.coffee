# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
#  // where our WebSockets logic will go later
  socket = ""
  host     =""
  host = "ws://localhost:3001";
  connect = ->

    try
      socket = new WebSocket(host)

      addMessage("Socket State: " + socket.readyState);

      socket.onopen = ->
        addMessage("Socket Status: " + socket.readyState + " (open)");


      socket.onclose = ->
        addMessage("Socket Status: " + socket.readyState + " (closed)");


      socket.onmessage = (msg) ->
        addMessage("Received: " + msg.data)

    catch exception
      addMessage("Error: " + exception);



  addMessage = (msg)->
    $("#chat-log").append("<p>" + msg + "</p>")


#  function send() {
  send = ->

    text = $("#message").val()
    if (text == '')
      addMessage("Please Enter a Message")
      return


    try
      socket.send(text);
      addMessage("Sent: " + text);
    catch exception
      console.log("test")
      addMessage("Failed To Send")


    $("#message").val('');


#
#  $('#message').keypress(function(event) {
#    if (event.keyCode == '13') { send(); }
#  });
#
#  $("#disconnect").click(function() {
#  socket.close()
#  });




  $(document).ready (->
#     initialize
    connect();

    $('#message').keypress((event)->

      if (event.keyCode == 13)
        send()
    )

    $("#disconnect").click(()->
      socket.close()
    )
  )