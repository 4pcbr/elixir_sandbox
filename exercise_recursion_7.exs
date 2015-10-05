defmodule MyList do

  def span(to, to), do: [to]
  def span(wrong_from, wrong_to) when wrong_from > wrong_to, do: span(wrong_to, wrong_from)
  def span(from, to), do: [from | span(from + 1, to)]

end

defmodule IsPrime do

  def is_prime(1) do; true; end
  def is_prime(2) do; true; end
  def is_prime(n) do
    length(
      for x <- 2..n - 1, rem( n, x ) == 0, do: x
    ) == 0
  end

  def primes_upto(n) when n < 2 do
    throw "N should be more or equal to 2"
  end

  def primes_upto(n) do
    for x <- MyList.span( 2, n ), is_prime(x), do: x
  end
end

