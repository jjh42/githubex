Code.require_file "test_helper.exs", __DIR__

defmodule GithubTest do
  use ExUnit.Case

  test "user.email" do
    :meck.new(HTTPotion)
    :meck.expect(HTTPotion, :get, fn("https://api.github.com/users/jjh42",
                                    _headers) ->
         HTTPotion.Response.new(status_code: 200,
                                body: "{ \"email\": \"j@me.net.nz\"}") end)
    { :ok, user} = Github.user("jjh42")
    assert Keyword.get(user, :email) == "j@me.net.nz"
	end
end
