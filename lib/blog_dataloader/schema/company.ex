defmodule Blog.Dataloader.Schema.Company do
  use Absinthe.Schema.Notation
  alias Blog.Dataloader.Repo
  alias Blog.Dataloader.Repo.Company

  require Ecto.Query

  import Absinthe.Resolution.Helpers

  object(:company) do
    field(:id, non_null(:string))
    field(:name, non_null(:string))

    field(:employees, non_null(list_of(:employee))) do
      arg(:paginate, :pagination_input)

      resolve(
        dataloader(Repo, fn company, args, _info ->
          args =
            args
            |> Map.put(:company_id, company.id)
            |> Map.put(:query, &Blog.Dataloader.Employee.Query.where_active/1)

          {:employees, args}
        end)
      )
    end

    field(:number_of_distinct_addresses_of_employees, non_null(:integer)) do
      resolve(fn company, _args, %{context: %{loader: loader}} ->
        loader
        |> Dataloader.load(Repo, :employees, company)
        |> on_load(fn loader_with_employees ->
          employees = Dataloader.get(loader_with_employees, Repo, :employees, company)

          loader_with_employees
          |> Dataloader.load_many(:address, %{}, employees)
          |> on_load(fn loader_with_addresses ->
            addresses =
              Dataloader.get_many(loader_with_addresses, :address, %{}, employees)
              |> Enum.uniq()
              |> IO.inspect()

            {:ok, length(addresses)}
          end)
        end)
      end)
    end
  end

  object(:company_queries) do
    field :company, type: :company do
      arg(:id, non_null(:id))
      arg(:limit, :integer)
      resolve(&get_company/2)
    end
  end

  defp get_company(params, _info) do
    case Repo.get(Company, params[:id]) do
      nil ->
        {:error, "Company does not exist"}

      company ->
        {:ok, company}
    end
  end
end
