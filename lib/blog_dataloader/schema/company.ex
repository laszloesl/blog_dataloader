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
          {:employees, Map.put(args, :company_id, company.id)}
        end)
      )
    end
  end

  input_object :get_company_input do
    field(:id, non_null(:id))
    field(:limit, :integer)
  end

  object :get_company_payload do
    field(:company, non_null(:company))
  end

  object(:company_queries) do
    field :get_company, type: :get_company_payload do
      arg(:input, non_null(:get_company_input))
      resolve(&get_company/2)
    end
  end

  defp get_company(%{input: params}, _info) do
    case Repo.get(Company, params[:id]) do
      nil ->
        {:error, "Company does not exist"}

      company ->
        {:ok, %{company: company}}
    end
  end
end
