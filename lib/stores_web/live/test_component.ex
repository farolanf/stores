defmodule StoresWeb.TestComponent do
  use StoresWeb, :live_component

  @impl true
  def mount(socket) do
    socket = assign(socket, active_tab: "tab1")
    {:ok, socket}
  end

  @impl true
  def handle_event("select_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, active_tab: tab)}
  end

  @impl true
  def handle_event("test_email", _params, socket) do
    if socket.assigns[:user] |> can?(:send, :test_email) do
      Stores.Email.welcome_email(to: "some1@test.com", name: "budi")
      |> Stores.Mailer.deliver_now()
      {:noreply, socket |> put_flash(:success, "Email sent!")}
    else
      socket = socket
      |> put_flash(:error, "Access denied")
      {:noreply, socket}
    end
  end
end
