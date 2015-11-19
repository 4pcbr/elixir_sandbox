defmodule Sequence do

  def next({i, j}) when i < j and j - i == 1, do: { i + 1, 0 }
  def next({i, j}) when i < j, do: { i + 1, j }
  def next({i, j}) when i == j, do: { 0, j + 1 }
  def next({i, j}) when i > j, do: { i, j + 1 }
  def puts_self({ i, j }) do
    IO.puts "#{i}, #{j}"
    { i, j }
  end
  def loop( { i, j } ) do
    next({ i, j })
      |> puts_self
      |> loop
  end

end

