defmodule Anagram do

  def anagram?( [], [] ) do; true; end
  def anagram?( [ ch1 | tail ], word ) do; ( ch1 in word ) && anagram?( tail, List.delete( word, ch1 ) ); end
  def anagram?( _, _ ) do; false; end
end

