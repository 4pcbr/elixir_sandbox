defmodule Array do

  def new(capacity, :boolean) when is_integer(capacity) and capacity >= 0 do
    { :array, :boolean, capacity, << 0 :: size(capacity) >> }
  end

  def new(capacity, :uint16) when is_integer(capacity) and capacity >= 0 do
    body_size = capacity * 16
    { :array, :uint16, capacity, << 0 :: size(body_size) >> }
  end

  def new(capacity, :int16) when is_integer(capacity) and capacity >= 0 do
    body_size = capacity * 16
    { :array, :int16, capacity, << 0 :: size(body_size) >> }
  end

  def new(capacity, :uint32) when is_integer(capacity) and capacity >= 0 do
    body_size = capacity * 32
    { :array, :uint32, capacity, << 0 :: size(body_size) >> }
  end

  def new(capacity, :int32) when is_integer(capacity) and capacity >= 0 do
    body_size = capacity * 32
    { :array, :int32, capacity, << 0 :: size(body_size) >> }
  end

  def new(capacity, :uint64) when is_integer(capacity) and capacity >= 0 do
    body_size = capacity * 64
    { :array, :uint64, capacity, << 0 :: size(body_size) >> }
  end

  def new(capacity, :int64) when is_integer(capacity) and capacity >= 0 do
    body_size = capacity * 64
    { :array, :int64, capacity, << 0 :: size(body_size) >> }
  end

  def set(arr = { :array, :boolean, capacity, body }, pos, true) when pos >= 0 and pos < capacity do
    :erlang.setelement(4, arr, :erlang.band(body, :erlang.bsl(1, pos)))
  end

  def set(arr = { :array, :boolean, capacity, body }, pos, false) when pos >= 0 and pos < capacity do
    :erlang.setelement(4, arr, :erlang.bor(body, :erlang.bnot(:erlang.bsl(1, pos))))
  end

  def set(arr = { :array, :int32, capacity, body }, pos, val) when pos >= 0 and pos < capacity do
    pre_size = pos * 32
    << pre :: size(pre_size), _ :: size(32), post :: binary >> = body
    :erlang.setelement(4, arr, << pre :: size(pre_size), val :: size(32), post :: binary >>)
  end

  def get({ :array, :boolean, capacity, body }, pos) when pos >= 0 and pos < capacity do
    case :erlang.band(1, :erlang.bsr(body, pos)) do
      1 -> true
      0 -> false
    end
  end

  def get({ :array, :int32, capacity, body }, pos) when pos >= 0 and pos < capacity do
    pre_size = pos * 32
    << _pre :: size(pre_size), val :: signed-integer-size(32), _rest :: binary >> = body
    val
  end

end

ExUnit.start
defmodule ArrayTest do
  use ExUnit.Case

  test "new boolean zero size" do
    assert Array.new(0, :boolean) == { :array, :boolean, 0, <<>> }
  end

  test "new boolean 1 element" do
    assert Array.new(1, :boolean) == { :array, :boolean, 1, << 0 :: size(1) >> }
  end

  test "new int32 zero size" do
    assert Array.new(0, :int32) == { :array, :int32, 0, <<>> }
  end

  test "new int32 1 element" do
    assert Array.new(1, :int32) == { :array, :int32, 1, << 0, 0, 0, 0 >> }
  end

  test "get int32 oct1 pos 0/1" do
    arr = Array.new(1, :int32) |> Array.set(0, 42)
    assert Array.get(arr, 0) == 42
  end

  test "get int32 oct2 pos 0/1" do
    arr = Array.new(1, :int32) |> Array.set(0, 1024)
    assert Array.get(arr, 0) == 1024
  end

  test "get int32 oct1 pos 1/3" do
    arr = Array.new(3, :int32) |> Array.set(1, 42)
    assert Array.get(arr, 0) == 0
    assert Array.get(arr, 1) == 42
    assert Array.get(arr, 2) == 0
  end

  test "get int32 oct2 pos 1/3" do
    arr = Array.new(3, :int32) |> Array.set(1, 1024)
    assert Array.get(arr, 0) == 0
    assert Array.get(arr, 1) == 1024
    assert Array.get(arr, 2) == 0
  end
end
