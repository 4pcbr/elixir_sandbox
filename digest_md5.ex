# Inspired by https://ostermiller.org/utils/src/MD5.java.html

defmodule Digest.MD5 do

  use Bitwise

  @mask_32 0xFFFFFFFF

  @a0 0x67452301
  @b0 0xefcdab89
  @c0 0x98badcfe
  @d0 0x10325476


  defp _bin_of_length( 0, _element ), do: <<>>
  defp _bin_of_length( n, element ) do
    << element >> <> _bin_of_length( n - 1, element )
  end


  defp _bump_bin_size( bin, size ) when byte_size( bin ) < size do
    _bump_bin_size( bin <> << 0 >>, size )
  end
  defp _bump_bin_size( bin, size ) when byte_size( bin ) >= size, do: bin


  defp _rotl_32( m, n ), do: (( ( m &&& @mask_32 ) <<< n ) ||| ( ( m &&& @mask_32 ) >>> ( 32 - n ) ))


  defp _pad( message ) do
    msg_len = bit_size( message )
    left_over = ( msg_len >>> 3 ) &&& 0x3f
    pad_len = case left_over do
      val when val <  56 -> 56 - left_over
      val when val >= 56 -> 120 - left_over
    end
    message = message <> << 0x80 >> <> _bin_of_length( pad_len - 1, 0 )
    message <> _bump_bin_size( :binary.encode_unsigned( msg_len, :little ), 8 )
  end


  defp _chunk_bin( bin, size ), do: _chunk_bin( bin, size, 0 )
  defp _chunk_bin( bin, _, offset ) when offset >= byte_size( bin ), do: []
  defp _chunk_bin( bin, size, offset ) do
    [ :binary.part( bin, { offset, size } ) | _chunk_bin( bin, size, offset + size ) ]
  end


  defp _FF( a, b, c, d, x, s, ac ) do
    a = a + (( b &&& c ) ||| ( bnot( b ) &&& d ))
    a = a + x
    a = a + ac
    a = _rotl_32( a, s )
    ( a + b ) &&& @mask_32
  end


  defp _GG( a, b, c, d, x, s, ac ) do
    a = a + (( b &&& d ) ||| ( c &&& bnot( d ) ))
    a = a + x
    a = a + ac
    a = _rotl_32( a, s )
    ( a + b ) &&& @mask_32
  end


  defp _HH( a, b, c, d, x, s, ac ) do
    a = a + bxor( bxor( b, c ), d )
    a = a + x
    a = a + ac
    a = _rotl_32( a, s )
    ( a + b ) &&& @mask_32
  end


  defp _II( a, b, c, d, x, s, ac ) do
    a = a + bxor( c, b ||| bnot( d ) )
    a = a + x
    a = a + ac
    a = _rotl_32( a, s )
    ( a + b ) &&& @mask_32
  end


  defp _round1({ a, b, c, d, words }) do
    a = _FF( a, b, c, d, Enum.at( words,  0 ),   7, 0xd76aa478 )
    d = _FF( d, a, b, c, Enum.at( words,  1 ),  12, 0xe8c7b756 )
    c = _FF( c, d, a, b, Enum.at( words,  2 ),  17, 0x242070db )
    b = _FF( b, c, d, a, Enum.at( words,  3 ),  22, 0xc1bdceee )
    a = _FF( a, b, c, d, Enum.at( words,  4 ),   7, 0xf57c0faf )
    d = _FF( d, a, b, c, Enum.at( words,  5 ),  12, 0x4787c62a )
    c = _FF( c, d, a, b, Enum.at( words,  6 ),  17, 0xa8304613 )
    b = _FF( b, c, d, a, Enum.at( words,  7 ),  22, 0xfd469501 )
    a = _FF( a, b, c, d, Enum.at( words,  8 ),   7, 0x698098d8 )
    d = _FF( d, a, b, c, Enum.at( words,  9 ),  12, 0x8b44f7af )
    c = _FF( c, d, a, b, Enum.at( words, 10 ),  17, 0xffff5bb1 )
    b = _FF( b, c, d, a, Enum.at( words, 11 ),  22, 0x895cd7be )
    a = _FF( a, b, c, d, Enum.at( words, 12 ),   7, 0x6b901122 )
    d = _FF( d, a, b, c, Enum.at( words, 13 ),  12, 0xfd987193 )
    c = _FF( c, d, a, b, Enum.at( words, 14 ),  17, 0xa679438e )
    b = _FF( b, c, d, a, Enum.at( words, 15 ),  22, 0x49b40821 )
    { a, b, c, d, words }
  end

  defp _round2({ a, b, c, d, words }) do
    a = _GG( a, b, c, d, Enum.at( words,  1 ),   5, 0xf61e2562 )
    d = _GG( d, a, b, c, Enum.at( words,  6 ),   9, 0xc040b340 )
    c = _GG( c, d, a, b, Enum.at( words, 11 ),  14, 0x265e5a51 )
    b = _GG( b, c, d, a, Enum.at( words,  0 ),  20, 0xe9b6c7aa )
    a = _GG( a, b, c, d, Enum.at( words,  5 ),   5, 0xd62f105d )
    d = _GG( d, a, b, c, Enum.at( words, 10 ),   9, 0x02441453 )
    c = _GG( c, d, a, b, Enum.at( words, 15 ),  14, 0xd8a1e681 )
    b = _GG( b, c, d, a, Enum.at( words,  4 ),  20, 0xe7d3fbc8 )
    a = _GG( a, b, c, d, Enum.at( words,  9 ),   5, 0x21e1cde6 )
    d = _GG( d, a, b, c, Enum.at( words, 14 ),   9, 0xc33707d6 )
    c = _GG( c, d, a, b, Enum.at( words,  3 ),  14, 0xf4d50d87 )
    b = _GG( b, c, d, a, Enum.at( words,  8 ),  20, 0x455a14ed )
    a = _GG( a, b, c, d, Enum.at( words, 13 ),   5, 0xa9e3e905 )
    d = _GG( d, a, b, c, Enum.at( words,  2 ),   9, 0xfcefa3f8 )
    c = _GG( c, d, a, b, Enum.at( words,  7 ),  14, 0x676f02d9 )
    b = _GG( b, c, d, a, Enum.at( words, 12 ),  20, 0x8d2a4c8a )
    { a, b, c, d, words }
  end

  defp _round3({ a, b, c, d, words }) do
    a = _HH( a, b, c, d, Enum.at( words,  5 ),   4, 0xfffa3942 )
    d = _HH( d, a, b, c, Enum.at( words,  8 ),  11, 0x8771f681 )
    c = _HH( c, d, a, b, Enum.at( words, 11 ),  16, 0x6d9d6122 )
    b = _HH( b, c, d, a, Enum.at( words, 14 ),  23, 0xfde5380c )
    a = _HH( a, b, c, d, Enum.at( words,  1 ),   4, 0xa4beea44 )
    d = _HH( d, a, b, c, Enum.at( words,  4 ),  11, 0x4bdecfa9 )
    c = _HH( c, d, a, b, Enum.at( words,  7 ),  16, 0xf6bb4b60 )
    b = _HH( b, c, d, a, Enum.at( words, 10 ),  23, 0xbebfbc70 )
    a = _HH( a, b, c, d, Enum.at( words, 13 ),   4, 0x289b7ec6 )
    d = _HH( d, a, b, c, Enum.at( words,  0 ),  11, 0xeaa127fa )
    c = _HH( c, d, a, b, Enum.at( words,  3 ),  16, 0xd4ef3085 )
    b = _HH( b, c, d, a, Enum.at( words,  6 ),  23, 0x04881d05 )
    a = _HH( a, b, c, d, Enum.at( words,  9 ),   4, 0xd9d4d039 )
    d = _HH( d, a, b, c, Enum.at( words, 12 ),  11, 0xe6db99e5 )
    c = _HH( c, d, a, b, Enum.at( words, 15 ),  16, 0x1fa27cf8 )
    b = _HH( b, c, d, a, Enum.at( words,  2 ),  23, 0xc4ac5665 )
    { a, b, c, d, words }
  end
  
  defp _round4({ a, b, c, d, words }) do
    a = _II( a, b, c, d, Enum.at( words,  0 ),   6, 0xf4292244 )
    d = _II( d, a, b, c, Enum.at( words,  7 ),  10, 0x432aff97 )
    c = _II( c, d, a, b, Enum.at( words, 14 ),  15, 0xab9423a7 )
    b = _II( b, c, d, a, Enum.at( words,  5 ),  21, 0xfc93a039 )
    a = _II( a, b, c, d, Enum.at( words, 12 ),   6, 0x655b59c3 )
    d = _II( d, a, b, c, Enum.at( words,  3 ),  10, 0x8f0ccc92 )
    c = _II( c, d, a, b, Enum.at( words, 10 ),  15, 0xffeff47d )
    b = _II( b, c, d, a, Enum.at( words,  1 ),  21, 0x85845dd1 )
    a = _II( a, b, c, d, Enum.at( words,  8 ),   6, 0x6fa87e4f )
    d = _II( d, a, b, c, Enum.at( words, 15 ),  10, 0xfe2ce6e0 )
    c = _II( c, d, a, b, Enum.at( words,  6 ),  15, 0xa3014314 )
    b = _II( b, c, d, a, Enum.at( words, 13 ),  21, 0x4e0811a1 )
    a = _II( a, b, c, d, Enum.at( words,  4 ),   6, 0xf7537e82 )
    d = _II( d, a, b, c, Enum.at( words, 11 ),  10, 0xbd3af235 )
    c = _II( c, d, a, b, Enum.at( words,  2 ),  15, 0x2ad7d2bb )
    b = _II( b, c, d, a, Enum.at( words,  9 ),  21, 0xeb86d391 )
    { a, b, c, d, words }
  end


  defp _process_chunk( words, a, b, c, d ) do
    { a, b, c, d, words }
      |> _round1
      |> _round2
      |> _round3
      |> _round4
  end


  defp _main_loop( message, offset, _len, a, b, c, d ) when offset >= byte_size( message ) do
    { a, b, c, d }
  end
  defp _main_loop( message, offset, len, a, b, c, d ) do
    { a0, b0, c0, d0 } = { a, b, c, d }
    { a, b, c, d, _} = message
                      |> :binary.part( { offset, len } )
                      |> _chunk_bin( 4 )
                      |> Enum.map( &(:binary.decode_unsigned( &1, :little )))
                      |> _process_chunk( a, b, c, d )
    _main_loop(
      message,
      offset + len,
      len,
      ( a + a0 ) &&& @mask_32,
      ( b + b0 ) &&& @mask_32,
      ( c + c0 ) &&& @mask_32,
      ( d + d0 ) &&& @mask_32
    )
  end


  def hash( message ) do
    { a, b, c, d } = message
                      |> _pad
                      |> _main_loop( 0, 64, @a0, @b0, @c0, @d0 )

    :binary.encode_unsigned( a, :little ) <>
      :binary.encode_unsigned( b, :little ) <>
        :binary.encode_unsigned( c, :little ) <>
          :binary.encode_unsigned( d, :little )
  end

