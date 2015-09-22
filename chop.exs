defmodule Chop do

  defp next_step( num, guessed_num, range ) when num == guessed_num do
    IO.puts num
  end


  defp next_step( num, guessed_num, range ) when num > guessed_num do
    guess( num, guessed_num..range.last )
  end

  defp next_step( num, guessed_num, range ) when num < guessed_num do
    guess( num, range.first..guessed_num )
  end


  def guess( num, range ) do
    guessed_num = div( range.first + range.last, 2 )
    IO.puts "Is it #{guessed_num}"
    if range.first > range.last do
      range = range.last..range.first
    end

    next_step( num, guessed_num, range )
  end

end

