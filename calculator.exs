defmodule Calculator do

  def _parse([], v) do; v; end
  def _parse([ 43 | tail ], v) do; v + _parse(tail, 0); end # +
  def _parse([ 45 | tail ], v) do; v - _parse(tail, 0); end # -
  def _parse([ 42 | tail ], v) do; v * _parse(tail, 0); end # *
  def _parse([ 47 | tail ], v) do; v / _parse(tail, 0); end # /
  def _parse([ 32 | tail ], v) do;     _parse(tail, v); end
  def _parse([ digit | tail ], v)
  when digit in '0123456789' do
    _parse(tail, v * 10 + digit - ?0)
  end
  def _parse([ ch | _ ], _) do
    raise "Unrecognized character #{ch}"
  end

  def calculate(expr) do; _parse(expr, 0); end

end

