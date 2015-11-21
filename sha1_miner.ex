defmodule Sha1Miner do

  @timestamp :os.timestamp
                |> (fn({ macro, sec, _ }) ->
                  macro * 1_000_000 + sec
                end).()
  @timestamp_len 10

  defp make_blob( commit_obj ) do
    "commit #{byte_size( commit_obj )}\x00#{commit_obj}"
  end

  defp cur_hash do
    case System.cmd( "git", [ "rev-parse", "HEAD" ] ) do
      { hash, 0 } -> String.strip( hash )
      { error, error_code } -> 
        IO.puts error
        exit error_code
    end
  end

  defp cat_file( hash ) do
    case System.cmd( "git", [ "cat-file", "-p", hash ] ) do
      { blob, 0 } -> blob
      { error, error_code } ->
        IO.puts error
        exit error_code
    end
  end

  defp next_i_j( i, j ) when i < j and i - j == 1, do: { i + 1, 0 }
  defp next_i_j( i, j ) when i < j,                do: { i + 1, j }
  defp next_i_j( i, j ) when i == j,               do: { 0, j + 1 }
  defp next_i_j( i, j ) when i > j,                do: { i, j + 1 }

  defp sha1( key ), do: :crypto.hash( :sha, key )

  defp parse_commit_dates( commit_obj ) do
    [ _, { a_start, _ } ] = Regex.run( ~r/author.+>\s(.+)/m,    commit_obj, return: :index )
    [ _, { c_start, _ } ] = Regex.run( ~r/committer.+>\s(.+)/m, commit_obj, return: :index )
    { a_start, c_start }
  end
  
  defp loop( blob, preffix, a_start, c_start, i, j ) do
    mod_a = Integer.to_string( @timestamp - i )
    mod_c = Integer.to_string( @timestamp - j )
    cur_blob = blob
      |> str_replace_at( mod_a, a_start, @timestamp_len )
      |> str_replace_at( mod_c, c_start, @timestamp_len )
    cur_preffix = cur_blob |> sha1 |> :binary.part({ 0, byte_size( preffix ) })
    if ( cur_preffix == preffix ) do
      IO.inspect { i, j }
      IO.inspect cur_blob
      { mod_a, mod_c }
    else
      { i, j } = next_i_j( i, j )
      loop( blob, preffix, a_start, c_start, i, j )
    end

  end

  defp str_replace_at( str1, str2, start, len ) do
    :binary.part( str1, 0, start ) <> str2 <> :binary.part( str1, start + len, byte_size( str1 ) - start - len )
  end

  def main( preffix ) do
    blob = cur_hash |> cat_file |> make_blob
    { a_start, c_start } = parse_commit_dates( blob )
    loop( blob, preffix, a_start, c_start, 0, 0 )
  end

end

