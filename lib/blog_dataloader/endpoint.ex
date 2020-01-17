defmodule Blog.Dataloader.Endpoint do
  @moduledoc """
  Main entry point for http requests
  """
  use Plug.ErrorHandler
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  forward("/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [
      schema: Blog.Dataloader.Schema
    ]
  )

  forward(
    "/graphql",
    to: Absinthe.Plug,
    init_opts: [
      schema: Blog.Dataloader.Schema
    ]
  )

  match _ do
    conn
    |> send_resp(Plug.Conn.Status.code(:not_found), "Not found")
  end
end
