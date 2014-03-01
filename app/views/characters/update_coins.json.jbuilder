COIN_DENOMINATIONS.each do |c|
  json.set! c, @character.send(c)
  json.coin_string coin_string @character
end