end

defmodule Digest.MD5.Test do

  def test do
    messages = 1..4096 |> Enum.to_list |> Enum.map &:crypto.strong_rand_bytes/1
    IO.puts "Starting the test suite."
    { mega_s1, s1, micro_s1 } = test_core( messages, :erlang.timestamp )
    IO.puts "The core function timestamp: #{mega_s1}:#{s1}:#{micro_s1}"
    { mega_s2, s2, micro_s2 } = test_myself( messages, :erlang.timestamp )
    IO.puts "My function timestamp: #{mega_s2}:#{s2}:#{micro_s2}"
    diff = ( micro_s2 + s2 * 1_000_000 + mega_s2 * 1_000_000_000_000 ) / ( micro_s1 + s1 * 1_000_000 + mega_s1 * 1_000_000_000_000 )
    IO.puts "My function is #{diff} times slower"
  end

  defp test_core( [], { megasec, sec, microsec } ) do
    { cur_megasec, cur_sec, cur_microsec } = :erlang.timestamp
    { cur_megasec - megasec, cur_sec - sec, cur_microsec - microsec }
  end

  defp test_core( [ message | tail ], timestamp ) do
    :erlang.md5( message )
    test_core( tail, timestamp )
  end

  defp test_myself( [], { megasec, sec, microsec } ) do
    { cur_megasec, cur_sec, cur_microsec } = :erlang.timestamp
    { cur_megasec - megasec, cur_sec - sec, cur_microsec - microsec }
  end

  defp test_myself( [ message | tail ], timestamp ) do
    Digest.MD5.hash( message )
    test_myself( tail, timestamp )
  end

end
