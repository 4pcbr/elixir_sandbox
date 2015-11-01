defmodule ExtEnum do
  def grep([], _), do: []
  def grep([ el | tail ], fun) do
    if fun.(el) do
      [el | grep(tail, fun)]
    else
      grep(tail, fun)
    end
  end
end


defmodule FileReader do
  def process(scheduler) do
    send scheduler, { :ready, self }
    receive do
      { :process, file, lookup, client } ->
        send client, { :result, count_words_in_file(file, lookup), self }
        process(scheduler)
      { :shutdown } ->
        exit :normal
    end
  end

  defp count_words_in_file(file, word) do
    case File.read(file) do
      { :ok, bin_data } -> String.split(bin_data, word) |> length |> -1
      { :error, _reason } -> exit :error
    end
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, lookup, to_calculate) do
    (1..num_processes)
      |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
      |> schedule_processes(to_calculate, lookup, [])
  end

  defp schedule_processes(processes, queue, lookup, results) do
    receive do
      { :ready, pid } when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, { :process, next, lookup, self }
        schedule_processes(processes, tail, lookup, results)
      { :ready, pid } ->
        send pid, { :shutdown }
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, lookup, results)
        else
          Enum.reduce results, 0, &(&1 + &2)
        end
      { :result, result, _pid } ->
        schedule_processes(processes, queue, lookup, [ result | results ])
    end
  end
end

dir = "/Users/olegs/workspace/perl/Dancer/lib/Dancer"
to_calculate = File.ls!(dir)
                |> Enum.map(&("#{dir}/#{&1}"))
                |> ExtEnum.grep fn(f) -> File.stat!(f).type == :regular end

lookup = "package"

Enum.each 1..10, fn(num_processes) ->
  { time, result } = :timer.tc(
    Scheduler, :run, [num_processes, FileReader, :process, lookup, to_calculate]
  )
  if num_processes == 1 do
    IO.puts inspect result
    IO.puts "\n #     time (s)"
  end
  :io.format "~2B     ~.2f~n", [num_processes, time / 1000000.0]
end

