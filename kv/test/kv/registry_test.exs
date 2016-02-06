defmodule KV.RegistryTest do
  setup do
    { :ok, registry } = KV.Registry.start_link
    { :ok, registry: registry }
  end

end

