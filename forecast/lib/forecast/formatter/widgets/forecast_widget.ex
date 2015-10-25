defmodule Forecast.Formatter.Widgets.ForecastWidget do

  alias Forecast.Formatter.Widgets.TodayWidget, as: TodayWidget
  alias Forecast.Formatter.Widgets.WeekWidget,  as: WeekWidget

  import Forecast.Formatter, only: [
    new_canvas: 2,
    join_glyphs: 4,
  ]

  def render_data(data) do
    {size_x, size_y} = size
    { _, offset_y } = TodayWidget.size
    new_canvas(size_x, size_y)
      |> join_glyphs(0, 0, TodayWidget.render_data(data))
      |> join_glyphs(0, offset_y, WeekWidget.render_data(data))
  end

  def size do
    { tw_size_x, tw_size_y } = TodayWidget.size
    { ww_size_x, ww_size_y } = WeekWidget.size
    { Enum.max([ tw_size_x, ww_size_x ]), tw_size_y + ww_size_y }
  end

end

