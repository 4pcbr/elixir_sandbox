defmodule Forecast.Formatter do

  def print_table_for_columns(data, headers) do
    #XXX
  end

  def new_canvas(width, height, background \\ ' ') when length(background) == 1 do
    List.duplicate(List.first(background), width)
      |> List.duplicate(height)
  end

  def str_to_glyph(str_glyph) when is_binary(str_glyph) do
    str_glyph
      |> String.split("\n")
      |> Enum.reverse
      |> List.delete_at(0)
      |> Enum.reverse
      |> Enum.map(&(String.to_char_list(&1)))
  end

  def stringify_glyph(glyph, str_nl \\ "\n") do
    res = glyph
      |> Enum.map(&List.to_string/1)
      |> Enum.join str_nl
    "#{res}\n"
  end

  def render(glyph, pos_x, pos_y, canvas) when is_binary(glyph) do
    render(str_to_glyph(glyph), pos_x, pos_y, canvas)
  end

  def render(glyph, pos_x, pos_y, canvas) do
    stringify_glyph join_glyphs(glyph, pos_x, pos_y, canvas)
  end

  def join_glyphs(glyph, pos_x, pos_y, canvas) do
    Enum.slice(canvas, 0, pos_y) ++ _render(glyph, pos_x, 
                                      Enum.drop(canvas, pos_y))
  end

  def concat(glyph1, glyph2) when length(glyph1) == length(glyph2) do
    _concat(glyph1, glyph2)
  end

  def concat(glyph1, glyph2), do: raise "Glyphs should be the same y-size"

  defp _concat([], []) do
    []
  end

  defp _concat([line1 | rest1], [line2 | rest2]) do
    [ line1 ++ line2 ] ++ _concat(rest1, rest2)
  end


  defp _render(_, _, []) do
    []
  end

  defp _render([], offset, [line | rest]) do
    [ line ] ++ _render([], offset, rest)
  end

  defp _render([glyph_line | glyph_rest], offset, [line | rest]) do
    [ EnumExt.replace_mult(line, offset, glyph_line) ] ++ _render(glyph_rest, offset, rest)
  end

end

