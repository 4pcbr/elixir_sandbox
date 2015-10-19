defmodule EnumExtTest do
  use ExUnit.Case
  import EnumExt, only: [
    replace_mult: 3,
    replace_mult: 4,
  ]

  test "replace_mult: middle" do
    a = [ 1, 2, 3, 4, 5, 6, 7 ]
    b = [ 7, 6, 5, 4 ]
    c = EnumExt.replace_mult(a, 3..4, b)
    assert c == [ 1, 2, 3, 7, 6, 5, 4, 6, 7 ]
  end

  test "replace_mult in the beginning" do
    a = [1,2,3,4,5,6,7]
    b = [9,8,7]
    c = replace_mult(a, 0..1, b)
    assert c == [9,8,7,3,4,5,6,7]
  end

  test "replace_mult in the end" do
    a = [1,2,3,4,5]
    b = [9,8,7]
    c = replace_mult(a, -1..-2, b)
    assert c == [1,2,3,9,8,7]
  end

end

