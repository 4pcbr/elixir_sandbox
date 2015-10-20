defmodule FormatterTest do
  use ExUnit.Case
  import Forecast.Formatter, only: [
    new_canvas: 2,
    new_canvas: 3,
    str_to_glyph: 1,
    render: 4,
    stringify_glyph: 1,
    concat: 2,
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
    background = '#'
    canvas = new_canvas(width, height, background)
    assert List.first(canvas) == List.duplicate(List.first(background), width)
  end

  test "str_to_glyph" do
    str_glyph = """
    !@#
    $%^
    &*(
    """
    glyph = str_to_glyph(str_glyph)
    assert length(glyph) == 3
    assert List.first(glyph) == '!@#'
  end

  test "render" do
    glyph_str = """
    123
    456
    789
    """
    expected_render = """
         
         
     123 
     456 
     789 
         
    """
    glyph = str_to_glyph(glyph_str)
    canvas = new_canvas(5, 6)
    res = render(canvas, 1, 2, glyph)
    assert res == expected_render
  end

  test "stringify_glyph" do
    str_glyph = """
        ##  
        ##  
        ##  
        ##  
            
        ##  
        ##  
            
    """
    glyph = str_to_glyph(str_glyph)
    assert str_glyph == stringify_glyph(glyph)
  end

  test "concat" do
    str_glyph1 = """
    ##
    ##
    """
    str_glyph2 = """
    @@@
    @@@
    """
    expected_glyph = """
    ##@@@
    ##@@@
    """
    res_glyph = concat(
      str_to_glyph(str_glyph1),
      str_to_glyph(str_glyph2)
    )
    assert res_glyph == str_to_glyph(expected_glyph)
  end

end

