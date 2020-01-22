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
  end

  input_object :get_employee_input do
    field(:id, non_null(:id))
  end

  object :get_employee_payload do
    field(:employee, non_null(:employee))
  end

  object(:employee_queries) do
    field :get_employee, type: :get_employee_payload do
      arg(:input, non_null(:get_employee_input))
      resolve(&get_employee/2)
    end
  end

  defp get_employee(%{input: params}, _info) do
    case Repo.get(Employee, params[:id]) do
      nil ->
        {:error, "Employee does not exist"}

      employee ->
        {:ok, %{employee: employee}}
    end
  end
end
