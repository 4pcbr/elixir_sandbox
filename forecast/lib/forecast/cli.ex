defmodule Forecast.CLI do

  import Forecast.Formatter.Widgets.ForecastWidget, only: [
    render_data: 1,
  ]

  import Forecast.DataParser, only: [
    parse_response: 1,
  ]

  import Forecast.Formatter, only: [
    stringify_glyph: 1,
  ]

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  def parse_args( argv ) do
    parse = OptionParser.parse(
      argv,
      switches: [ help: :boolean ],
      aliases: [ :h, :help ]
    )
    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ location ], _ } -> { location }
      _ -> :help
    end
  end
    

  def process(:help) do
    IO.puts """
    usage: forecast <location>
    """
    System.halt(0)
  end

  def process(location) do
    Forecast.Fetcher.fetch(location)
      |> decode_response
      |> render_data
      |> stringify_glyph
      |> IO.puts
  end

  def decode_response({ :error, reason }) do
    IO.puts "Error fetching the forecast feed: #{reason}"
    System.halt(2)
  end
  def decode_response({ :ok, body }), do: parse_response(body)

end

