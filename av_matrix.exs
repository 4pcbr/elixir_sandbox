defmodule Policies do

  @policies ~w(breakfast refundable wifi seaview)

  @p_to_m @policies |> Enum.with_index() |> Enum.map(fn {p, ix} -> {p, :erlang.bsl(1, ix)} end) |> Enum.into(%{})

  @m_to_p @p_to_m |> Enum.map(fn {p, m} -> {m, p} end) |> Enum.into(%{})


  def to_mask([]), do: 0
  def to_mask([policy | tail]) do
    Map.get(@p_to_m, policy, 0)
      |> :erlang.bor(to_mask(tail))
  end
  def to_mask(p), do: to_mask([p])


  def from_mask(0, _), do: []
  def from_mask(mask, offset) do
    add= case :erlang.band(mask, 0b1) do
      1 -> [Map.get(@m_to_p, :erlang.bsl(1, offset))]
      0 -> []
    end
    add ++ from_mask(:erlang.bsr(mask, 1), offset + 1)
  end


  def match?(requested, _fact) when requested == 0, do: true
  def match?(requested, fact), do: requested == fact

end

defmodule AvMatrix do

  import Policies, only: [to_mask: 1, from_mask: 2]

  def search(dataset, checkin, checkout, hard_policies), do: search(dataset, checkin, checkout, hard_policies, 0)

  def search(dataset, checkin, checkout, hard_policies, soft_policies) do
    search_dataset= for day <- checkin..checkout, Map.has_key?(dataset, day) do
      Map.get(dataset, day)
        |> Enum.map(fn block ->
          {_, block}= Map.get_and_update(block, :features, fn fl ->
            {fl, to_mask(fl)}
          end)
          block
        end)
    end
    case length(search_dataset) == checkout - checkin + 1 do
      true ->
        _do_search(
          search_dataset,
          to_mask(hard_policies)
        )
        |> Enum.sort(fn %{price: p1, features: f1}, %{price: p2, features: f2} ->
          case p1 do
            v when v == p2 ->
              f1 - soft_policies < f2 - soft_policies
            _ ->
              p1 < p2
          end
        end)
        |> Enum.map(fn block ->
          {_, block}= Map.get_and_update(block, :features, fn f ->
            {f, from_mask(f, 0)}
          end)
          block
        end)
      _ ->
        {:error, :req_range_unknwn}
    end
  end

  defp _do_search([], _), do: []
  defp _do_search([day | tail], policies) do
    day_blocks= day
      |> Enum.reduce([], fn block= %{features: features}, acc ->
        case features - policies >= 0 do
          true -> acc ++ [block]
          _ -> acc
        end
      end)
    tail_blocks= _do_search(tail, policies)
    case length(tail_blocks) do
      v when v == 0 -> day_blocks
      _ ->
        for %{features: f1, price: p1} <- day_blocks, %{features: f2, price: p2} <- tail_blocks do
          %{
            features: :erlang.band(f1, f2),
            price: p1 + p2
          }
        end
    end
  end

end

data= %{
  176 => [
    %{
      price: 120,
      features: ["breakfast", "refundable"],
      availability: 5,
    },
    %{
      price: 250,
      features: ["breakfast", "seaview"],
      availability: 2,
    }
  ],
  177 => [
    %{
      price: 120,
      features: ["breakfast", "refundable"],
      availability: 1,
    },
    %{
      price: 130,
      features: ["wifi", "breakfast"],
      availability: 3,
    },
    %{
      price: 150,
      features: ["wifi", "breakfast", "refundable"],
      availability: 7,
    },
    %{
      price: 270,
      features: ["breakfast", "seaview"],
      availability: 1,
    }
  ],
}

ExUnit.start()

defmodule PoliciesTest do
  use ExUnit.Case, asunc: true
  import Policies, only: [from_mask: 2, to_mask: 1]

  test "to_mask" do
    assert to_mask("breakfast")  == 1
    assert to_mask("refundable") == 2
    assert to_mask("wifi")       == 4
    assert to_mask("seaview")    == 8
  end

  test "from_mask" do
    assert from_mask(1, 0) == ["breakfast"]
    assert from_mask(2, 0) == ["refundable"]
    assert from_mask(4, 0) == ["wifi"]
    assert from_mask(8, 0) == ["seaview"]
  end
end

defmodule AvMatrixTest do
  use ExUnit.Case, async: true
  import AvMatrix, only: [search: 4, search: 5]

  test "search 2 day with no variations and no policies" do
    dataset1= %{
      1 => [
        %{
          price: 120,
          features: ["breakfast", "refundable"],
          availability: 1,
        },
      ],
      2 => [
        %{
          price: 120,
          features: ["breakfast", "refundable"],
          availability: 1,
        },
      ],
    }

    assert search(dataset1, 1, 2, ["breakfast", "refundable"]) == [
      %{
        price: 240,
        features: ["breakfast", "refundable"],
      },
    ]

    dataset2= %{
      1 => [
        %{
          price: 120,
          features: ["refundable"],
          availability: 1,
        },
      ],
      2 => [
        %{
          price: 120,
          features: ["breakfast", "refundable"],
          availability: 1,
        },
      ],
    }

    assert search(dataset2, 1, 2, ["breakfast", "refundable"]) == []

    dataset3= %{
      1 => [
        %{
          price: 120,
          features: ["refundable", "breakfast"],
          availability: 1,
        },
      ],
      2 => [
        %{
          price: 120,
          features: ["breakfast", "refundable"],
          availability: 1,
        },
        %{
          price: 100,
          features: ["refundable"],
          availability: 1,
        },
        %{
          price: 90,
          features: ["breakfast"],
          availability: 1,
        },
      ],
    }

    assert search(dataset3, 1, 2, ["refundable"]) == [
      %{
        price: 220,
        features: ["refundable"],
      },
      %{
        price: 240,
        features: ["breakfast", "refundable"],
      },
    ]
  end

end

