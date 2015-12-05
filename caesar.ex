defprotocol Caesar do
  def encrypt( string, shift )
  def rot13( string )
end

defimpl Caesar, for: BitString do

  def encrypt( string, shift ) do
    string
      |> String.to_char_list
      |> Enum.map( &rot_ch(&1, shift) )
      |> List.to_string
  end

  defp rot_ch( ch, shift ) when [ch] >= 'a' and [ch] <= 'z' do
    ch = ch + shift
    if [ch] > 'z', do: ch = ch - 26
    ch
  end
  defp rot_ch( ch, shift ) when [ch] >= 'A' and [ch] <= 'Z' do
    ch = ch + shift
    if [ch] > 'Z', do: ch = ch - 26
    ch
  end

  def rot13( string ) do
    encrypt( string, 13 )
  end

end

import :file

hd = File.stream!( "words/scowl/final/english-words.10", [], :line )
  |> Stream.scan( %{}, fn( word, acc ) ->
    word = String.strip word
    w_len = String.length word
    Map.get_and_update( acc, w_len, fn( coll ) ->
      { coll, [ word | ( coll || [] ) ] }
    end )
  end )

IO.inspect hd
