defmodule MyList do

  def flatten( [] ) do; []; end

  def flatten( [ el | rest ] ) when is_list( el ) do
    flatten( el ) ++ flatten( rest )
  end

  def flatten( [ num | rest ] ) do
    [ num ] ++ flatten( rest )
  end

end

