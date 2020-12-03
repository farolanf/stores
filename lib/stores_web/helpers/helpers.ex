defmodule StoresWeb.Helpers do
  import Phoenix.HTML.Tag
  import Phoenix.Controller, only: [get_csrf_token: 0]
  import Phoenix.LiveView
  alias Stores.Accounts

  def assign_defaults(socket, session) do
    with %{"user_id" => user_id} <- session,
        false <- Map.has_key?(socket.assigns, :user),
        user when not is_nil(user) <- Accounts.get_user(user_id) do
      socket |> assign(:user, user)
    else
      _ -> socket
    end
  end

  def csrf_token_input do
    tag(:input, type: "hidden", name: "_csrf_token", value: get_csrf_token())
  end

  def join(list) do
    str = list
    |> Enum.map(fn
      e when is_binary(e) -> e
      {key, val} -> if val, do: Atom.to_string(key), else: nil
    end)
    |> Enum.filter(fn e -> e end)
    |> Enum.join(" ")
    if str == "", do: nil, else: str
  end
end
