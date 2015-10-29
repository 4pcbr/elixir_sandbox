defmodule Parallel do
  import :timer, only: [ sleep: 1 ]
  import :rand, only:  [ uniform: 1 ]
  def pmap(collection, fun) do
    me = self
    IO.inspect me
    collection
      |> Enum.map(fn (elem) ->
          spawn_link fn ->
            sleep uniform(10)
            send me, { self, fun.(elem) }
          end
      end)
      |> Enum.map(fn (pid) ->
        receive do { ^pid, result } -> result end
      end)
  end
end

