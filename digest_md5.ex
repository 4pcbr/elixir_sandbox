defmodule Digest.MD5 do

  use Bitwise

  @mask_32 0xFFFFFFFF

  @s { 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
       5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
       4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
       6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21 }

  @k { 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
       0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
       0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
       0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
       0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
       0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
       0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
       0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
       0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
       0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
       0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
       0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
       0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
       0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
       0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
       0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391 }

  @a0 0x67452301
  @b0 0xefcdab89
  @c0 0x98badcfe
  @d0 0x10325476


  defp _bin_of_length( n ), do: _bin_of_length( n, 0 )
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
    IO.puts pad_len
    message = message <> << 0x80 >> <> _bin_of_length( pad_len - 1, 0 )
    message = message <> _bump_bin_size( :binary.encode_unsigned( msg_len, :little ), 8 )
    message |> _report
  end


  defp _report( val ) do
    IO.inspect( val, limit: :infinity )
    val
  end


  defp _chunk_bin( bin, size ), do: _chunk_bin( bin, size, 0 )
  defp _chunk_bin( bin, _, offset ) when offset >= byte_size( bin ), do: []
  defp _chunk_bin( bin, size, offset ) do
    [ :binary.part( bin, { offset, size } ) | _chunk_bin( bin, size, offset + size ) ]
  end


  defp _md5( _a, b, c, d, ix ) when ix >= 0 and ix <= 15 do
    {
      ( ( b &&& c ) ||| ( bnot( b ) &&& d ) ) &&& @mask_32,
      ix
    }
  end
  defp _md5( _a, b, c, d, ix ) when ix >= 16 and ix <= 31 do
    {
      ( ( d &&& b ) ||| ( bnot( d ) &&& c ) ) &&& @mask_32,
      rem( 5 * ix + 1, 16 )
    }
  end
  defp _md5( _a, b, c, d, ix ) when ix >= 32 and ix <= 47 do
    {
      ( bxor( b, bxor( c, d ) ) ) &&& @mask_32,
      rem( 3 * ix + 5, 16 )
    }
  end
  defp _md5( _a, b, c, d, ix ) when ix >= 48 and ix <= 63 do
    {
      ( bxor( c, b ||| bnot( d ) ) ) &&& @mask_32,
      rem( 7 * ix, 16 )
    }
  end


  defp _chunk_loop( _, a, b, c, d, -1 ), do: { a, b, c, d }
  defp _chunk_loop( words, a, b, c, d, ix ) do
    { f, g } = _md5( a, b, c, d, ix )
    { d, c, b, a } = {
      c,
      b,
      (b + _rotl_32( (a + f + elem( @k, ix ) +
        :binary.decode_unsigned(
          Enum.at( words, g ),
          :little
        )) &&& @mask_32,
        elem( @s, ix )
      )) &&& @mask_32, 
      d
    }
    _chunk_loop( words, a, b, c, d, ix - 1 )
  end


  defp _main_loop( message, offset, _len, a, b, c, d ) when offset >= byte_size( message ) do
    { a, b, c, d }
  end
  defp _main_loop( message, offset, len, a, b, c, d ) do
    { a0, b0, c0, d0 } = { a, b, c, d }
    IO.inspect { a, b, c, d }
    { a, b, c, d } = message
                      |> :binary.part( { offset, len } )
                      |> _chunk_bin( 4 )
                      |> _report
                      |> _chunk_loop( a, b, c, d, 64 - 1 )
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
    IO.puts "a: #{a}, b: #{b}, c: #{c}, d: #{d}"
    IO.inspect :binary.encode_unsigned( a, :little )

    :binary.encode_unsigned( a, :little ) <>
      :binary.encode_unsigned( b, :little ) <>
        :binary.encode_unsigned( c, :little ) <>
          :binary.encode_unsigned( d, :little )
  end

  def test( msg ) do
    core = :erlang.md5( msg )
    mine = Digest.MD5.hash( msg )
    IO.inspect core
    IO.inspect mine
    if core == mine do
      { :ok }
    else
      { :not_ok }
    end
  end


end

IO.inspect Digest.MD5.test("a")
