defmodule Block do
  defstruct price:        0,
            policies:     nil,
            availability: 0
end

defmodule SearchFeed do

  def search(raw_results, checkin, checkout, policies) do
    search_results = raw_results
                      |> Enum.into(%{}, fn ({day, blocks}) ->
                        {day, blocks |> Enum.map(fn %{price: price, policies: policies, availability: availability} ->
                          %Block{price: price, policies: :sets.from_list(policies), availability: availability}
                        end)}
                      end)
    do_search(checkin .. checkout |> Enum.to_list, :sets.from_list(policies), search_results)
      |> Enum.sort(fn b1, b2 ->
        case b1.price == b2.price do
          true -> :sets.size(b1.policies) < :sets.size(b2.policies)
          _ -> b1.price < b2.price
        end
      end)
  end

  defp do_search([], _, _), do: []
  defp do_search([day], features, raw_search_res) do
    case Map.get(raw_search_res, day) do
      nil -> []
      v -> filter_policies(v, features)
    end
  end
  defp do_search([day | tail], features, raw_search_res) do
    case Map.get(raw_search_res, day) do
      nil -> []
      v ->
        case filter_policies(v, features) do
          [] -> []
          blocks ->
            for block  <- blocks,
                merged <- do_search(tail, features, raw_search_res) do
                  %Block{
                    price:        block.price + merged.price,
                    policies:     :sets.intersection(block.policies, merged.policies),
                    availability: Enum.min([block.availability, merged.availability])
                  }
                end
        end
    end
  end

  defp filter_policies([], _), do: []
  defp filter_policies(blocks, features) do
    case :sets.size(features) do
      0 -> blocks
      _ ->
        blocks |>
          Enum.filter(fn %Block{policies: policies} ->
            :sets.size(:sets.intersection(features, policies)) > 0
          end)
    end
  end

end

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

SearchFeed.search(raw_results, 176, 177, ~w(breakfast)) |> IO.inspect
