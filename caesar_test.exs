ExUnit.start()

defmodule CaesarTest do

  use ExUnit.Case

  import Caesar, only: [
    encrypt: 2,
    rot13: 1,
  ]

  def sample_output_for_rot_1 do
    [
      { "A", "B" },
      { "Z", "A" },
      { "AB", "BC" },
      { "AZ", "BA" },
    ]
  end

  test "encrypt" do
    sample_output_for_rot_1
      |> Enum.each(fn({ input, output }) ->
        assert encrypt( input, 1 ) == output
      end)
  end

end
