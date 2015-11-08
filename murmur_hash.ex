defmodule MurmurHash do

  use Bitwise

  @c1 0xcc9e2d51
  @c2 0x1b873593
  @r1 15
  @r2 13
  @m  5
  @n  0xe6546b64

  def _proc_block(hash, << b1, b2, b3, b4, tail :: binary >>) do
    k = :binary.decode_unsigned(<<b1, b2, b3, b4>>, :big)
    k = k * @c1
    k = bor( ( k <<< @r1 ), ( k >>> ( 32 - @r1 ) ) )
    k = k * @c2
    hash = bxor( hash, k )
    hash = bor( ( hash <<< @r2 ), ( hash >>> ( 32 - @r2 ) ) ) * @m + @n
    _proc_block(hash, tail)
  end

  def _proc_block(hash, << tail :: binary >>), do: { hash, tail }

  def _proc_tail(hash, << b1, b2, b3 >>, k1) do
    k1 = bxor( k1, b3 <<< 16 )
    _proc_tail(hash, << b1, b2 >>, k1)
  end

  def _proc_tail(hash, << b1, b2 >>, k1) do
    k1 = bxor( k1, b2 <<< 8 )
    _proc_tail(hash, << b1 >>, k1)
  end

  def _proc_tail(hash, << b1 >>, k1) do
    k1 = bxor( k1, b1 )
    k1 = k1 * @c1
    k1 = bor( k1 <<< @r1, k1 >>> (32 - @r1) )
    k1 = k1 * @c2
    bxor( hash, k1 )
  end

  def _bxor_self_with_rshift(val, rshift), do: bxor( val, val >>> rshift )

  def _mult_by(val, mult), do: val * mult

  def murmur3_32(key, seed \\ 0x0000) do
    hash = seed
    len = byte_size key
    { hash, tail } = _proc_block(hash, key)
    _proc_tail(hash, tail, 0x0000)
      |> bxor len
      |> _bxor_self_with_rshift 16
      |> _mult_by 0x85ebca6b
      |> _bxor_self_with_rshift 13
      |> _mult_by 0xc2b2ae35
      |> _bxor_self_with_rshift 16
  end

end

