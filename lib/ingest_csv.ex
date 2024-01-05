defmodule IngestCSV do
  alias NimbleCSV.RFC4180, as: YourCSV

  require Logger

  NimbleCSV.define(YourCSV, separator: ";")

  def csv_row_to_record([name, bar_code, price, currency], now \\ NaiveDateTime.utc_now()) do
    [
      name: name,
      bar_code: bar_code,
      price: price,
      currency: currency,
      inserted_at: now,
      updated_at: now
    ]
  end

  def load(path) do
    path
    |> Path.expand()
    |> File.stream!(read_ahead: 8 * 1024 * 1024)
    |> YourCSV.parse_stream(skip_headers: false)
    |> Stream.chunk_every(1000)
    |> Task.async_stream(
      fn products ->
        now = DateTime.utc_now()
        to_insert = Enum.map(products, fn values -> csv_row_to_record(values, now) end)
        Store.insert_all(FileWatchExample.Product, to_insert)
      end,
      max_concurrency: 100,
      on_timeout: :kill_task,
      ordered: false
    )
    |> Stream.run()
  end
end
