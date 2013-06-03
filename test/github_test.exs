Code.require_file "test_helper.exs", __DIR__

defmodule GithubTest do
  use ExUnit.Case

  test "user.email" do
    { :ok, user} = Github.user("jjh42")
    assert Keyword.get(user, :email) == "j@me.net.nz"
	end
end
