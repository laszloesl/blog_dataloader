defmodule Blog.Dataloader.Repo.Employee do
  use Blog.Dataloader.Repo.Schema
  alias Blog.Dataloader.Repo.Company

  schema "employees" do
    field(:name, :string)
    field(:email, :string)

    belongs_to(:company, Company)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [
      :name,
      :email,
      :company_id
    ])
    |> validate_required([
      :name,
      :email,
      :company_id
    ])
    |> assoc_constraint(:company)
  end
end
