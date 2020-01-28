defmodule Blog.Dataloader.Schema.Employee do
  use Absinthe.Schema.Notation
  alias Blog.Dataloader.Repo
  alias Blog.Dataloader.Repo.Employee

  import Absinthe.Resolution.Helpers

  object(:employee) do
    field(:id, non_null(:string))
    field(:name, non_null(:string))
    field(:email, non_null(:string))
    field(:status, non_null(:string))

    field(:company, non_null(:company)) do
      resolve(dataloader(Repo))
    end

    field(:address, non_null(:string)) do
      resolve(dataloader(:address))
    end
  end

  object(:employee_queries) do
    field :employee, type: :employee do
      arg(:id, non_null(:id))
      resolve(&get_employee/2)
    end
  end

  defp get_employee(params, _info) do
    case Repo.get(Employee, params[:id]) do
      nil ->
        {:error, "Employee does not exist"}

      employee ->
        {:ok, employee}
    end
  end
end
