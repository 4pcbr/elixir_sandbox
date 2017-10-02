ExUnit.start()

defmodule RedBlackTree do
  defstruct color: :black, left: nil, element: nil, right: nil

  def member?(_, nil), do: false
  def member?(x, %RedBlackTree{element: y}) when x == y, do: true
  def member?(x, %RedBlackTree{element: y, left: left}) when x < y do
    member?(x, left)
  end
  def member?(x, %RedBlackTree{element: y, right: right}) when x > y do
    member?(y, right)
  end

  defp do_insert(x, nil), do: %RedBlackTree{color: :red, element: x}
  defp do_insert(x, %RedBlackTree{color: color, left: left, element: y, right: right}) when x < y, do: do_balance(color, do_insert(x, left), y, right)
  defp do_insert(x, %RedBlackTree{color: color, left: left, element: y, right: right}) when x > y, do: do_balance(color, left, y, do_insert(x, right))
  defp do_insert(x, t = %RedBlackTree{element: x}), do: t
  def insert(x, t) do
    tree = %RedBlackTree{left: left, element: element, right: right} = do_insert(x, t)
    Map.put(tree, :color, :black)
  end

  defp do_balance(:black, left = %RedBlackTree{color: :red, left: sub_left = %RedBlackTree{color: :red}, element: sub_element, right: sub_right}, element, right) do
    %RedBlackTree{color: :red, left: Map.put(sub_left, :color, :black), element: sub_element, right: %RedBlackTree{color: :black, left: sub_right, element: element, right: right}}
  end

end

defmodule RedBlackTreeTest do
  use ExUnit.Case

  test "member?" do
    assert RedBlackTree.member?(1, %RedBlackTree{element: 1}) == true
  end
end
