defmodule Blog.Dataloader.Schema do
  use Absinthe.Schema
  alias Blog.Dataloader.Repo

  import_types(Blog.Dataloader.Schema.Employee)
  import_types(Blog.Dataloader.Schema.Company)

  input_object :pagination_input do
    field(:limit, :integer)
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

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
