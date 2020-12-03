defmodule StoresWeb.SessionController do
  use StoresWeb, :controller

  alias Stores.Accounts

  def new(conn, %{"login" => %{"email" => email, "password" => password}}) do
    with user when not is_nil(user) <- Accounts.get_user_by_email(email),
        true <- Bcrypt.verify_pass(password, user.password) do
      conn
      |> put_session(:user_id, user.id)
      |> redirect(to: "/")
    else
      _ ->
        Bcrypt.no_user_verify()
        conn
        |> put_flash(:error, "Akun tidak ditemukan")
        |> redirect(to: "/login")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: "/")
  end

end
