defmodule Issues.GithubIssues do
  @github_url Application.compile_env!(:issues, :github_url)
  @headers [{"User-Agent", "Elixissues"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@headers)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({_, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_status(),
      body |> Poison.Parser.parse!()
    }
  end

  defp check_status(200), do: :ok
  defp check_status(_), do: :error
end
