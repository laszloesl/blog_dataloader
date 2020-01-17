import Config

config :blog_dataloader, Blog.Dataloader.Endpoint, port: 8080

config :blog_dataloader,
  ecto_repos: [Blog.Dataloader.Repo]

config :blog_dataloader, Blog.Dataloader.Repo,
  database: "blog_dataloder",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  migration_primary_key: [name: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime]

config :logger,
  level: :debug
