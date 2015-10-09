# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :forecast, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:forecast, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :forecast, yahoo_url:       "https://query.yahooapis.com/v1/public/yql?q=",
                  yahoo_query:     "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"%s\")",
                  yahoo_url_extra: "&format=xml&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

config :logger, level: :info
