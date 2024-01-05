defmodule Store do
  use Ecto.Repo,
    otp_app: :file_watch_example,
    adapter: Ecto.Adapters.MyXQL

end
