defmodule Forecast.DotPath do

  def find(xml, path) do
    _find(xml,
          String.split(path, ".")
            |> Enum.map &to_char_list/1
        )
  end

  def attrs_to_keywords(attrs_arr) do
    attrs_arr |> Enum.map fn(el) ->
      { List.to_atom(elem(el, 0)), elem(el, 1) }
    end
  end

  defp _find(_, []), do: []
  defp _find({ tag_name, attrs, children }, [lookup]) when tag_name == lookup do
    [{ tag_name, attrs, children }]
  end
  defp _find({ tag_name, _attrs, children }, [lookup | tail]) when tag_name == lookup do
    children
      |> Enum.reduce [], &(&2 ++ _find(&1, tail))
  end
  defp _find({ _tag_name, _attrs, [] }, _lookup), do: []
  defp _find({ _tag_name, _attrs, _children }, _lookup), do: []

end

