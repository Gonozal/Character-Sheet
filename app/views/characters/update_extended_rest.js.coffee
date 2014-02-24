$("#hp-and-surges").replaceWith('<%= render partial: "characters/combat_stats" %>')
$('#spellbook').replaceWith('<%= render partial: "characters/spellbook" %>')
$("#log").html('<%= render partial: "characters/log" %>')
$(".encounter").removeClass("used")
$(".daily").removeClass("used")

$('.qaction.active').qtip().hide()
