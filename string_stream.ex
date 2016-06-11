# The problem: String stream
#
# Given a stream of bytes (read: one can read
# one byte at a time, the size of the stream is
# unlimited. Given the dictionary: a set of the
# known words.
# Count the number of the dictionary words in
# the stream.
# Example:
#   disctionary: [ "cat", "car" ]
#   stream string: "catcarcatcan"
#   expected result: %{ "cat" -> 2, "car" => 1 }

ExUnit.start()

defmodule StringStream do

  def count_words( stream, words ) do
    trie = build_trie words
    { _, _, counters } = look_ahead( stream, trie, [], 0, %{} )
    counters
  end

  def build_trie( words ) do
    words
      |> Enum.map( &String.to_char_list(&1) )
      |> Enum.reduce( %{}, fn word, trie ->
        update_index( trie, word )
      end )
  end

  defp update_index( trie, [] ) do
    # The end of the word is marked by a zero-byte
    # This allows us to store the end of the word and longer alternatives
    # Example:
    #                                [\0] <- word "alpha"
    #                               /
    # [a] - [l] - [p] - [h] - [a] <
    #                               \
    #                                [b] - [e] - [t] <- word "alphabet"
    Map.put( trie, 0, true )
  end

  defp update_index( trie, [ char | tail ] ) do
    { _, trie } = Map.get_and_update( trie, char, fn sub_trie ->
      sub_trie = case sub_trie do
        nil -> %{}
        _   -> sub_trie
      end
      { sub_trie, update_index( sub_trie, tail ) }
    end )
    trie
  end

  defp increment( counters, word ) do
    { _, counters } = Map.get_and_update( counters, word, fn cur_value ->
      case cur_value do
        nil -> { cur_value, 1 }
        v   -> { cur_value, v + 1 }
      end
    end )
    counters
  end

  # A corner case: when the stream is over and we've found
  # a dictionary word
  defp look_ahead( stream = [], %{ 0 => true }, word, _, counters ) do
    { stream, word, counters }
  end

  # The stream is over
  defp look_ahead( [], _, _, _, counters ) do
    { [], nil, counters }
  end

  # No subtree === no matching string found
  defp look_ahead( stream, nil, _buf, _trie_ix, counters ) do
    { stream, nil, counters }
  end

  # A case when there is a null-byte in the trie which means
  # we found the end of the word
  defp look_ahead( stream = [ ch | tail ], sub_trie = %{ 0 => true }, buf, trie_ix, counters ) do
    case Map.keys( sub_trie ) |> Enum.count do
      # The word is the longest possible in this branch 
      # In a non-greedy algorithm this branch should be removed
      1 ->
        { stream, buf, counters }
      # We've found a word but it might appear to be not the longest
      # matching substring, move on as it's a greedy algo implementation
      _ ->
        case look_ahead( tail, Map.get( sub_trie, ch ), buf ++ [ ch ], trie_ix + 1, counters ) do
          # Ok, we did our best but a longer match wasn't found
          { _, nil, _counters } -> { stream, buf, counters }
          # Alright, a longer variant found
          { new_stream, new_word, new_counters } -> { new_stream, new_word, new_counters }
        end
    end
  end

  # The entrypoint: we're at the top of the trie
  defp look_ahead( [ ch | tail ], trie, buf, trie_ix = 0, counters ) do
    case look_ahead( tail, Map.get( trie, ch ), buf ++ [ ch ], trie_ix + 1, counters ) do
      { _, nil, _counters } ->
        look_ahead( tail, trie, [], trie_ix, counters )
      { stream, word, counters } -> 
        # Note: counters increment happening only on the top level
        # of the recursion
        look_ahead( stream, trie, [], trie_ix, counters |> increment( word ) )
    end
  end

  defp look_ahead( [ ch | tail ], trie, buf, trie_ix, counters ) do
    # Routinely read a char from the stream, append it to the buffer
    # and increment the trie index
    look_ahead( tail, Map.get( trie, ch ), buf ++ [ ch ], trie_ix + 1, counters )
  end

end

defmodule StringStreamTest do

  use ExUnit.Case
  import StringStream

  test "One word test-case" do
    assert count_words( 'cat', ~w(cat) ) == %{ 'cat' => 1 }
  end

  test "One word occures multiple times" do
    assert count_words( 'catcatcat', ~w(cat) ) == %{ 'cat' => 3 }
  end

  test "lookup for some basic words" do
    assert count_words( 'catcancancatcar', ~w(cat car can) ) == %{ 'cat' => 2, 'can' => 2, 'car' => 1 }
  end

  test "Some garbage symbols in the front" do
    assert count_words( 'asdasdcatcancar', ~w(cat car can)) == %{ 'cat' => 1, 'can' => 1, 'car' => 1 }
  end

  test "Some garbage symbols in the tail" do
    assert count_words( 'cancatcarasdasd', ~w(cat can car) ) == %{ 'can' => 1, 'cat' => 1, 'car' => 1 }
  end

  test "Some garbage symbols in the middle" do
    assert count_words( 'canasdcatasdcar', ~w(cat can car) ) == %{ 'can' => 1, 'cat' => 1, 'car' => 1 }
  end

  test "Greedy search" do
    assert count_words( 'alphabet', ~w(alpha alphabet)) == %{ 'alphabet' => 1 }
  end

  test "Greedy search with both words in the test string" do
    assert count_words( 'alphabetalphabe', ~w(alpha alphabet) ) == %{ 'alphabet' => 1, 'alpha' => 1 }
  end

  test "Building a trie" do
    assert build_trie( ~w(cat car alpha alphabet) )
      %{
        97 => %{
          108 => %{
            112 => %{
              104 => %{
                97 => %{
                  0 => true,
                  98 => %{
                    101 => %{
                      116 => %{
                        0 => true
                      },
                    },
                  },
                },
              },
            },
          },
        },
        99 => %{
          97 => %{
            116 => %{
              0 => true
            },
            114 => %{
              0 => true
            },
          },
        },
      }
  end

end
