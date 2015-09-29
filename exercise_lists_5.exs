defmodule MyEnum do

  def all?([], _) do; true; end

  def all?([num | rest], func) do
    func.(num) && all?(rest, func)
  end

  def each([], _) do; end
  def each([num | rest], func) do
    func.(num)
    each(rest, func)
    :ok
  end

  def filter([], _) do; []; end
  def filter([num | rest], func) do
    if func.(num) do
      [num] ++ filter(rest, func)
    else
      filter(rest, func)
    end
  end


  def take( [], _ ) do; []; end

  def take( _, 0 ) do; []; end

  def take( list, limit ) when limit < 0 do
    l_length = length( list )
    if abs( limit ) <= l_length do
      Enum.reverse( take( Enum.reverse( list ), abs( limit ) ) )
    else
      list
    end
  end

  def take( [ num | rest ], limit ) do
    [ num ] ++ take( rest, limit - 1 )
  end

  def split( [], _ ) do; { [], [] }; end

  def split( list, 0 ) do; { [], list }; end

  def split( list, limit ) when limit < 0 do
    l_length = length(list)
    if abs(limit) <= l_length do
      split(list, l_length + limit)
    else
      split(list, 0)
    end
  end

  def split( [ num | rest ], limit ) when limit > 0 do
    { first, last } = split(rest, limit - 1)
    { [num] ++ first, last }
  end

end

