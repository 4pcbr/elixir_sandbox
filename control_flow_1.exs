defmodule FizzBuzz do

  def upto( n ) do
    1..n |> Enum.map &_fizzbuzz/1
  end

  defp _fizzbuzz( num ) do
    case { rem( num, 3 ), rem( num, 5 ) } do
      { 0, 0 } -> "FizzBuzz"
      { 0, _ } -> "Fizz"
      { _, 0 } -> "Buzz"
      { _, _ } -> num
    end
  end

end

