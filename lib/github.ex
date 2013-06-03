defmodule Github do
  @moduledoc "Synchronous github client library."

  @doc """
       Encapsulates the protocol for requesting a URL
       from github. Generally, an client of these libraries
       should not need to use this protocol directly.
       """
  defprotocol Connection do
    @only [Atom] #Record
    def get(connection, path)
  end

  defimpl Connection, for: Atom do
    def get(:nil, path) do
      response = HTTPotion.get "https://api.github.com/" <> path,
              [{ "User-agent", "GithubEx (https://github.com/jjh42/githubex)"}]    
      case response.status_code do
        200 ->
          { :ok, response }
        _ ->
          { :error, response }
      end
    end
  end

  @doc """
       Create a connection to github - use this to insert authentication
       information or a custom URL.
       """
  def create_connection() do
    nil
  end

  def user(name // "", conn // nil) do
    { status, response } = Connection.get(conn, "users/" <> name)
    decoded_body = response.body |>
                   Jsonex.decode |>
                   atomify_json
    { status, decoded_body }
	end

  # Turn the returned JSON list into a keyword
  # list for ease of use.
  defp atomify_json([]) do
    []
  end
  defp atomify_json([{string_key, value} | tail ]) do
    [ { binary_to_atom(string_key), value } | atomify_json(tail) ]
  end
end
