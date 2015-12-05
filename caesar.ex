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

File.stream!( "words/scowl/final/english-words.95", [], :line )
  |> Stream.map( fn word ->
    word = String.strip word
    { String.length( word ), word }
  end)
  |> Enum.reduce(%{}, fn( { w_len, word }, acc ) ->
    { _, acc } = Map.get_and_update( acc, w_len, fn old_acc ->
      { old_acc, [ word | ( old_acc || [] ) ] }
    end)
    acc
  end)
  |> Enum.map( fn { _w_len, coll } ->
    hash_dict = Enum.reduce( coll, HashDict.new, fn word, acc ->
      HashDict.put( acc, word, true )
    end)
    coll
      |> Enum.filter( fn ( word ) ->
        (!String.match?( word, ~r/'/)) && HashDict.has_key?( hash_dict, Caesar.rot13( word ) )
      end)
  end)
  |> List.flatten
  |> IO.inspect( limit: :infinity )
