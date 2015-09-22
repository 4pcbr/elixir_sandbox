defmodule FizzBuzz do
  def run( 0, 0, _ ) do "FizzBuzz" end
  def run( 0, _, _ ) do "Fizz" end
  def run( _, 0, _ ) do "Buzz" end
  def run( _, _, c ) do c end
end

fizzbuzz_rem = fn (n) -> FizzBuzz.run( rem( n, 3 ), rem( n, 5 ), n ) end


# IO.puts fizbuzz.(0, 0, 1)
# IO.puts fizbuzz.(0, 1, 1)
# IO.puts fizbuzz.(1, 0, 1)
# IO.puts fizbuzz.(1, 2, 3)

for i <- 10..16 do
  IO.puts fizzbuzz_rem.( i )
end

