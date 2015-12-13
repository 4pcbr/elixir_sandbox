ExUnit.start()

defmodule CSVAttrParser do
  @parsers %{
    Qty:   &Integer.parse/1,
    Price: &Float.parse/1,
  }
  def parse(v, as) do
    case Map.has_key?(@parsers, as) do
      true  -> @parsers[ as ].(v)
      false -> v
    end
  end
end


defmodule CSVParser do
  def sigil_v( lines, _opts ) do
    lines
      |> String.rstrip
      |> String.split("\n")
      |> Enum.map(&String.split(&1,","))
      |> _as_csv
  end

  defp _as_csv( data ) do
    [ head | body ] = data
    head = Enum.map(head, &String.to_atom(&1))
    body
      |> Enum.map(fn(line) ->
        0..(length( line ) - 1)
          |> Enum.map(fn( ix ) ->
            as = Enum.at( head, ix )
            v = CSVAttrParser.parse( Enum.at( line, ix ), as )
            v = case v do
              { parsed_v, _ } -> parsed_v
              :error          -> v
              v               -> v
            end
            { as, v }
          end)
      end)
  end

end

defmodule CSVParserTest do
  use ExUnit.Case
  import CSVParser, only: [ sigil_v: 2 ]
  
  test "Should parse inline CSV with sigil ~v" do

    expected_res = [
      [ Item: "Teddy bear", Qty: 4, Price: 34.95 ],
      [ Item: "Milk",       Qty: 1, Price:  2.99 ],
      [ Item: "Battery",    Qty: 6, Price:  8.00 ],
    ]

    res = ~v"""
    Item,Qty,Price
    Teddy bear,4,34.95
    Milk,1,2.99
    Battery,6,8.00
    """

    assert expected_res == res
  end

end

ExUnit.run()
