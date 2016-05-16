defmodule Forecast.DataParser do

  import Forecast.DotPath, only: [
    find: 2,
    attrs_to_keywords: 1,
  ]

  def parse_response(response) do
    result = %{}

    [ channel_tag ] = find(response, "query.results.channel")

    [ title_tag ] = find(channel_tag, "channel.title")
    [ title ] = elem(title_tag, 2)

    result = Map.put(result, :title, List.to_string(title))

    [ location_tag ] = find(channel_tag, "channel.location")
    location_attrs = elem(location_tag, 1) |> attrs_to_keywords |> charlist_to_str_in_kw
                      
    region = location_attrs |> Keyword.get(:region)
    city   = location_attrs |> Keyword.get(:city)
    result = Map.put(result, :location, "#{city}, #{region}")

    [ units_tag ] = find(channel_tag, "channel.units")
    units = elem(units_tag, 1) |> attrs_to_keywords |> charlist_to_str_in_kw
    result = Map.put(result, :units, units)

    [ astronomy_tag ] = find(channel_tag, "channel.astronomy")
    astronomy = elem(astronomy_tag, 1) |> attrs_to_keywords |> charlist_to_str_in_kw
    result = Map.put(result, :astronomy, astronomy)

    [ condition_tag ] = find(channel_tag, "channel.item.condition")
    condition = elem(condition_tag, 1) |> attrs_to_keywords
    condition_text = condition |> Keyword.get(:text)
    condition_temp = condition |> Keyword.get(:temp)
    temp_units = units |> Keyword.get(:temperature)
    temp_sign = case List.to_integer(condition_temp) > 0 do
      true -> '+'
      false -> ''
    end
    result = result
              |> Map.put(:conditions, "#{condition_text}")
              |> Map.put(:temperature, "#{temp_sign}#{condition_temp} °#{temp_units}")

    [ atmosphere_tag ] = find(channel_tag, "channel.atmosphere")
    atmosphere = elem(atmosphere_tag, 1) |> attrs_to_keywords
    humidity   = atmosphere |> Keyword.get(:humidity)
    pressure   = atmosphere |> Keyword.get(:pressure)   |> List.to_float |> round
    visibility = atmosphere |> Keyword.get(:visibility) |> List.to_string
    pressure_units = units  |> Keyword.get(:pressure)

    week = find(channel_tag, "channel.item.forecast")
                  |> Enum.slice(0..4)
                  |> Enum.map fn (el) ->
                    day = elem(el, 1) |> attrs_to_keywords
                    [
                      text: Keyword.get(day, :text) |> List.to_string,
                      day:  Keyword.get(day, :day)  |> List.to_string,
                      low:  Keyword.get(day, :low)  |> List.to_string,
                      high: Keyword.get(day, :high) |> List.to_string,
                      date: Keyword.get(day, :date) |> List.to_string,
                    ]
                  end

    [ wind_tag ] = find(channel_tag, "channel.wind")
    wind = elem(wind_tag, 1) |> attrs_to_keywords
    wind_speed     = wind  |> Keyword.get(:speed)     |> List.to_float |> round
    wind_direction = wind  |> Keyword.get(:direction) |> List.to_integer
    wind_units     = units |> Keyword.get(:speed)
    direction = case step_func([ 0, 45, 90, 135, 180, 225, 270, 315, 360 ], wind_direction - 22) do
      0   -> '↑'
      45  -> '↗'
      90  -> '→'
      135 -> '↘'
      180 -> '↓'
      225 -> '↙'
      270 -> '←'
      315 -> '↖'
      360 -> '↑'
    end

    wind = "#{direction} #{wind_speed}#{wind_units}"

    result = result
              |> Map.put(:humidity, "#{humidity}%")
              |> Map.put(:pressure, "#{pressure}#{pressure_units}")
              |> Map.put(:visibility, visibility)
              |> Map.put(:week, week)
              |> Map.put(:wind, wind)


    result
  end

  def step_func(steps, value) do
    steps
      |> Enum.sort
      |> Enum.drop_while(&(value > &1))
      |> List.first
  end

  def charlist_to_str_in_kw(kw) do
    kw |> Enum.map fn(tpl) ->
      { elem(tpl, 0), List.to_string(elem(tpl, 1)) }
    end
  end

end

