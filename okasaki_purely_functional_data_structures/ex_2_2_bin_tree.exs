ExUnit.start()

defmodule BinTree do
  defstruct element: nil, left: nil, right: nil

  def member?(_, nil), do: false
  def member?(x, %BinTree{element: element, left: left}) when x < element and left == nil, do: false
  def member?(x, %BinTree{element: element, left: left}) when x < element, do: member?(x, left)
  def member?(x, %BinTree{element: element, right: right}) when x > element and right == nil, do: false
  def member?(x, %BinTree{element: element, right: right}) when x > element, do: member?(x, right)
  def member?(_, %BinTree{}), do: true

  def insert(x, nil), do: %BinTree{element: x}
  def insert(x, tree = %BinTree{element: x}), do: tree
  def insert(x, tree = %BinTree{element: element, left: left}) when x < element do
    Map.put(tree, :left, insert(x, left))
  end
  def insert(x, tree = %BinTree{element: element, right: right}) when x > element do
    Map.put(tree, :right, insert(x, right))
  end
end

defmodule BinTreeTest do
  use ExUnit.Case

  test "checks membership" do
    assert BinTree.member?(1, %BinTree{element: 1}) == true
    assert BinTree.member?(1, %BinTree{element: 0, left: %BinTree{element: -1}, right: %BinTree{element: 1}})
    assert BinTree.member?(1, nil) == false
    assert BinTree.member?(1, %BinTree{element: 0}) == false
    tree = %BinTree{
      element: 1,
      left: %BinTree{
        element: -1,
        left: %BinTree{
          element: -2
        },
        right: %BinTree{
          element: 0
        }
      },
      right: %BinTree{
        element: 3,
        left: %BinTree{
          element: 2
        },
        right: %BinTree{
          element: 4
        }
      }
    }
    (-2 .. 4) |> Enum.each(fn el -> assert BinTree.member?(el, tree) == true end)
  end

  test "inserts values" do
    assert BinTree.insert(1, nil) == %BinTree{element: 1}
    assert BinTree.insert(1, %BinTree{element: 2}) == %BinTree{element: 2, left: %BinTree{element: 1}}
    assert BinTree.insert(3, %BinTree{element: 2}) == %BinTree{element: 2, right: %BinTree{element: 3}}
  end
end
