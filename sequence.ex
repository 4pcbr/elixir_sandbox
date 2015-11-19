defmodule Sequence do

  def next({i, j}) when i < j and j - i == 1, do: { i + 1, 0 }
  def next({i, j}) when i < j, do: { i + 1, j }
  def next({i, j}) when i == j, do: { 0, j + 1 }
  def next({i, j}) when i > j, do: { i, j + 1 }
  def puts_self({ i, j }) do
    IO.puts "#{i}, #{j}"
    { i, j }
  end
  def loop( { i, _j } ) when i > 10_000, do: { :ok }
  def loop( { i, j } ) do
    next({ i, j })
    #|> puts_self
      |> loop
  end

end

1..5 |>
  Enum.each(fn(_) ->
    { time, result } = :timer.tc(Sequence, :loop, [{ 0, 0 }])
    :io.format( "~.2f~n", [ time / 1_000_000.0 ] )
  end)

