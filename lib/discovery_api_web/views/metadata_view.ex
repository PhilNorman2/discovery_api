defmodule DiscoveryApiWeb.MetadataView do
  use DiscoveryApiWeb, :view
  alias DiscoveryApi.Data.Model

  def accepted_formats() do
    ["json"]
  end

  def render("detail.json", %{model: model}) do
    translate_to_dataset_detail(model)
  end

  def render("fetch_schema.json", %{model: %{schema: schema}}) do
    schema
  end

  defp translate_to_dataset_detail(%Model{} = model) do
    %{
      name: model.name,
      title: model.title,
      description: model.description,
      id: model.id,
      keywords: model.keywords,
      organization: %{
        name: model.organizationDetails.orgName,
        title: model.organizationDetails.orgTitle,
        image: model.organizationDetails.logoUrl,
        description: model.organizationDetails.description,
        homepage: model.organizationDetails.homepage
      },
      sourceType: model.sourceType,
      sourceFormat: model.sourceFormat,
      sourceUrl: model.sourceUrl,
      lastUpdatedDate: model.lastUpdatedDate,
      contactName: model.contactName,
      contactEmail: model.contactEmail,
      license: model.license,
      rights: model.rights,
      homepage: model.homepage,
      spatial: model.spatial,
      temporal: model.temporal,
      publishFrequency: model.publishFrequency,
      conformsToUri: model.conformsToUri,
      describedByUrl: model.describedByUrl,
      describedByMimeType: model.describedByMimeType,
      parentDataset: model.parentDataset,
      issuedDate: model.issuedDate,
      language: model.language,
      referenceUrls: model.referenceUrls,
      categories: model.categories,
      modified: model.modifiedDate,
      downloads: model.downloads,
      queries: model.queries,
      accessLevel: model.accessLevel,
      completeness: model.completeness,
      schema: model.schema,
      systemName: model.systemName
    }
  end
end
