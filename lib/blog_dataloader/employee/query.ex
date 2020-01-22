defmodule Blog.Dataloader.Employee.Query do
  require Ecto.Query
  import Ecto.Query

  def where_active(employee) do
    from e in employee,
      where: e.status == "active"
  end
end
