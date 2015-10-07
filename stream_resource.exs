import :file

Stream.resource(
  fn -> File.open("data.dat") end,
  fn( file ) ->
    case IO.read( file, :line ) do
      line when is_binary( line ) -> { [ line ], file }
      _ -> { :halt, file }
    end
  end,
  fn( file ) -> File.close( file ) end
) |> Enum.take(5)


