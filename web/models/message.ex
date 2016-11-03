defmodule PhoenixChat.Message do
  use PhoenixChat.Web, :model
  @derive {Poison.Encoder, only: [:id, :image, :user_id, :text]}
  schema "messages" do
    field :text, :string
    field :image, :string
    belongs_to :user, PhoenixChat.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text, :image])
    |> validate_required([:text])
  end
end
