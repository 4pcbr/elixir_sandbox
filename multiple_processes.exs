defmodule Echo do
  def respond do
    receive do
      { sender, token } -> send sender, token
    end
  end
end

[ "fred", "betty" ]
  |> Enum.each fn(token) ->
    pid = spawn(Echo, :respond, [])
    send pid, { self, token }
    receive do
      response when is_binary(response)
        -> IO.puts response
    end
  end

