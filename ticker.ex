defmodule Ticker do

  @interval 2_000
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients, turn) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator([pid | clients], turn)
    after
      @interval ->
        IO.puts "tick"
        len = length(clients)
        if len > 0 do
          client = Enum.at(clients, rem(turn, len))
          send client, { :tick, turn }
        end

        # Enum.each clients, fn client ->
        #    send client, { :tick }
        #end
        generator(clients, turn + 1)
    end
  end
end

defmodule Client do

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick, turn } ->
        IO.puts "tock in client: #{turn}"
        receiver
    end
  end
end

