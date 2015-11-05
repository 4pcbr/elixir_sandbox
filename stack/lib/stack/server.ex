defmodule Stack.Server do

  use GenServer

  def handle_call(:pop, _from, stack) do
    [ el | stack_tail ] = stack
    { :reply, el, stack_tail }
  end

  def handle_cast({:push, el}, stack) do
    { :noreply, [el] ++ stack }
  end

end

