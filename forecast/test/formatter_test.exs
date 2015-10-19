defmodule FormatterTest do
  use ExUnit.Case
  import Forecast.Formatter, only: [
    new_canvas: 2,
    new_canvas: 3,
  ]

  test "new canvas initialization" do

    width = 10
    height = 15

    canvas = new_canvas(width, height)

    assert length(canvas) == height

    assert length(List.first(canvas)) == width

  end

  test "new canvas initialization with background" do
    width = 10
    height = 15
    background = "#"
    canvas = new_canvas(width, height, background)
    assert List.first(canvas) == List.duplicate(background, width)
  end


end

