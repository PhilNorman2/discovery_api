defmodule DiscoveryApiWeb.DatasetQueryController do
  use DiscoveryApiWeb, :controller
  require Logger
  alias DiscoveryApiWeb.DatasetMetricsService

  def query(conn, params) do
    query(conn, params, get_format(conn))
  end

  def query(conn, params, "csv") do
    system_name = conn.assigns.model.systemName

    with {:ok, column_names} <- get_column_names(system_name, Map.get(params, "columns")),
         {:ok, query} <- build_query(params, system_name) do
      DatasetMetricsService.record_api_hit("queries", conn.assigns.model.id)

      query
      |> Prestige.execute()
      |> map_data_stream_for_csv(column_names)
      |> stream_data(conn, system_name, get_format(conn))
    else
      error ->
        handle_error(conn, error)
    end
  end

  def query(conn, params, "json") do
    system_name = conn.assigns.model.systemName

    case build_query(params, system_name) do
      {:ok, query} ->
        DatasetMetricsService.record_api_hit("queries", conn.assigns.model.id)

        data =
          query
          |> Prestige.execute(rows_as_maps: true)
          |> Stream.map(&Jason.encode!/1)
          |> Stream.intersperse(",")

        [["["], data, ["]"]]
        |> Stream.concat()
        |> stream_data(conn, system_name, get_format(conn))

      error ->
        handle_error(conn, error)
    end
  end

  defp(handle_error(conn, {type, reason})) do
    case type do
      :bad_request ->
        Logger.error(reason)
        render_error(conn, 400, "Bad Request")

      :error ->
        Logger.error(reason)
        render_error(conn, 404, "Not Found")
    end
  end

  defp get_column_names(system_name, nil), do: get_column_names(system_name)

  defp get_column_names(system_name, columns_string) do
    case get_column_names(system_name) do
      {:ok, _names} -> {:ok, clean_columns(columns_string)}
      {_, error} -> {:error, error}
    end
  end

  defp get_column_names(system_name) do
    "describe #{system_name}"
    |> Prestige.execute()
    |> Prestige.prefetch()
    |> Enum.map(fn [col | _tail] -> col end)
    |> case do
      [] -> {:error, "Table #{system_name} not found"}
      names -> {:ok, names}
    end
  end

  defp build_query(params, system_name) do
    column_string = Map.get(params, "columns", "*")

    ["SELECT"]
    |> build_columns(column_string)
    |> Enum.concat(["FROM #{system_name}"])
    |> add_clause("where", params)
    |> add_clause("groupBy", params)
    |> add_clause("orderBy", params)
    |> add_clause("limit", params)
    |> Enum.reject(&is_nil/1)
    |> Enum.join(" ")
    |> validate_query()
  end

  defp validate_query(query) do
    [";", "/*", "*/", "--"]
    |> Enum.map(fn x -> String.contains?(query, x) end)
    |> Enum.any?(fn contained_string -> contained_string end)
    |> case do
      true -> {:bad_request, "Query contained illegal character(s): [#{query}]"}
      false -> {:ok, query}
    end
  end

  defp add_clause(clauses, type, map) do
    value = Map.get(map, type, "")
    clauses ++ [build_clause(type, value)]
  end

  defp build_clause(_, ""), do: nil
  defp build_clause("where", value), do: "WHERE #{value}"
  defp build_clause("orderBy", value), do: "ORDER BY #{value}"
  defp build_clause("limit", value), do: "LIMIT #{value}"
  defp build_clause("groupBy", value), do: "GROUP BY #{value}"

  defp build_columns(clauses, column_string) do
    cleaned_columns = column_string |> clean_columns() |> Enum.join(", ")
    clauses ++ [cleaned_columns]
  end

  defp clean_columns(column_string) do
    column_string
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
  end
end
