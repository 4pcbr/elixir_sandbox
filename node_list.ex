defmodule TickerNode do

  import :timer, only: [ sleep: 1 ]

  @head :head
  @tail :tail
  @timeout 2_000

  def register do
    myself = spawn(__MODULE__, :run, [nil])
    case get_links do
      { :undefined, :undefined } ->
        reset_link myself, @head
        send myself, { :reset_head, get_link(@head) }
        send myself, { :tick }
      { head, :undefined } ->
        reset_link myself, @tail
        send myself, { :reset_head, head }
        send head, { :reset_head, myself }
      { head, tail } ->
        send myself, { :reset_head, head }
        send tail, { :reset_head, myself }
    end
  end

  def get_link(id) do
    :global.whereis_name id
  end

  def get_links do
    { :global.whereis_name(@head), :global.whereis_name(@tail) }
  end

  def reset_link(pid, id) do
    :global.unregister_name id
    :global.register_name id, pid
  end

  def run(head) do
    receive do
      { :reset_head, pid } ->
        IO.puts "Reset head"
        run(pid)
      { :tick } ->
        IO.puts "tick!"
        sleep @timeout
        send head, { :tick }
        run(head)
    end
  end
end

