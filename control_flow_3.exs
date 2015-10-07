defmodule SafeOk do
  def ok!(tuple) do
    case tuple do
      { :ok, value } -> value
      { _, message } -> raise RuntimeError, message: "#{message}"
    end
  end
end

_ = SafeOk.ok! File.open("data.dat")
