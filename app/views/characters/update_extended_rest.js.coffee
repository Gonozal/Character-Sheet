$("#hp-and-surges").replaceWith('<%= render partial: "characters/combat_stats" %>')
$('#spellbook').replaceWith('<%= render partial: "characters/spellbook" %>')
$("#powers").html("<%= escape_javascript(render partial: 'characters/powers') %>")
$("#log").html('<%= render partial: "characters/log" %>')
$(".encounter").removeClass("used")
$(".daily").removeClass("used")

$("#character_hp_change").val("")
$("#character_hs_change").val("")

$('.qaction.active').qtip().hide()
