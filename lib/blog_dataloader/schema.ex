defmodule Blog.Dataloader.Schema do
  use Absinthe.Schema
  alias Blog.Dataloader.Repo

  import_types(Blog.Dataloader.Schema.Employee)
  import_types(Blog.Dataloader.Schema.Company)

  input_object :pagination_input do
    field(:limit, :integer)
    field(:offset, :integer)
  end

  query do
    import_fields(:company_queries)
    import_fields(:employee_queries)
  end

  @spec context(context :: map) :: map
  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(
        Repo,
        Dataloader.Ecto.new(Repo, query: &Repo.dataloader_query/2)
      )
      |> Dataloader.add_source(:address, Dataloader.KV.new(&fetch_addresses/2))

    Map.put(ctx, :loader, loader)
    |> Map.put(:user_token, "hello")
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def fetch_addresses(_batch_key, employees) do
    ids = Enum.map(employees, & &1.id)
    results = call_to_another_service(ids)

    employees
    |> Map.new(&{&1, lookup_result_for_employee(&1, results)})
  end

  defp call_to_another_service(ids) do
    Map.new(ids, &{&1, "address of #{&1}"})
  end

  defp lookup_result_for_employee(employee, results) do
    results[employee.id]
  end
end
