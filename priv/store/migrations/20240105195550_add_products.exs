defmodule Store.Migrations.AddProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:name, :string)
      add(:bar_code, :string)
      add(:price, :string)
      add(:currency, :string)
      timestamps(type: :utc_datetime_usec)
    end
  end
end
