defmodule DiscoveryApiWeb.DatasetStatsView do
  @moduledoc false
  use DiscoveryApiWeb, :view

  def render("fetch_dataset_stats.json", %{model: model}) do
    model
  end
end