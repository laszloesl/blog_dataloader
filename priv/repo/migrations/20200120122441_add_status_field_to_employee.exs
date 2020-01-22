defmodule Blog.Dataloader.Repo.Migrations.AddStatusFieldToEmployee do
  use Ecto.Migration

  def change do
    alter table(:employees) do
      add(:status, :string, default: "registered")
    end

    create(index(:employees, [:status]))
  end
end
