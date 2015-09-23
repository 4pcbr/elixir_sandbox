defmodule MyList do

  def span(to, to), do: [to]
  def span(wrong_from, wrong_to) when wrong_from > wrong_to, do: span(wrong_to, wrong_from)
  def span(from, to), do: [from | span(from + 1, to)]

end

