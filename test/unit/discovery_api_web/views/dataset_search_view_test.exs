defmodule DiscoveryApiWeb.DatasetSearchViewTest do
  use DiscoveryApiWeb.ConnCase, async: true
  import Phoenix.View
  alias DiscoveryApi.Data.Model

  test "renders search_dataset_summaries.json" do
    actual =
      render(
        DiscoveryApiWeb.DatasetSearchView,
        "search_dataset_summaries.json",
        models: [
          %Model{
            :id => 1,
            :name => "name",
            :title => "title",
            :systemName => "foo__bar_baz",
            :keywords => ["cat"],
            :organization => "org",
            :organizationDetails => %{orgName: "org_name", orgTitle: "org", logoUrl: "org.png"},
            :modifiedDate => "today",
            :fileTypes => ["csv", "pdf"],
            :description => "best ever",
            :sourceUrl => "http://example.com",
            :sourceType => "remote",
            :private => false,
            :lastUpdatedDate => :date_placeholder,
            :isRemote => true
          }
        ],
        facets: %{organization: [name: "org", count: 1], keywords: [name: "cat", count: 1]},
        sort: "name_asc",
        offset: 0,
        limit: 1000
      )

    expected = %{
      "metadata" => %{
        "facets" => %{organization: [name: "org", count: 1], keywords: [name: "cat", count: 1]},
        "limit" => 1000,
        "offset" => 0,
        "totalDatasets" => 1
      },
      "results" => [
        %{
          :id => 1,
          :name => "name",
          :title => "title",
          :keywords => ["cat"],
          :systemName => "foo__bar_baz",
          :organization_title => "org",
          :organization_name => "org_name",
          :organization_image_url => "org.png",
          :modified => "today",
          :fileTypes => ["csv", "pdf"],
          :description => "best ever",
          :sourceUrl => "http://example.com",
          :sourceType => "remote",
          :lastUpdatedDate => :date_placeholder,
          :isRemote => true
        }
      ]
    }

    assert actual == expected
  end
end
