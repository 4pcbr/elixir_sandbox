defmodule MyEnum do
  
  def each( collection, fun ) do
    reducer = fn x, _ -> { :cont, fun.(x) } end
    Enumerable.reduce( collection, { :cont, [] }, reducer )
    :ok
  end

  def filter( collection, fun ) do
    reducer = fn x, acc ->
      if fun.(x), do: { :cont, [ x | acc ] }, else: { :cont, acc }
    end
    Enumerable.reduce( collection, { :cont, [] }, reducer ) |> elem( 1 ) |> :lists.reverse
  end

  def map( collection, fun ) do
    reducer = fn x, acc -> { :cont, [ fun.( x ) | acc ] } end
    Enumerable.reduce( collection, { :cont, [] }, reducer ) |> elem( 1 ) |> :lists.reverse
  end

end

