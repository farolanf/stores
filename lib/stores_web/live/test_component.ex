defmodule StoresWeb.TestComponent do
  use StoresWeb, :live_component

  @impl true
  def mount(socket) do
    socket = assign(socket, active_tab: "tab1")
    {:ok, socket}
  end

  @impl true
  def handle_event("test_flash_component", _params, socket) do
    {:noreply, socket
    |> put_flash(:error, "Error flash from component")
    |> push_redirect(to: "/")}
  end

  @impl true
  def handle_event("select_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end
end
