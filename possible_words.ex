defmodule NearbyWords do

  ###### stubs for the example
  def nearby_chars("g") do [ "h", "y", "t", "r", "f", "v", "b"] end
  def nearby_chars("k") do [ "i", "o", "l", "m", "j", "u"] end
  def nearby_chars(char) do [ char ] end

  def is_valid_word("hi"), do: true
  def is_valid_word("ho"), do: true
  def is_valid_word("car"), do: true
  def is_valid_word("cat"), do: true
  def is_valid_word( _ ),  do: false
  ###### end of stubs

  def check_word(word) do
    if is_valid_word(word) do
      MapSet.new([word])
    else
      check_word(word, String.length(word)-1, MapSet.new())
    end
  end

  # if all chars have been examinated (from last to first)
  def check_word(_word, -1, possible_words), do: possible_words

  def check_word(word, idx, possible_words) do
    check_word(word, idx, nearby_chars(String.at(word, idx)), possible_words)
  end

  # if all nearby chars have been examinated
  def check_word(_word, _idx, [ ], possible_words), do: possible_words

  def check_word(word, idx, [ char | rest_nearby_chars ], possible_words) do
    # in string word, replace character at idx by char
    modified_word = String.slice(word, 0, idx) <> char <> String.slice(word, idx+1, String.length(word))
    possible_words = if is_valid_word(modified_word) do
      MapSet.put(possible_words, modified_word)
    else
      possible_words
    end
    possible_words = check_word(modified_word, idx-1, possible_words)
    check_word(word, idx, rest_nearby_chars, possible_words)
end


end

IO.inspect NearbyWords.check_word("hi")
IO.inspect NearbyWords.check_word("gk")
IO.inspect NearbyWords.check_word("cag")
