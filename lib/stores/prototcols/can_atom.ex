defimpl Can, for: Atom do

  # deny unknown actions
  def can?(nil, _, _), do: false

end
