defimpl Inspect, for: Map do

  # defp _format(v) when is_binary(v), do: "\"#{v}\""
  # defp _format(v) when is_atom(v), do: ":#{v}"
  # defp _format(v), do: inspect v

  def inspect( map, _opts ) do
    body = Map.to_list( map )
      |> Enum.map(fn({ k, v }) ->
        "#{k}: #{inspect v}"
      end)
      |> Enum.join(", ")
    "%{#{body}}"
  end

  def inspect( struct, name, _opts ) do
    body = Map.to_list( struct )
      |> Enum.map(fn({ k, v }) ->
        "#{k}: #{inspect v}"
      end)
      |> Enum.join(", ")
    "%#{name}{#{body}}"
  end

end

defmodule TestStruct do
  defstruct a: 1,
            b: "two",
            c: :three,
            d: [ 1, 2 , 3, 4 ],
            e: { :a, "b", [ :c ] },
            f: %{ a: 1 }
end


regular_map = %{ a: 1, b: "two", c: :three, d: [ 1,2,3,4 ], e: { :a, "b", [:c] }, f: %{ a: 1 } }
IO.inspect regular_map
# struct_map = %TestStruct{ a: 2, c: "asd", f: %TestStruct{ a: 0 } }
