defmodule PhoenixChat.User do
  use PhoenixChat.Web, :model

  schema "users" do
    field :name, :string
    has_many :messages, PhoenixChat.Message

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
