prefix = fn ( n ) ->
  fn ( word ) ->
    "#{n} #{word}"
  end
end

mrs = prefix.( "Mrs" )
IO.puts mrs.( "Smith" )

IO.puts prefix.( "Elixir" ).( "Rocks" )
