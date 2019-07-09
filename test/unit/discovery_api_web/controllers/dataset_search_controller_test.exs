defmodule DiscoveryApiWeb.DatasetSearchControllerTest do
  use DiscoveryApiWeb.ConnCase
  use Placebo
  import Checkov
  alias DiscoveryApi.Data.Model
  alias DiscoveryApi.Test.Helper

  setup do
    mock_dataset_summaries = [
      generate_model("Paul", ~D(1970-01-01), "remote"),
      generate_model("Richard", ~D(2001-09-09), "batch")
    ]

    allow(Model.get_all(), return: mock_dataset_summaries)
    :ok
  end

  describe "fetch dataset summaries" do
    data_test "request to search with #{inspect(params)}",
              %{conn: conn} do
      response_map = conn |> get("/api/v1/dataset/search", params) |> json_response(200)
      actual = get_in(response_map, selector)

      assert actual == result

      where([
        [:params, :selector, :result],
        [[sort: "name_asc"], ["metadata", "totalDatasets"], 2],
        [[sort: "name_asc", limit: "5"], ["metadata", "limit"], 5],
        [[sort: "name_asc", limit: "1"], ["metadata", "totalDatasets"], 2],
        [[sort: "name_asc"], ["metadata", "limit"], 10],
        [[sort: "name_asc", offset: "5"], ["metadata", "offset"], 5],
        [[sort: "name_asc"], ["metadata", "offset"], 0],
        [
          [sort: "name_asc"],
          ["metadata", "facets", "organization", Access.all(), "name"],
          ["Paul Co.", "Richard Co."]
        ],
        [
          [sort: "name_asc"],
          ["metadata", "facets", "organization", Access.all(), "count"],
          [1, 1]
        ],
        [
          [sort: "name_asc"],
          ["metadata", "facets", "keywords", Access.all(), "name"],
          ["Paul keywords", "Richard keywords"]
        ],
        [
          [sort: "name_asc"],
          ["metadata", "facets", "keywords", Access.all(), "count"],
          [1, 1]
        ],
        [
          [sort: "name_asc"],
          ["results", Access.all(), "id"],
          ["Paul", "Richard"]
        ],
        [
          [sort: "name_desc"],
          ["results", Access.all(), "id"],
          ["Richard", "Paul"]
        ],
        [
          [sort: "last_mod"],
          ["results", Access.all(), "id"],
          ["Richard", "Paul"]
        ],
        [
          [sort: "name_asc", limit: "1", offset: "0"],
          ["results", Access.all(), "id"],
          ["Paul"]
        ],
        [
          [sort: "name_asc", limit: "1", offset: "1"],
          ["results", Access.all(), "id"],
          ["Richard"]
        ],
        [
          [sort: "name_asc", limit: "1"],
          ["results", Access.all(), "id"],
          ["Paul"]
        ],
        [
          [facets: %{organization: ["Richard Co."]}],
          ["results", Access.all(), "id"],
          ["Richard"]
        ],
        [
          [facets: %{organization: ["Babs"], keywords: ["Fruit"]}],
          ["metadata", "facets"],
          %{
            "keywords" => [%{"name" => "Fruit", "count" => 0}],
            "organization" => [%{"name" => "Babs", "count" => 0}],
            "sourceType" => []
          }
        ],
        [
          [facets: %{sourceType: ["remote"]}],
          ["results", Access.all(), "id"],
          ["Paul"]
        ],
        [
          [facets: %{sourceType: ["batch"]}],
          ["results", Access.all(), "id"],
          ["Richard"]
        ]
      ])
    end
  end

  describe "fetch dataset summaries - error cases" do
    data_test "request to search #{inspect(params)} returns a 400 with an error message",
              %{conn: conn} do
      actual = conn |> get("/api/v1/dataset/search", params) |> json_response(400)
      assert Map.has_key?(actual, "message")

      where([
        [:params],
        [[offset: "not a number"]],
        [[limit: "not a number"]],
        [[facets: %{"not a facet" => ["ignored value"]}]]
      ])
    end
  end

  defp generate_model(id, date, sourceType) do
    Helper.sample_model(%{
      description: "#{id}-description",
      fileTypes: ["csv"],
      id: id,
      name: "#{id}-name",
      title: "#{id}-title",
      modifiedDate: "#{date}",
      organization: "#{id} Co.",
      keywords: ["#{id} keywords"],
      sourceType: sourceType,
      organizationDetails: %{
        orgTitle: "#{id}-org-title",
        orgName: "#{id}-org-name",
        logoUrl: "#{id}-org.png"
      },
      private: false
    })
  end
end
