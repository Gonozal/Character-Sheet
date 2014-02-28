# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  fileInput = $('#user_attachment')

  fileInput.change ->
    $filename = $(this).val().replace(/^.*[/\\]/g, "")
    if($filename)
      $('#file-label').text($filename)
      $('#file-submit-btn').removeClass('hidden')
