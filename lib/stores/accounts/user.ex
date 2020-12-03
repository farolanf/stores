defmodule Stores.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs, changes \\ %{}) do
    user
    |> cast(attrs, [])
    |> change(changes
      |> Map.delete(:password)
      |> Map.delete(:password_confirmation))
    |> check_password(changes)
    |> put_password_hash(changes)
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def check_password(changeset, %{password: password, password_confirmation: password_confirmation}) do
    cond do
      password != password_confirmation ->
        add_error(changeset, :password, "Password tidak sama")
      true ->
        changeset
    end
  end

  def check_password(changeset, _), do: changeset

  def put_password_hash(changeset, %{password: password}) do
    changeset
    |> put_change(:password, Bcrypt.hash_pwd_salt(password))
  end

  def put_password_hash(changeset, _), do: changeset

end
