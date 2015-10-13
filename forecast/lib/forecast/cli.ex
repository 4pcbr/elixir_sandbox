defmodule Forecast.CLI do

  import Forecast.Formatter, only: [
    print_table_for_columns: 2,
  ]

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  def parse_args(args) do

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
      |> print_table_for_columns([])
  end

  def decode_response({ :error, reason }) do
    IO.puts "Error fetching the forecast feed: #{reason}"
    System.halt(2)
  end
  def decode_response({ :ok, body }), do: body

end

