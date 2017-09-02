ExUnit.start()

defmodule Suffixer do

  use ExUnit.Case

  def suffixes([]), do: [[]]
  def suffixes([el]), do: [[el], []]
  def suffixes(list = [_ | tail]) do
    [list] ++ suffixes(tail)
  end

  test "generates suffixes" do
    assert Suffixer.suffixes([1,2,3,4]) == [[1,2,3,4], [2,3,4], [3, 4], [4], []]
  end
end
