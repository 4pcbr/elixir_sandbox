defmodule Sequence do

  def next({i, j}) when i < j and j - i == 1, do: { i + 1, 0 }
  def next({i, j}) when i < j, do: { i + 1, j }
  def next({i, j}) when i == j, do: { 0, j + 1 }
  def next({i, j}) when i > j, do: { i, j + 1 }

  def loop( { i, _j } ) when i > 1_000, do: { :ok }
  def loop( { i, j } ) do
    next({ i, j })
      |> loop
  end

end

defmodule SequenceServer do

  use GenServer

  def start_link do
    GenServer.start_link( __MODULE__, { 0, 0 }, name: __MODULE__ )
  end

  def reset do
    GenServer.cast( __MODULE__, :reset )
  end

  def handle_call( :next, _from, { i, j } ) do
    { i0, j0 } = { i, j }
    { i, j } = case i do
      k when k < j and j - k == 1 -> { i + 1, 0 }
      k when k <  j               -> { i + 1, j }
      k when k == j               -> { 0, j + 1 }
      k when k >  j               -> { i, j + 1 }
    end
    { :reply, { i0, j0 }, { i, j } }
  end

  def handle_cast( :reset, _ ) do
    { :noreply, { 0, 0 } }
  end

  def next do
    GenServer.call( __MODULE__, :next )
  end

  def test do
    { i, _j } = SequenceServer.next
    if i > 1_000 do
      { :ok }
    else
      test
    end
  end

end

use_gen_server = (System.get_env("USE_GEN_SERVER") != nil)

if use_gen_server do
  IO.puts "Using the gen_server"
  SequenceServer.start_link
else
  IO.puts "Using the normal recursion"
end


1..5 |>
  Enum.each(fn(_) ->
    { time, _result } = case use_gen_server do
      true ->
        SequenceServer.reset
        :timer.tc(SequenceServer, :test, [])
      false ->
        :timer.tc(Sequence, :loop, [{0, 0}])
    end
    :io.format( "~.2f~n", [ time / 1_000_000.0 ] )
  end)

