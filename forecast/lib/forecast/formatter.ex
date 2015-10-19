defmodule Forecast.Formatter do

  def print_table_for_columns(data, headers) do
    #XXX
  end

  def new_canvas(width, height, background \\ " ") do
    List.duplicate(background, width)
      |> List.duplicate(height)
  end

  def to_glyph(str_glyph) when is_binary(str_glyph) do
    str_glyph
      |> String.split("\n")
      |> Enum.reverse
      |> List.delete_at(0)
      |> Enum.reverse
      |> Enum.map(&(String.to_char_list(&1)))
  end

  def render(glyph, pos_x, pos_y, canvas) when is_binary(glyph) do
    render(to_glyph(glyph), pos_x, pos_y, canvas)
  end

  def render(glyph, pos_x, pos_y, canvas) do
    glyph_height = length(glyph)
    glyph_width = glyph
                    |> List.first
                    |> length
                    #IO.puts "Glyph: width: #{glyph_width}, height: #{glyph_height}"
  end

end

