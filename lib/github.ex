defmodule Github do
  @moduledoc "Synchronous github client library."

  defrecord GithubConnection,
    url: "https://api.github.com/",
    user_agent: "GithubEx (https://github.com/jjh42/githubex)",
    authentication: nil

  defmodule Connection do
    @moduledoc """
               Module for dealing with retreiving data from github.
               End-users should not need to deal with it directly.
               """

    def get(:nil, path) do
      response = HTTPotion.get "https://api.github.com/" <> path,
              [{ "User-agent", "GithubEx (https://github.com/jjh42/githubex)"}]
      decoded_body = response.body |>
                   Jsonex.decode |>
                   atomify_json
      case response.status_code do
        200 ->
          { :ok, decoded_body }
        _ ->

          { :error, decoded_body }
      end
    end

    # Turn the returned JSON list into a keyword
    # list for ease of use.
    defp atomify_json([]), do: []

    defp atomify_json([{string_key, value} | tail ]) do
      [ { binary_to_atom(string_key), value } | atomify_json(tail) ]
    end

  end

  def user(name // "", conn // nil) do
    Connection.get(conn, "users/" <> name)
	end

end
