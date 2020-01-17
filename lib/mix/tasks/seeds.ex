defmodule Mix.Tasks.Ecto.Seeds do
  use Mix.Task
  import Blog.Dataloader.Repo.Seeds.Factory
  alias Blog.Dataloader.Repo
  alias Blog.Dataloader.Repo.Employee

  def run(_) do
    Application.ensure_all_started(:ex_machina)
    Application.ensure_all_started(:blog_dataloader)

    companies = create_companies()
    create_employees(companies)
  end

  defp create_companies() do
    insert_list(10, :company)
  end

  defp create_employees(companies) do
    employees =
      1..1000
      |> Enum.map(fn _ -> build(:employee, company_id: Enum.random(companies).id) end)
      |> Enum.map(&Map.from_struct/1)
      |> Enum.map(&Map.take(&1, [:name, :email, :company_id]))
      |> Enum.map(fn map ->
        {:ok, inserted_at} = Ecto.Type.cast(:naive_datetime, DateTime.utc_now())
        {:ok, updated_at} = Ecto.Type.cast(:naive_datetime, DateTime.utc_now())

        Map.merge(map, %{
          inserted_at: inserted_at,
          updated_at: updated_at
        })
      end)

    Repo.insert_all(Employee, employees)
  end
end
