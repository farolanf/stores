defmodule StoresWeb.Helpers do
  import Phoenix.LiveView
  alias Stores.Accounts

  def assign_defaults(session, socket) do
    with %{"user_id" => user_id} <- session,
        false <- Map.has_key?(socket.assigns, :user),
        user when not is_nil(user) <- Accounts.get_user(user_id) do
      socket |> assign(:user, user)
    else
      _ -> socket
    end
  end
end
