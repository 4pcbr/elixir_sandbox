defmodule WeekWidgetTest do

  use ExUnit.Case

  import Forecast.Formatter.Widgets.WeekWidget, only: [
    render_data: 1,
    render_day_data: 2,
  ]

  import Forecast.Formatter, only: [
    stringify_glyph: 1,
  ]

  import Forecast.DataParser, only: [
    charlist_to_str_in_kw: 1,
  ]

  import Forecast.DotPath, only: [
    attrs_to_keywords: 1,
  ]

  def sample_data do
    %{
      title: "Yahoo! Weather - Amsterdam, NL",
      units: [ temperature: "C",  speed: "km/h", pressure: "mb", distance: "km" ],
      wind: "↓ 21km/h",
      visibility: "2.3",
      pressure: "982mb",
      humidity: "100%",
      astronomy: [ sunset: "6:32 pm", sunrise: "8:13 am" ],
      conditions: "Light Drizzle",
      temperature: "+11 °C",
      location: "Amsterdam, NH",
      week: [
        [ text: "Cloudy",        day: "Wed", low: "11", high: "13", date: "21 Oct 2015" ],
        [ text: "AM Showers",    day: "Thu", low: "9",  high: "14", date: "22 Oct 2015" ],
        [ text: "Mostly Sunny",  day: "Fri", low: "8",  high: "14", date: "23 Oct 2015" ],
        [ text: "Mostly Cloudy", day: "Sat", low: "10", high: "13", date: "24 Oct 2015" ],
        [ text: "AM Light Rain", day: "Sun", low: "7",  high: "12", date: "25 Oct 2015" ],
      ],
    }
  end

  def sample_week_data do
    Map.get(sample_data, :week)
  end

  def sample_units do
    [ temperature: "C",  speed: "km/h", pressure: "mb", distance: "km" ]
  end


  test "render_day_data" do
    day_data = List.first(sample_week_data)
    result = render_day_data(day_data, sample_units)
    assert stringify_glyph(result) == """
    21 Oct 2015   
    Wed           
    Cloudy        
    ↑ 13 °C       
    ↓ 11 °C       
    """
  end

  test "render_data" do
    result = render_data(sample_data)
    assert stringify_glyph(result) == """
    |21 Oct 2015   |22 Oct 2015   |23 Oct 2015   |24 Oct 2015   |25 Oct 2015   |
    |Wed           |Thu           |Fri           |Sat           |Sun           |
    |Cloudy        |AM Showers    |Mostly Sunny  |Mostly Cloudy |AM Light Rain |
    |↑ 13 °C       |↑ 14 °C       |↑ 14 °C       |↑ 13 °C       |↑ 12 °C       |
    |↓ 11 °C       |↓ 9 °C        |↓ 8 °C        |↓ 10 °C       |↓ 7 °C        |
    └--------------┴--------------┴--------------┴--------------┴--------------┘
    """
  end


end

