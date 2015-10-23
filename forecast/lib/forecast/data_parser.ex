defmodule DataParser do

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
    location_attrs = elem(location_tag, 1) |> attrs_to_keywords
                      
    region = location_attrs |> Keyword.get(:region)
    #country = location_attrs |> Keyword.get(:country)
    city = location_attrs |> Keyword.get(:city)
    result = Map.put(result, :location, "#{city}, #{region}")

    [ units_tag ] = find(channel_tag, "channel.units")
    units = elem(units_tag, 1) |> attrs_to_keywords
    result = Map.put(result, :units, units)

    [ astronomy_tag ] = find(channel_tag, "channel.astronomy")
    astronomy = elem(astronomy_tag, 1) |> attrs_to_keywords
    result = Map.put(result, :astronomy, astronomy)

    result
  end

  

end

