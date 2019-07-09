defmodule DiscoveryApi.Search.DataModelFacinatorTest do
  use ExUnit.Case
  alias DiscoveryApi.Search.DataModelFacinator
  alias DiscoveryApi.Test.Helper

  describe "extract_facets/2" do
    setup do
      {:ok,
       [
         models: [
           Helper.sample_model(%{
             title: "Ben's head canon",
             organization: "OrgA",
             keywords: ["my cool keywords", "another keywords"],
             sourceType: "batch"
           }),
           Helper.sample_model(%{
             title: "Ben's Caniac Combo",
             organization: "OrgA",
             keywords: [],
             sourceType: "batch"
           }),
           Helper.sample_model(%{
             title: "Jarred's irrational attachment to natorism's",
             organization: "OrgB",
             keywords: ["my cool keywords"],
             sourceType: "stream"
           }),
           Helper.sample_model(%{
             title: "hi its erin",
             organization: "",
             keywords: ["uncool keywords"],
             sourceType: []
           })
         ]
       ]}
    end

    test "given a list of models, it extracts unique facets and their counts", context do
      assert DataModelFacinator.extract_facets(context[:models], %{}) == %{
               organization: [
                 %{name: "", count: 1},
                 %{name: "OrgA", count: 2},
                 %{name: "OrgB", count: 1}
               ],
               keywords: [
                 %{name: "another keywords", count: 1},
                 %{name: "my cool keywords", count: 2},
                 %{name: "uncool keywords", count: 1}
               ],
               sourceType: [
                 %{count: 2, name: "batch"},
                 %{count: 1, name: "stream"}
               ]
             }
    end

    test "given an empty list of models and empty list of selected facets should return empty lists" do
      assert DataModelFacinator.extract_facets([], %{}) == %{
               organization: [],
               keywords: [],
               sourceType: []
             }
    end

    test "given an empty list of models and a non-empty list of selected facets should return selected facets with 0 counts" do
      facets = %{organization: ["8-Corner"], keywords: ["turbo", "crust"], sourceType: ["ingest"]}

      assert DataModelFacinator.extract_facets([], facets) ==
               %{
                 organization: [%{name: "8-Corner", count: 0}],
                 keywords: [%{name: "turbo", count: 0}, %{name: "crust", count: 0}],
                 sourceType: [%{name: "ingest", count: 0}]
               }
    end
  end
end
