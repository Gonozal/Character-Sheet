module CharactersHelper
  def coin_string(c)
    coins = COIN_DENOMINATIONS.select{|i| c.send(i) > 0}
    if coins.present?
      coins.collect do |i| 
        "#{number_with_delimiter c.send(i)}&nbsp;#{i.to_s.upcase}"
      end.join("; ")
    else
      "You are broke"
    end
  end
end
