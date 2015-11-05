defmodule MergeSort do
  defp _sort([]), do: []
  defp _sort([a]), do: [a]
  defp _sort([a, b]) when a > b, do: [ b, a ]
  defp _sort([a, b]), do: [ a, b ]
  defp _sort(list) do
    [left, right] = Enum.chunk(list, div(length(list), 2))
    [res, _, _] = _merge([], _sort(left), _sort(right))
    res
  end

  defp _merge(acc, [], []), do: [acc, [], []]
  defp _merge(acc, list1, []), do: [acc ++ list1, [], []]
  defp _merge(acc, [], list2), do: [acc ++ list2, [], []]

  defp _merge(acc, [ el1 | tail1 ], [ el2 | tail2 ]) when el1 > el2 do
    _merge( acc ++ [el2], [el1] ++ tail1, tail2 )
  end

  defp _merge(acc, [ el1 | tail1 ], [ el2 | tail2 ]) when el1 <= el2 do
    _merge( acc ++ [el1], tail1, [el2] ++ tail2 )
  end

  def sort(list) do
    _sort(list)
  end

end

