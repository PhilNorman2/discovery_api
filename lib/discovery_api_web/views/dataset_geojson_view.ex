defmodule DiscoveryApiWeb.DatasetGeoJsonView do
  use DiscoveryApiWeb, :view

  def render("features.geojson", %{features: features, dataset_name: name}) do
    %{
      name: name,
      features: features,
      type: "FeatureCollection"
    }
  end
end
