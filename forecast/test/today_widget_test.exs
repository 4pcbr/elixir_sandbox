defmodule TodayWidgetTest do

  use ExUnit.Case

  import Forecast.Formatter.Widgets.TodayWidget, only: [
    render_data: 1,
  ]

  import Forecast.Formatter, only: [
    stringify_glyph: 1,
  ]

  test "render_data" do
    expected_render = """
    ┌---------------------------------------------------------------------------┐
    |                                                                           |
    |  Mostly cloudy                                  ##     .#       .###.     |
    |                                                ###    .#        #   #     |
    |                                          #    ####   .#  #      #         |
    |                                        #####    ##   #####      #         |
    |                                          #      ##       #      #   #     |
    |                                                ####      #       ###      |
    |                                                                           |
    |                                                                           |
    |                                                                           |
    |  Humidity: 95%                                        Amsterdam, NL       |
    |  Wind: ↗15km/h                                                            |
    ├---------------------------------------------------------------------------┤
    """
    render = render_data %{
      temperature: "+14 C",
      humidity:    "95%",
      wind:        "↗15km/h",
      location:    "Amsterdam, NL",
      conditions:  "Mostly cloudy",
    }
    assert stringify_glyph(render) == expected_render
  end



end

