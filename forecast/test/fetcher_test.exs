defmodule FetcherTest do

  use ExUnit.Case
  import Forecast.Fetcher, only: [
    fetch_url: 1,
  ]

  test "it composes a propper fetch URL" do
    location = "TestLocation"
    assert fetch_url(location) == "https://query.yahooapis.com/v1/public/yql?q=select+%2A+from+weather.forecast+where+woeid+in+%28select+woeid+from+geo.places%281%29+where+text%3D%22TestLocation%22%29&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
  end


end

