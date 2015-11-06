defmodule Stack.Server do

  use GenServer

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(el) do
    GenServer.cast __MODULE__, {:push, el}
  end

  def inspect do
    :sys.get_status __MODULE__
  end


  def handle_call(:pop, _from, stack) do
    [ el | stack_tail ] = stack
    { :reply, el, stack_tail }
  end

  def handle_cast({:push, el}, stack) do
    { :noreply, [el] ++ stack }
  end

  def format_status(_reason, [ _pdict, state ]) do
    [ data: [ { 'State', "My current state is '#{inspect state}', and I'm happy" } ] ]
  end

  def terminate(reason, state) do
    IO.inspect reason
    IO.inspect state
    { :stop, reason, "stop", state }
  end

end

