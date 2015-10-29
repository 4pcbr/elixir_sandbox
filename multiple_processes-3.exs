defmodule SpawnWithSleep do

  import :timer, only: [
    sleep: 1,
  ]

  def respond(send_to) do
    send send_to, "Hello World!"
    raise "Boom!"
    # exit :boom
  end

  def run do
    spawn_monitor(SpawnWithSleep, :respond, [self])
    sleep 500
    receive do
      msg -> IO.puts msg
    end
  end
end

SpawnWithSleep.run
