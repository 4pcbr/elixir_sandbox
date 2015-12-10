defmodule Bitmap do
  defstruct value: 0

  defimpl String.Chars do
    def to_string( value ), do: Enum.join( value, "" )
  end

end

