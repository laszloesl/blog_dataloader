defmodule Blog.Dataloader.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    endpoint_options = Application.get_env(:blog_dataloader, Blog.Dataloader.Endpoint)

    children = [
      Blog.Dataloader.Repo,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Blog.Dataloader.Endpoint,
        options: endpoint_options
      )
    ]

    opts = [strategy: :one_for_one, name: Blog.Dataloader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
