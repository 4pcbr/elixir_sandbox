defmodule MyList do

  def len([]), do: 0
  def len([_ | tail]), do: 1 + len(tail)

  def square([]), do: []
  def square([head | tail]), do: [head * head | square(tail)]

  def add_1([]), do: []
  def add_1([head | tail]), do: [head + 1 | add_1(tail)]

  def map([], _func), do: []
  def map([head | tail], func), do: [func.(head) | map(tail, func)]

  def inject(memo, [], _func), do: memo
  def inject(memo, [head|tail], func), do: func.(memo, head) + inject(memo, tail, func)

  def sum([]), do: 0
  def sum([head|tail]), do: head + sum(tail)

  def mapsum([], _func), do: 0
  def mapsum([head|tail], func), do: func.(head) + mapsum(tail, func)

  def max_l([], prev_max), do: prev_max
  def max_l([head|tail], prev_max) when prev_max >= head, do: max_l(tail, prev_max)
  def max_l([head|tail], prev_max) when head > prev_max, do: max_l(tail, head)
  def max_l([head|tail]), do: max_l(tail, head)

  def caesar([], _), do: []
  def caesar([head|tail], num) when [head + num] > 'z', do: '?' ++ caesar(tail, num)
  def caesar([head|tail], num), do: [ head + num | caesar(tail, num) ]

end

