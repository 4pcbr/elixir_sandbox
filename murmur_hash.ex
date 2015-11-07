defmodule MurmurHash do

  use Bitwise

  @c1 0xcc9e2d51
  @c2 0x1b873593
  @r1 15
  @r2 13
  @m  5
  @n  0xe6546b64

  def _proc_block(<< b1, b2, b3, b4, tail :: binary >>, hash) do
    k = :binary.decode_unsigned(<<b1, b2, b3, b4>>, :big)
    k = k * @c1
    k = bor( ( k <<< @r1 ), ( k >>> ( 32 - @r1 ) ) )
    k = k * @c2
    hash = bxor( hash, k )
    hash = bor( ( hash <<< @r2 ), ( hash >>> ( 32 - @r2 ) ) ) * @m + @n
    { hash, _proc_block(tail, hash) }
  end

  def _proc_block(<< tail :: binary >>, hash), do: { hash, tail }

  def murmur3_32(key, seed \\ 0x0000) do
    hash = seed
    len = byte_size key
    nblocks = div(len, 4)
    { hash, tail } = _proc_block(key, hash)

  end

end

