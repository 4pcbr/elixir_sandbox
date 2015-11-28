defmodule Explain do

  @operators [
    { :'+', "add"      },
    { :'-', "subtract" },
    { :'*', "multiply" },
    { :'/', "divide"   },
  ]

  def get_prep( operator ) do
    case operator do
      :'*' -> "by "
      :'/' -> "by "
      _ -> ""
    end
  end


  def explain_expr({ operator, _, [ num1, num2 ] })
    when is_number( num1 ) and is_number( num2 ) do
    "#{Keyword.get(@operators, operator)} #{num1} and #{num2}"
  end

  def explain_expr({ operator, _, [ sub_expr, num2 ] }) when is_number( num2 ) do
    explain_expr(sub_expr) <> ", then #{Keyword.get(@operators, operator)} #{get_prep(operator)}#{num2}"
  end

  def explain_expr({ operator, meta, [ num1, sub_expr ] }) when is_number( num1 ) do
    explain_expr({ operator, meta, [ sub_expr, num1 ]})
  end

  defmacro explain( expr ) do
    do_expr = Keyword.get( expr, :do )
    IO.inspect expr
    IO.puts explain_expr(do_expr)
  end
end

defmodule Test do
  import Explain

  explain do: 2 + 3 * 4
end

