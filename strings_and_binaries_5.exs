defmodule Format do
  def center(list) do
    # TODO
    max_len = Enum.max(
      Enum.map list, &String.length/1
    )
    _do_center(list, max_len)
  end

  def _do_center([ dqs | rest ], max_len) do
    space_width = round(( max_len - String.length( dqs ) ) / 2)
    IO.puts "#{String.duplicate(" ", space_width)}#{dqs}"
    _do_center(rest, max_len)
  end

  def _do_center([], max_len) do; end
end

Format.center(["cat", "zebra", "elephant", "утка", "птица"])
