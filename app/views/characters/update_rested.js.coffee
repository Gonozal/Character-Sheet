$("#hp-and-surges").replaceWith('<%= render partial: "characters/combat_stats" %>')
$("#log").html('<%= render partial: "characters/log" %>')
$(".encounter").removeClass("used")

$("#character_hp_change").val("")
$("#character_hs_change").val("")

$('.qaction.active').qtip().hide()
