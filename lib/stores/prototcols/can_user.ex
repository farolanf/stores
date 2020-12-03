alias Stores.Accounts.User

# actions: :create, :read, :update, :delete

defimpl Can, for: User do

  # admin can do anything
  # TODO: use admin field
  def can?(%User{id: 1}, _, _), do: true

  # owners can update their own things
  def can?(%User{id: id}, action, %{user_id: user_id})
      when action in [:update] do
    user_id == id
  end

  # deny unknown actions
  def can?(%User{}, _, _), do: false

end
