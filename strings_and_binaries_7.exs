defmodule Taxation do
  def with_tax( orders, tax ) do
    for order <- orders, do: order ++ [ total_amount: order[ :net_amount ] * ( 1 + ( tax[ order[ :ship_to ] ] || 0 ) ) ]
  end
end

defmodule Parser do

  def parse_line( line, header ) do
    values = String.split( String.strip( line ), "," )
    for ix <- 0..length( values ) - 1, do: { Enum.at(header, ix), _parse_value( Enum.at(values, ix), Enum.at(header, ix) ) }
  end

  def _parse_value( value, :id ) do; String.to_integer value; end
  def _parse_value( value, :ship_to ) do; String.to_atom String.slice( value, 1, 2 ); end
  def _parse_value( value, :net_amount ) do; String.to_float value; end
  def _parse_value( _, unknown_key ) do; raise "Unknown key: #{unknown_key}"; end

end

stream = File.stream!( "taxes.dat", [ :read, :utf8 ] )
header = stream
          |> Enum.take(1)
            |> List.first
              |> String.strip
                |> String.split(",")
                  |> Enum.map &String.to_atom/1
data_stream = Stream.drop( stream, 1 )

orders = Enum.map data_stream, fn( line ) ->
  Parser.parse_line( line, header )
end

tax_rates = [ NC: 0.075, TX: 0.08 ]

IO.inspect Taxation.with_tax( orders, tax_rates )
