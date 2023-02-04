def buy(amount, bonuses, des)
  amount = amount.round
  if des == 0
    bonuses += amount / 100 unless amount < 100
  else
    amount = (amount - bonuses).abs
  end
end

amount = gets.to_f
bonuses = gets.to_i
des = gets.to_i

puts buy(amount, bonuses, des)
