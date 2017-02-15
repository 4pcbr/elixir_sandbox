defmodule A do
  def a(%{0 => true}) do
    IO.puts "here!"
  end

  def a(_), do: IO.puts "screw you"
end

A.a(%{ 1 => 2, 0 => 1 })
