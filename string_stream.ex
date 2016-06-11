ExUnit.start()

defmodule StringStream do

  def update_index( trie, [] ) do
    Map.put( trie, 0, true )
  end

  def update_index( trie, [ char | tail ] ) do
    { _, trie } = Map.get_and_update( trie, char, fn sub_trie ->
      sub_trie = case sub_trie do
        nil -> %{}
        _ -> sub_trie
      end
      { sub_trie, update_index( sub_trie, tail ) }
    end )
    trie
  end

  def increment( counters, word ) do
    { _, counters } = Map.get_and_update( counters, word, fn cur_value ->
      case cur_value do
        nil -> { cur_value, 1 }
        v -> { cur_value, v + 1 }
      end
    end )
    counters
  end

  def look_ahead( stream = [], %{ 0 => true }, word, _, counters ) do
    { stream, word, counters }
  end

  def look_ahead( [], _, _, _, counters ) do
    { [], nil, counters }
  end

  def look_ahead( stream, nil, _buf, _trie_ix, counters ) do
    { stream, nil, counters }
  end

  def look_ahead( stream = [ ch | tail ], sub_trie = %{ 0 => true }, buf, trie_ix, counters ) do
    case Map.keys( sub_trie ) |> Enum.count do
      1 ->
        { stream, buf, counters }
      _ ->
        # it's a greedy algorithm
        case look_ahead( tail, Map.get( sub_trie, ch ), buf ++ [ ch ], trie_ix + 1, counters ) do
          { _, nil, _counters } -> { stream, buf, counters }
          { new_stream, new_word, new_counters } -> { new_stream, new_word, new_counters }
        end
    end
  end

  def look_ahead( [ ch | tail ], trie, buf, trie_ix = 0, counters ) do
    case look_ahead( tail, Map.get( trie, ch ), buf ++ [ ch ], trie_ix + 1, counters ) do
      { _, nil, _counters } ->
        look_ahead( tail, trie, [], trie_ix, counters )
      { stream, word, counters } -> 
        look_ahead( stream, trie, [], trie_ix, counters |> increment( word ) )
    end
  end

  def look_ahead( [ ch | tail ], trie, buf, trie_ix, counters ) do
    look_ahead( tail, Map.get( trie, ch ), buf ++ [ ch ], trie_ix + 1, counters )
  end

  def inspect_obj(o) do
    IO.inspect o
    o
  end

end

defmodule StringStreamTest do

  use ExUnit.Case
  import StringStream

  def build_trie( words ) do
    words
      |> Enum.map( &String.to_char_list(&1) )
      |> Enum.reduce( %{}, fn word, trie ->
        update_index( trie, word )
      end )
  end

  test "One word test-case" do
    trie = build_trie ~w(cat)
    test_string = 'cat'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'cat' => 1 }
  end

  test "One word occures multiple times" do
    trie = build_trie ~w(cat)
    test_string = 'catcatcat'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'cat' => 3 }
  end

  test "lookup for some basic words" do
    trie = build_trie ~w(cat car can)
    test_string = 'catcancancatcar'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'cat' => 2, 'can' => 2, 'car' => 1 }
  end

  test "Some garbage symbols in the front" do
    trie = build_trie ~w(cat car can)
    test_string = 'asdasdcatcancar'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'cat' => 1, 'can' => 1, 'car' => 1 }
  end

  test "Some garbage symbols in the tail" do
    trie = build_trie ~w(cat can car)
    test_string = 'cancatcarasdasd'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'can' => 1, 'cat' => 1, 'car' => 1 }
  end

  test "Some garbage symbols in the middle" do
    trie = build_trie ~W(cat can car)
    test_string = 'canasdcatasdcar'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'can' => 1, 'cat' => 1, 'car' => 1 }
  end

  test "Greedy search" do
    trie = build_trie ~w(alpha alphabet)
    test_string = 'alphabet'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'alphabet' => 1 }
  end

  test "Greedy search with both words in the test string" do
    trie = build_trie ~w(alpha alphabet)
    test_string = 'alphabetalphabe'
    { _, _, counters } = look_ahead( test_string, trie, [], 0, %{} )
    assert counters == %{ 'alphabet' => 1, 'alpha' => 1 }
  end

  test "Building a trie" do
    assert %{}
      |> update_index( 'cat'      )
      |> update_index( 'car'      )
      |> update_index( 'alpha'    )
      |> update_index( 'alphabet' ) ==
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

