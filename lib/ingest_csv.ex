defmodule IngestCSV do
  alias NimbleCSV.RFC4180, as: YourCSV

  require Logger

  NimbleCSV.define(YourCSV, separator: ";")

  def load(path) do
    path
    |> Path.expand()
    |> File.stream!(read_ahead: 524_288)
    |> YourCSV.parse_stream()
    |> Task.async_stream(fn [name, bar_code, price, currency] ->
      FileWatchExample.Product.create_product(%{name: name, bar_code: bar_code, price: price, currency: currency})
    end, max_concurrency: 95, on_timeout: :kill_task, ordered: false)
    |> Stream.run()
  end
end
