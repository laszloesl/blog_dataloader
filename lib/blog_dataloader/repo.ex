defmodule Blog.Dataloader.Repo do
  use Ecto.Repo,
    otp_app: :blog_dataloader,
    adapter: Ecto.Adapters.Postgres

  alias Blog.Dataloader.Repo

  require Logger
  require Ecto.Query

  import Ecto.Query

  def dataloader_query(queryable, params) do
    Logger.info("Params: #{inspect(params)}")
    Logger.info("Queryable: #{inspect(queryable)}")

    queryable
    |> paginate(params[:paginate])
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
end
