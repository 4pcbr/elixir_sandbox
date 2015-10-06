defmodule ASCII do
  def is_printable?([]) do; true; end
  def is_printable?([ ch | tail ]) when ( ch >= 32 and ch <= 126 ) do; is_printable?(tail); end
  def is_printable?([ _ | _ ]) do; false; end
end
