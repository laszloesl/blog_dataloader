defmodule Blog.Dataloader.Repo.Migrations.CreateDatabaseTables do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)

      timestamps()
    end

    create table(:employees, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string, null: false)
      add(:email, :string, null: false)
      add(:company_id, references(:companies))

      timestamps()
    end

    create(index(:employees, [:company_id]))
    create(unique_index(:employees, [:email]))
  end
end
