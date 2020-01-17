defmodule Blog.Dataloader.Repo.Company do
  use Blog.Dataloader.Repo.Schema
  alias Blog.Dataloader.Repo.Employee

  schema "companies" do
    field(:name, :string)

    has_many(:employees, Employee)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :name
    ])
    |> validate_required([
      :name
    ])
  end
end
