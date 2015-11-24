defmodule Stack.Server do

  use GenServer

  def start_link( stash_pid ) do
    { :ok, _pid } = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
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


  def init( stash_pid ) do
    current_stack = Stack.Stash.get_value stash_pid
    { :ok, { current_stack, stash_pid } }
  end

  def handle_call(:pop, _from, { current_stack, stash_pid }) do
    [ el | stack_tail ] = current_stack
    { :reply, el, { stack_tail, stash_pid } }
  end

  def handle_cast({:push, el}, { current_stack, stash_pid }) do
    { :noreply, { [el] ++ current_stack, stash_pid } }
  end

  def format_status(_reason, [ _pdict, state ]) do
    [ data: [ { 'State', "My current state is '#{inspect state}', and I'm happy" } ] ]
  end

  def terminate(reason, { current_stack, stash_pid }) do
    Stack.Stash.save_value stash_pid, current_stack
  end

end

