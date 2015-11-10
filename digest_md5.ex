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
    _bump_bin_size( << 0 >> <> bin, size )
  end
  defp _bump_bin_size( bin, size ) when byte_size( bin ) >= size, do: bin


  defp _rotl_32( m, n ), do: (( m <<< n ) ||| ( m >>> ( 32 - n ) )) &&& @mask_32


  defp _pad( message ) when rem( byte_size( message ), 512 ) < 448 do
    original_length = byte_size( message ) - 1
    tail = 448 - rem( byte_size( message ), 512 )
            |> _bin_of_length
    message <> tail <> _bump_bin_size( :binary.encode_unsigned( original_length, :little ), 64 )
  end
  defp _pad( message ) do
    tail = 448 + 512 - rem( byte_size( message ), 512 )
            |> _bin_of_length
    _pad( message <> tail )
  end


  defp _chunk_bin( bin, size ), do: _chunk_bin( bin, size, 0 )
  defp _chunk_bin( bin, _, offset ) when offset >= byte_size( bin ), do: []
  defp _chunk_bin( bin, size, offset ) do
    [ :binary.part( bin, { offset, size } ) | _chunk_bin( bin, size, offset + size ) ]
  end


  defp _md5( _a, b, c, d, ix ) when ix >= 0 and ix <= 15 do
    {
      ( b &&& c ) ||| ( bnot( b ) &&& d ),
      ix
    }
  end
  defp _md5( _a, b, c, d, ix ) when ix >= 16 and ix <= 31 do
    {
      ( d &&& b ) ||| ( bnot( d ) &&& c ),
      rem( 5 * ix + 1, 16 )
    }
  end
  defp _md5( _a, b, c, d, ix ) when ix >= 32 and ix <= 47 do
    {
      bxor( b, bxor( c, d ) ),
      rem( 3 * ix + 5, 16 )
    }
  end
  defp _md5( _a, b, c, d, ix ) when ix >= 48 and ix <= 63 do
    {
      bxor( c, b ||| bnot( d ) ),
      rem( 7 * ix, 16 )
    }
  end


  defp _chunk_loop( _, a, b, c, d, -1 ), do: { a, b, c, d }
  defp _chunk_loop( words, a, b, c, d, ix ) do
    { f, g } = _md5( a, b, c, d, ix )
    { d, c, b, a } = {
      c,
      b,
      b + _rotl_32( a + f + elem( @k, ix ) +
        :binary.decode_unsigned(
          Enum.at( words, g ),
          :little
        ) &&& @mask_32,
        elem( @s, ix )
      ), 
      d
    }
    _chunk_loop( words, a, b, c, d, ix - 1 )
  end


  defp _main_loop( message, offset, _len, a, b, c, d ) when offset >= byte_size( message ) do
    { a, b, c, d }
  end
  defp _main_loop( message, offset, len, a, b, c, d ) do
    chunk = :binary.part( message, { offset, len } )
    words = _chunk_bin( chunk, 32 )
    { a, b, c, d } = _chunk_loop( words, a, b, c, d, 64 - 1 )
    _main_loop( message, offset + len, len, a, b, c, d )
  end


  def hash( message ) do
    message = message <> << 1 >> |> _pad
    { a, b, c, d } = _main_loop( message, 0, 512, @a0, @b0, @c0, @d0 )
    :binary.encode_unsigned( a, :little ) <>
    :binary.encode_unsigned( b, :little ) <>
    :binary.encode_unsigned( c, :little ) <>
    :binary.encode_unsigned( d, :little )
  end

end

