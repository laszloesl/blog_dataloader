defmodule Blog.Dataloader.Repo do
  use Ecto.Repo,
    otp_app: :blog_dataloader,
    adapter: Ecto.Adapters.Postgres

  require Logger
  require Ecto.Query

  import Ecto.Query

  def dataloader_query(queryable, params) do
    Logger.info("Params: #{inspect(params)}")
    Logger.info("Queryable: #{inspect(queryable)}")

    queryable
    |> paginate(params[:paginate])
    |> apply_query(params[:query], params[:query_args] || [])
  end

  def paginate(query, nil), do: query

  def paginate(query, params) do
    params = ensure_limit_offset(params)

    from d in query,
      limit: ^params[:limit],
      offset: ^params[:offset]
  end

  defp ensure_limit_offset(params, default_limit \\ 10, default_offset \\ 0) do
    limit = params[:limit] || default_limit
    offset = params[:offset] || default_offset

    params
    |> Map.merge(%{limit: limit, offset: offset})
  end

  def apply_query(queryable, nil, _query_args), do: queryable

  def apply_query(queryable, query, query_args) do
    apply(query, [queryable | query_args])
  end
end
