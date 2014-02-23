$("#hp-and-surges").replaceWith('<%= render partial: "characters/combat_stats" %>')
$("#log").html('<%= render partial: "characters/log" %>')

$('.qaction.active').qtip().hide()
