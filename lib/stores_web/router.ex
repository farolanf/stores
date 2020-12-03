defmodule StoresWeb.Router do
  use StoresWeb, :router

  import Can

  alias Stores.Accounts

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StoresWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_user
  end

  pipeline :protected do
    plug :check_auth
  end

  pipeline :admin do
    plug :check_auth
    plug :check_admin
  end

  scope "/", StoresWeb do
    pipe_through :browser

    live "/", PageLive, :index

    live "/login", PageLive, :login
    live "/register", PageLive, :register
    post "/session/new", SessionController, :new
  end

  scope "/", StoresWeb do
    pipe_through [:browser, :protected]

    delete "/logout", SessionController, :delete

    live "/profile", PageLive, :profile
  end

  def load_user(conn, _) do
    with user_id when not is_nil(user_id) <- get_session(conn, :user_id),
        user when not is_nil(user) <- Accounts.get_user(user_id) do
      conn |> assign(:user, user)
    else
      _ -> conn |> delete_session(:user_id)
    end
  end

  def check_auth(%{assigns: %{user: _}} = conn, _), do: conn

  def check_auth(
    %{request_path: request_path, query_string: query_string} = conn,
    _
  ) do
    redirect_url = "#{request_path}?#{query_string}"
    conn
    |> put_session(:redirect_url, redirect_url)
    |> put_flash(:login, "Please login before accessing the page.")
    |> redirect(to: "/")
  end

  def check_admin(conn, _) do
    with %{assigns: %{user: user}} when not is_nil(user) <- conn,
        true <- user |> can?(:admin, :admin) do
      conn
    else
      _ ->
        conn
        |> put_flash(:error, "Access denied")
        |> redirect(to: "/")
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", StoresWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:browser, :admin]
      live_dashboard "/dashboard", metrics: StoresWeb.Telemetry
    end
  end
end
