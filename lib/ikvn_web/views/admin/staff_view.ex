defmodule IkvnWeb.Admin.StaffView do
  use IkvnWeb, :view

  alias Ikvn.Game.Participation

  def not_judged_badge(%Participation{duties: duties}) do
    duty = Enum.at(duties, 0)
    if duty != nil do
      if duty.left > 0 do
        content_tag :span, "#{duty.done} / #{duty.all}",
          class: "badge badge-danger ml-1"
      else
        content_tag :span, "#{duty.done} / #{duty.all}",
          class: "badge badge-success ml-1"
      end
    end
  end
end
