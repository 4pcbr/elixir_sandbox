defmodule MurmurHash do

  use Bitwise

  def murmur3_32(key, seed \\ 0x0000) do
    c1 = 0xcc9e2d51
    c2 = 0x1b873593
    r1 = 15
    r2 = 13
    m  = 5
    n  = 0xe6546b64
    hash = seed
    len = byte_size key
    nblocks = div(len, 4)

    _proc_block = fn(key, hash) ->
      case key do
        << b1, b2, b3, b4, b5 :: binary >> -> #TODO
        << tail :: binary >> -> { hash, tail }
    end


    { hash, tail } = _proc_block.(key, hash)


  end

end

