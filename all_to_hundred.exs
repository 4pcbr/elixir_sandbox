defmodule Permutations do
  def calc_permutations(range, total_sum) do
    do_calc([], {0, 0}, Enum.to_list(range), total_sum)
  end

  defp do_calc(stack, {sum, pending}, [], total_sum) when sum + pending == total_sum do
    [stack |> Enum.reverse |> Enum.join(" ")]
  end

  defp do_calc(_, _, [], _), do: []

  defp do_calc([], {0, 0}, [ head | tail ], total_sum) do
    do_calc([head], {0, head}, tail, total_sum)
  end

  defp do_calc(stack= [ stack_head | stack_tail ], { sum, pending }, [ head | tail ], total_sum) do
    do_calc([ signed_shift(stack_head, head) | stack_tail ], { sum, signed_shift(pending, head) }, tail, total_sum) ++
    do_calc([ head, "+" | stack ], { sum + pending, head }, tail, total_sum) ++
    do_calc([ head, "-" | stack ], { sum + pending, -1 * head}, tail, total_sum)
  end

  defp signed_shift(num1, num2) when num1 < 0, do: num1 * 10 - num2
  defp signed_shift(num1, num2), do: num1 * 10 + num2
  
end

Permutations.calc_permutations(1..9, 100)
  |> Enum.sort
  |> Enum.join("\n")
  |> IO.puts
