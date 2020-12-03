defmodule StoresWeb.LoginComponent do
  use StoresWeb, :live_component

  alias Stores.Accounts
  alias Stores.Accounts.User

  @impl true
  def mount(socket) do
    {:ok, socket
      |> assign(login: %{}, register: %{})
    }
  end

  @impl true
  def handle_event(event, params, socket) do
    {:noreply, do_event(event, params, socket)}
  end

  def do_event("validate", %{"login" => %{"email" => email, "password" => password}} = params, socket) do
    socket = socket
    |> assign(login: params["login"])
    |> assign(valid: false)
    |> clear_flash()
    cond do
      String.length(email) > 0 and String.length(password) > 0 ->
        socket |> assign(valid: true)
      true -> socket
    end
  end

  def do_event("validate", %{"register" => %{"email" => email, "password" => password, "password_confirmation" => password_confirmation}} = params, socket) do
    socket = socket
    |> assign(register: params["register"])
    |> assign(valid: false)
    |> clear_flash()
    cond do
      String.length(password) == 0 or String.length(password_confirmation) == 0 ->
        socket
      true ->
        case Accounts.change_user(%User{}, %{}, %{email: email, password: password, password_confirmation: password_confirmation}) do
          %{errors: []} ->
            socket |> assign(valid: true)
          %{errors: errors} ->
            Enum.reduce errors, socket, fn {k, {msg, _}}, socket ->
              socket |> put_flash(k, msg)
            end
        end
    end
  end

  def do_event("login", %{"login" => %{"email" => email, "password" => password}}, socket) do
    with user when not is_nil(user) <- Accounts.get_user_by_email(email),
        true <- Bcrypt.verify_pass(password, user.password) do
      socket
      |> redirect(to: "/")
    else
      _ ->
        Bcrypt.no_user_verify()
        socket |> put_flash(:error, "Akun tidak ditemukan")
    end
  end

  def do_event("register", %{"register" => %{"email" => email, "password" => password, "password_confirmation" => password_confirmation}}, socket) do
    case Accounts.create_user(%{}, %{email: email, password: password, password_confirmation: password_confirmation}) do
      {:ok, _user} ->
        socket
        |> put_flash(:success, "Sukses mendaftar akun, silahkan cek email anda untuk instruksi lebih lanjut.")
        |> push_redirect(to: "/")
      _ ->
        socket
        |> put_flash(:error, "Kesalahan pada server, silahkan ulangi")
    end
  end

end
