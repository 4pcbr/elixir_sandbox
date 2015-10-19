defmodule EnumExt do
  
  def replace_mult(list, start, to_replace, replacement) when start >= 0 and to_replace >= 0 do
    Enum.slice(list, 0, start) ++
    replacement ++
    Enum.slice(list, start + to_replace..length(list) - 1)
  end

  def replace_mult(_, _, to_replace, _) when to_replace <= 0, do: []

  def replace_mult(list, start, to_replace, replacement) when start < 0 do
    replace_mult(list, length(list) - 1 + start, to_replace, replacement)
  end


  def replace_mult(list, start..finish, replacement) do
    replace_mult(list, start, abs(finish - start) + 1, replacement)
  end

end
