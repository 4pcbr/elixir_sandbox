defmodule Forecast.Formatter.Widgets.WeekWidget do

  import Forecast.Formatter, only: [
    concat: 2,
    join_glyphs: 4,
    str_to_glyph: 1,
  ]

  def template do
    """
    |              |              |              |              |              |
    |              |              |              |              |              |
    |              |              |              |              |              |
    |              |              |              |              |              |
    |              |              |              |              |              |
    └--------------┴--------------┴--------------┴--------------┴--------------┘
    """
  end

  def render_data(data) when is_map(data) do
    #XXX
  end

  def render_data(_), do: raise "The argument should be a map"


end

