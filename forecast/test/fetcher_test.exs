defmodule FetcherTest do

  use ExUnit.Case
  import Forecast.Fetcher, only: [
    fetch_url: 1,
    parse_response: 1,
  ]

  test "it composes a propper fetch URL" do
    location = "TestLocation"
    assert fetch_url(location) == "https://query.yahooapis.com/v1/public/yql?q=select+%2A+from+weather.forecast+where+woeid+in+%28select+woeid+from+geo.places%281%29+where+text%3D%22TestLocation%22%29&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
  end

  test "It returns a parsed XML" do
    body = """
    <?xml version="1.0" encoding="UTF-8"?>
    <note>
      <to>Tove</to>
      <from>Jani</from>
      <heading>Reminder</heading>
      <body>Don't forget me this weekend!</body>
    </note>
    """
    { :ok, parsed_body, _ } = :erlsom.simple_form(body)
    { tag_name, attributes, nested_tags } = parsed_body
    assert tag_name == 'note'
    assert length(nested_tags) == 4
    assert [ 'to', 'from', 'heading', 'body' ] == Enum.map(nested_tags, fn({tag_name, _, _}) -> tag_name end)
  end

end

