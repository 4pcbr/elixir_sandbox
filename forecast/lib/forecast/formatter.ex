defmodule Forecast.Formatter do

  def new_canvas(width, height, background \\ ' ') when length(background) == 1 do
    List.duplicate(List.first(background), width)
      |> List.duplicate(height)
  end

  def str_to_glyph(str_glyph) when is_binary(str_glyph) do
    str_glyph
      |> String.strip(10) # the newline char
      |> String.split("\n")
      |> Enum.map(&(String.to_char_list(&1)))
  end

  def stringify_glyph(glyph, str_nl \\ "\n") do
    res = glyph
      |> Enum.map(&List.to_string/1)
      |> Enum.join str_nl
    "#{res}\n"
  end

  #def render(canvas, pos_x, pos_y, glyph) when is_binary(glyph) do
  #  render(canvas, pos_x, pos_y, str_to_glyph(glyph))
  #end

  #def render(canvas, pos_x, pos_y, glyph) do
  #  stringify_glyph join_glyphs(canvas, pos_x, pos_y, glyph)
  #end

  def join_glyphs(canvas, pos_x, pos_y, glyph) do
    Enum.slice(canvas, 0, pos_y) ++ _render(Enum.drop(canvas, pos_y), pos_x, glyph)
  end

  def concat(glyph, []), do: glyph
  def concat([], glyph), do: glyph

  def concat(glyph1, glyph2) when length(glyph1) == length(glyph2) do
    _concat(glyph1, glyph2)
  end

  def concat(glyph1, glyph2), do: raise "Glyphs should be the same y-size"

  defp _concat([], []), do: []
  defp _concat([line1 | rest1], [line2 | rest2]) do
    [ line1 ++ line2 ] ++ _concat(rest1, rest2)
  end


  defp _render([], _, _) do
    []
  end

  defp _render([line | rest], offset, []) do
    [ line ] ++ _render(rest, offset, [])
  end

  defp _render([line | rest], offset, [glyph_line | glyph_rest]) do
    [ EnumExt.replace_mult(line, offset, glyph_line) ] ++ _render(rest, offset, glyph_rest)
  end

end

