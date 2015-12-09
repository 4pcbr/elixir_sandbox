defmodule Bitmap do
  defstruct value: 0

  defimpl Enumerable do
    import :math, only: [ log: 1 ]
    def count( %Bitmap{ value: value } ) do
      { :ok, trunc( log( abs( value ) ) / log( 2 ) ) + 1 }
    end

    def member?( value, bit_number ) do
      { :ok, 0 <= bit_number && bit_number < Enum.count( value ) }
    end

    def reduce( bitmap, { :cont, acc }, fun ) do
      bit_count = Enum.count( bitmap )
      _reduce( { bitmap, bit_count }, { :cont, acc }, fun )
    end

    defp _reduce({ bitmap, -1 }, { :cont, acc }, _fun ), do: { :done, acc }
    defp _reduce({ bitmap, bit_number }, { :cont, acc }, fun ) do
      _reduce({ bitmap, bit_number - 1 }, fun.( bitmap[ bit_number ], acc ), fun )
    end
    defp _reduce({ _bitmap, _bit_number }, { :halt, acc }, _fun), do: { :halted, acc }
    defp _reduce({ bitmap, bit_number }, { :suspend, acc }, fun), do: { :suspended, acc, &_reduce({ bitmap, bit_number }, &1, fun), fun }


  end

end

fifty = %Bitmap{ value: 50 }
IO.puts Enum.count fifty

IO.inspect Enum.reverse fifty
IO.inspect Enum.join fifty, ":"
