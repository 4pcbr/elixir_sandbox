defmodule Forecast.Formatter do

  def print_table_for_columns(data, headers) do
    #XXX
  end

  def new_canvas(width, height, background \\ " ") do
    List.duplicate(background, width)
      |> List.duplicate(height)
  end

  def render(glyph, pos_x, pos_y, canvas) when is_binary(glyph) do
    size_x = glyph
              |> List.first
              |> length
    size_y = length glyph
    glyph_matrix = glyph
                    |> String.split("\n")
                    |> Enum.reverse
                    |> List.remove_at(0)
                    |> Enum.reverse
                    |> Enum.map(&(String.split(&1, "")))
    #XXX 
  end

  def render(_, _, _, _), do: "Glyph should be a binary string"

end

