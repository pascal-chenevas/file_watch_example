defmodule FileWatchExample.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  schema "products" do
    field :name, :string
    field :bar_code, :string
    field :price, :string
    field :currency, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :bar_code, :price, :currency])
  end

  def create_product(attrs) do
    %FileWatchExample.Product{}
    |> FileWatchExample.Product.changeset(attrs)
    |> Store.insert(timeout: 1000 * 60)
  end

  def create_products(products) do
    Store.insert_all("products", products, returning: [:id])
  end
end
