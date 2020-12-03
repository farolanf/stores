defmodule StoresWeb.StoreLive do
  use StoresWeb, :live_view

  @impl true
  def mount(_args, session, socket) do
    {:ok, socket |> assign_defaults(session)}
  end
end
