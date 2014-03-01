$.extend(RestInPlaceEditor.forms,
  "number" :
    activateForm : ->
      value = $.trim(@$element.html())
      @$element.html("""<form action="javascript:void(0)" style="display:inline;">
        <input type="number" step="any" min="0" class="rip rest-in-place-#{@attributeName}">
        </form>""")
      @$element.find('input').val(value)
      @$element.find('input')[0].select()
      @$element.find("form").submit =>
        @update()
        false
      @$element.find("input").keyup (e) =>
        @abort() if e.keyCode == 27 or e.keyCode == 0
      @$element.find("input").blur =>
        @update()
        false
    getValue : ->
      @$element.find("input").val()
)
