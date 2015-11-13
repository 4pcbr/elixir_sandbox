defmodule Digest.MurmurHash3_32 do

  use Bitwise

  @mask_32 0xFFFFFFFF

  def _mult_32( m, n ), do: ( m * n ) &&& @mask_32

  def _rotl_32( num, off ), do: (( num <<< off ) ||| ( num >>> ( 32 - off ))) &&& @mask_32

  def _bxor_with_self_rshift( val, rshift ), do: bxor( val, val >>> rshift )

  def _proc_block( hash, << b1, b2, b3, b4, tail :: binary >> ) do
    k1 = :binary.decode_unsigned(<< b1, b2, b3, b4 >>, :little)
    hash = hash
      |> bxor( _mmix_32( k1 ) )
      |> _rotl_32( 13 )
    hash = ( hash * 5 + 0xe6546b64 ) &&& @mask_32
    _proc_block(hash, tail)
  end

  def _proc_block( hash, << tail :: binary >> ), do: { hash, tail }

  def _mmix_32( k1 ) do
    k1
      |> _mult_32( 0xcc9e2d51 )
      |> _rotl_32( 15 )
      |> _mult_32( 0x1b873593 )
  end

  def _fmix_32( hash ) do
    hash
      |> band( @mask_32 )
      |> _bxor_with_self_rshift( 16 )
      |> _mult_32( 0x85ebca6b )
      |> _bxor_with_self_rshift( 13 )
      |> _mult_32( 0xc2b2ae35 )
      |> _bxor_with_self_rshift( 16 )
  end

  def _proc_tail( hash, << b0, b1, b2 >>, k1 ) do
    k1 = ( k1 <<< 8 ) ||| b2
    _proc_tail( hash, << b0, b1 >>, k1 )
  end

  def _proc_tail( hash, << b0, b1 >>, k1 ) do
    k1 = ( k1 <<< 8 ) ||| b1
    _proc_tail( hash, << b0 >>, k1 )
  end

  def _proc_tail( hash, << b0 >>, k1 ) do
    k1 = ( k1 <<< 8 ) ||| b0
    bxor( hash, _mmix_32( k1 ) )
  end

  def _proc_tail( hash, "", _ ), do: hash

  def hash( key, seed \\ 0 ) do
    hash = seed
    len = byte_size( key )
    { hash, tail } = _proc_block( hash, key )
    hash = _proc_tail(hash, tail, 0)
    hash
      |> bxor( len )
      |> _fmix_32
  end

end

