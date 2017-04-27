raw_results= %{
  176 => [
    %{
      price: 120,
      policies: ~w(breakfast refundable),
      availability: 5,
    },
  ],
  177 => [
    %{
      price: 120,
      policies: ~w(breakfast refundable),
      availability: 1,
    },
    %{
      price: 130,
      policies: ~w(wifi breakfast),
      availability: 3,
    },
    %{
      price: 150,
      policies: ~w(wifi breakfast refundable),
      availability: 7,
    },
  ],
}

checkin = 176
checkout = 177
features = ~w(breakfast)
feature_set = :sets.from_list(features)
case (checkin .. checkout)
  |> Enum.reduce([], fn day, acc ->
    case Map.get(raw_results, day) do
      nil -> raise "Day #{day} is missing in raw results"
      day_feed -> [ day_feed |> Enum.filter(fn %{policies: policies} -> :sets.is_subset(feature_set, :sets.from_list(policies)) end) | acc ]
    end
  end) |> List.pop_at(0) do
    {nil, _} -> raise "Empty resultset"
    {head, []} -> head
    {head, tail} ->
      tail |> Enum.reduce(
        head |> Enum.map(fn block=%{policies: p} -> %{block | policies: :sets.from_list(p)} end),
        fn day_feed, acc ->
          for %{price: block_price, policies: block_policies, availability: block_availability} <- day_feed,
            %{price: merged_price, policies: merged_policies, availability: merged_availability} <- acc do
              %{
                price: block_price + merged_price,
                policies: :sets.intersection(merged_policies, :sets.from_list(block_policies)),
                availability: Enum.min([block_availability, merged_availability]),
              }
          end
        end) |> Enum.map(fn block=%{policies: policies} -> %{block | policies: :sets.to_list(policies)} end)
end |> Enum.sort(fn %{price: pr1, policies: po1}, %{price: pr2, policies: po2} ->
  case pr1 == pr2 do
    true -> length(po1) > length(po2)
    _ -> pr1 < pr2
  end
end) |> IO.inspect
