defmodule XpathTest do

  use ExUnit.Case
  import Forecast.Xpath, only: [
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
    [{ tag_name, attrs, content }] = find(xml, "a")
    assert tag_name == 'a'
    assert Enum.sort(attrs, &(elem(&1, 0) < elem(&2, 0))) == [{ 'k1', 'v1' }, { 'k2', 'v2' }]
  end

end

