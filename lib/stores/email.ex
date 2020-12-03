defmodule Stores.Email do
  use Bamboo.Phoenix, view: StoresWeb.EmailView
  import Bamboo.Email

  def welcome_email(attrs) do
    base_email(
      to: attrs[:to],
      subject: "Selamat datang di Stores.id!"
    )
    |> render(:welcome, %{to: attrs[:to], name: attrs[:name]})
  end

  defp base_email(attrs) do
    new_email(
      Keyword.merge(
        [
          from: "noreply@Stores.id",
        ],
        attrs
      )
    )
  end

end
