defmodule Format do
  def capitalize_sentences(sentence) do
    _do_capitalize( String.split( sentence, ". " ) )
  end

  def _do_capitalize([]) do; ""; end

  def _do_capitalize(["" | _]) do; ""; end

  def _do_capitalize([dqs | rest]) do
    String.capitalize(dqs) <> ". " <> _do_capitalize(rest)
  end

end

IO.puts Format.capitalize_sentences( "oh. a dog. woof. ваще круто. " )
