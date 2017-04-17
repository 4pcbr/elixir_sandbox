# "{\"a\":[1,2,3]}"

defmodule Parser do
  def parse_path(path) do
    path
      |> String.split(~r/\./)
      |> Enum.map(fn key ->
        case Regex.scan(~r/\[([\d\*]+)\]/, key) do
          [] -> { :key, key }
          [[_, index]] -> { :index, index }
          _ -> raise "Unable to parse fragment: #{key}"
        end
      end)
  end

  def parse_next_chunk(chunk, path= [{k_type, k_value} | path_tail], chunk_ptr, acc, :start) do
    case get_next_obj_type(chunk, chunk_ptr) do
      {new_chunk_ptr, :object} ->
        case k_type do
          :key ->
            case step_in_and_find(chunk, chunk_ptr, k_value, acc) do
              v= {:need_data, cb} -> v
              {:ok, new_chunk_ptr} -> parse_next_chunk(chunk, path_tail, new_chunk_ptr, acc)
    end
  end

  defp read_key(chunk, ptr, acc, state) do
    #TODO
  end

  defp read_value(chunk, ptr, acc, state) do
    #TODO
  end

  defp read_string(chunk, ptr, acc, state) do
    #TODO  
  end

  defp read_number(chunk, ptr, acc, state) do
    #TODO
  end

  defp read_bool(chunk, ptr, acc, state) do
    #TODO
  end

  defp read_null(chunk, ptr, acc, state) do
    #TODO
  end

  defp step_in(chunk, ptr, obj_type, state) do
    
  end

end

[filename, path]= System.argv()

Stream.resource(
  fn ->
    { File.stream!(filename), Parser.parse_path(path) } end,
  fn v= {stream, path} ->
    stream
      |> Stream.take_while(fn chunk ->
        Parser.parse_next_chunk(chunk, path)
      end)
    {:halt, v}
  end,
  fn _ ->
    true
    # Close a stream?
  end
) |> Enum.to_list
