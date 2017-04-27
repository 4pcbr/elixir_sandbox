defmodule Board do
  defstruct cells:  [],
            width:  0,
            height: 0
  def init(width, height) when is_integer(width) and is_integer(height) do
    init(width, height, Stream.cycle([0]) |> Enum.take(width * height))
  end

  def init(width, height, cells) when is_integer(width) and is_integer(height) and is_list(cells) and length(cells) == width * height do
    %Board{width: width, height: height, cells: cells |> Enum.with_index |> Enum.into(%{}, fn {v, k} -> {k, v} end)}
  end

  def cell(%Board{width: width, height: height, cells: cells}, x, y) do
    pos = y * width + x
    case pos > width * height do
      true -> {:error, :out_of_bound}
      _ -> { :ok, Map.get(cells, pos) }
    end
  end

  # 
  # N1 N2 N3
  # N4 X  N5
  # N6 N7 N8
  #
  def neighbours(%Board{width: width, height: height, cells: cells}, pos) do
    case pos > width * height do
      true -> { :error, :out_of_bound }
      _ -> 
        [ 
          pos - width - 1, pos - width, pos - width + 1,
          pos         - 1,              pos         + 1,
          pos + width - 1, pos + width, pos + width + 1
        ] |> Enum.map(&Map.get(cells, &1))
    end
  end

  defp count_alive(board, ix) do
    neighbours(board, ix) |> Enum.reduce(0, fn cell, acc ->
      case cell do
        1 -> acc + 1
        _ -> acc
      end
    end)
  end

  #   defp count_dead(board, ix) do
  #     neighbours(board, ix) |> Enum.reduce(0, fn cell, acc ->
  #       case cell do
  #         0 -> acc + 1
  #         _ -> acc
  #       end
  #     end)
  #   end

  def tick(board = %Board{cells: cells}) do
    %{board | cells: cells |> Enum.map(fn {ix, state} ->
      case state do
        1 ->
          case count_alive(board, ix) do
            v when v < 2 -> {ix, 0} # underpopulation
            v when v > 3 -> {ix, 0} # overpopulation
            _ -> {ix, 1}
          end
        0 ->
          case count_alive(board, ix) do
            3 -> {ix, 1} # reproduction
            _ -> {ix, 0}
          end
      end
    end) |> Enum.into(%{})}
  end

  def is_over?(%Board{cells: cells}) do
    Map.values(cells) |> Enum.filter(fn x -> x > 0 end) |> length == 0
  end

  def format(board = %Board{width: width, height: height, cells: cells}) do
    cells
    |> Map.keys
    |> Enum.sort
    |> Enum.chunk(width)
    |> Enum.map(fn chunk ->
      chunk |> Enum.map(&Map.get(cells,&1)) |> Enum.map(&Integer.to_string/1) |> Enum.join(" ")
    end)
    |> Enum.join("\n")
  end

  def play(board=%Board{}) do
    play(board, 0)
  end

  def play(board=%Board{}, step) do
    IO.puts("===== Starting round #{step} =====")
    IO.puts format(board)
    case is_over?(board) do
      true ->
        IO.puts "Game is over after #{step} steps"
      false -> 
        :timer.sleep(1_000)
        play(tick(board), step + 1)
    end
  end

end

ExUnit.start()
defmodule BoardTest do
  use ExUnit.Case

  test "init with cells" do
    assert Board.init(2, 2, [
      1, 0,
      0, 1
    ]) == %Board{width: 2, height: 2, cells: %{0 => 1, 1 => 0, 2 => 0, 3 => 1}}
  end
end

# Board.play(Board.init(5, 5, [ 0,0,0,0,0, 0,0,1,0,0, 0,0,1,0,0, 0,0,1,0,0, 0,0,0,0,0 ])) # Blinker
# Board.play(Board.init(6, 6, [ 0,0,0,0,0,0, 0,0,0,0,0,0, 0,0,1,1,1,0, 0,1,1,1,0,0, 0,0,0,0,0,0, 0,0,0,0,0,0 ])) # Toad
