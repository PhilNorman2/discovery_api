defmodule DiscoveryApiWeb.DatasetGeoJsonController do
  use DiscoveryApiWeb, :controller

  alias DiscoveryApiWeb.Services.PrestoService

  def get_features(conn, _params) do
    dataset_name = get_in(conn, [:assigns, :model, :name])

    features =
      PrestoService.preview(dataset_name, 10)
      |> IO.inspect(label: "FEATURES: ")

    render(conn, :features, features: features)
  end
end
