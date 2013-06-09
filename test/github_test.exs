Code.require_file "test_helper.exs", __DIR__

defmodule GithubTest do
  use ExUnit.Case
  import Mock

  defmodule ConnectionTest do
    use ExUnit.Case

    test "unauthenticated get" do
        with_mock HTTPotion,
            [get: fn("https://api.github.com/users/jjh42", _headers) ->
                HTTPotion.Response.new(status_code: 200,
                    body: "{ \"email\": \"j@me.net.nz\"}") end] do
          response = Github.Connection.get(:nil, "users/jjh42")
          assert response == { :ok, [email: "j@me.net.nz"]}
          assert called HTTPotion.get("https://api.github.com/users/jjh42", :_)
        end
    end
  end

  test "user.email" do
    with_mock HTTPotion,
        [get: fn("https://api.github.com/users/jjh42", _headers) ->
             HTTPotion.Response.new(status_code: 200,
                 body: "{ \"email\": \"j@me.net.nz\"}") end] do
      { :ok, user} = Github.user("jjh42")
      assert Keyword.get(user, :email) == "j@me.net.nz"
    end
	end
end
