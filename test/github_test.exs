Code.require_file "test_helper.exs", __DIR__
Code.require_file "mock.exs", __DIR__

defmodule GithubTest do
  use ExUnit.Case
  require MockEx

  defmodule ConnectionTest do
    use ExUnit.Case

    test "unauthenticated get" do
        MockEx.with_mock HTTPotion,
            [get: fn("https://api.github.com/users/jjh42", _headers) ->
                HTTPotion.Response.new(status_code: 200,
                    body: "{ \"email\": \"j@me.net.nz\"}") end] do
          response = Github.Connection.get(:nil, "users/jjh42")
          assert response = { :ok, [email: "j@me.net.nz"]}
          MockEx.assert_called HTTPotion, :get, ["https://api.github.com/users/jjh42", :_]
        end
    end
  end

  test "user.email" do
      :meck.new(HTTPotion)
      :meck.expect(HTTPotion, :get, fn("https://api.github.com/users/jjh42",
                                      _headers) ->
           HTTPotion.Response.new(status_code: 200,
                                  body: "{ \"email\": \"j@me.net.nz\"}") end)
      { :ok, user} = Github.user("jjh42")
      assert Keyword.get(user, :email) == "j@me.net.nz"
      :meck.unload(HTTPotion)
	end
end
