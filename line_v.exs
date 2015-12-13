defmodule LineV do
  def sigil_v( lines, _opts ) do
    lines
      |> String.rstrip
      |> String.split("\n")
      |> Enum.map(&_parse_f(&1))
  end

  defp _parse_f( line ) do
    line
      |> String.split(",")
      |> Enum.map(fn(el)->
        case Float.parse(el) do
          { num, _tail } -> num
          :error         -> el
        end
      end)
  end

end

defmodule Example do
  import LineV, only: [ sigil_v: 2 ]
  def test_v do
    ~v"""
    a,b,c
    d,e,g,f
    1,2.1,3,5
    """
  end
end

IO.inspect Example.test_v
