defmodule DotPathTest do

  use ExUnit.Case
  import Forecast.DotPath, only: [
    find: 2,
  ]

  def sample_data do
    """
    <a k1="v1" k2="v2">
      <b k3="v3" k4="v4">
        <c>
          <d>text.d</d>
        </c>
        <e>text.e</e>
      </b>
      <b k5="v5"></b>
      <b k6="v6">
        <g>text.g</g>
      </b>
    </a>
    """
  end

  test "root element" do
    { :ok, xml, _ } = :erlsom.simple_form(sample_data)
    [{ tag_name, _, _ }] = find(xml, "a")
    assert tag_name == 'a'
  end

  test "read attributes" do
    { :ok, xml, _ } = :erlsom.simple_form(sample_data)
    [{ _, attrs, _ }] = find(xml, "a")
    assert Enum.sort(attrs, &(elem(&1, 0) < elem(&2, 0))) == [{ 'k1', 'v1' }, { 'k2', 'v2' }]
  end

  test "collection of elements" do
    { :ok, xml, _ } = :erlsom.simple_form(sample_data)
    lookup = find(xml, "a.b")
    assert length(lookup) == 3
    uniq_tags = lookup
      |> Enum.map(&(elem(&1, 0)))
      |> Enum.uniq
    assert uniq_tags == ['b']
  end

  test "more deep nesting" do
    { :ok, xml, _ } = :erlsom.simple_form(sample_data)
    [{ tag_name, _, content }] = find(xml, "a.b.c.d")
    assert tag_name == 'd'
    assert content == ['text.d']
  end

end

