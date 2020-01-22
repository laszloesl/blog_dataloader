defmodule Blog.Dataloader.Repo.Seeds.Factory do
  use ExMachina.Ecto, repo: Blog.Dataloader.Repo

  alias Blog.Dataloader.Repo.Company
  alias Blog.Dataloader.Repo.Employee

  def company_factory do
    name = sequence(:title, &"ExMachina Company #{&1}")

    %Company{
      name: name
    }
  end

  def employee_factory do
    name = sequence(:employee_name, &"ExMachina-#{&1}")
    email = sequence(:email, &"email-#{&1}@example.com")
    company = build(:company)

    %Employee{
      name: name,
      email: email,
      company: company,
      status: "registered"
    }
  end
end
