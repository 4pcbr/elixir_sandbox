defmodule Calculator do

  def _parse([], v) do; v; end
  def _parse([ ?+ | tail ], v) do; v + _parse(tail, 0); end # +
  def _parse([ ?- | tail ], v) do; v - _parse(tail, 0); end # -
  def _parse([ ?* | tail ], v) do; v * _parse(tail, 0); end # *
  def _parse([ ?/ | tail ], v) do; v / _parse(tail, 0); end # /
  def _parse([ ?\s | tail ], v) do;     _parse(tail, v); end # \s
  def _parse([ digit | tail ], v)
  when digit in '0123456789' do
    _parse(tail, v * 10 + digit - ?0)
  end
  def _parse([ ch | _ ], _) do
    raise "Unrecognized character #{ch}"
  end

  def calculate(expr) do; _parse(expr, 0); end

end

