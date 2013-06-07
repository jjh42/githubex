defmodule MockEx do
  @doc """
       Mock up a module for the duration of a test.

       e.g. with_mock(HTTPPotion, [get: fn("http://example.com") ->
                "<html></html>" end] do
              # Tests that make the expected call
            end
       """
  defmacro with_mock(mock_module, mocks, test) do
    quote do
      :meck.new(unquote(mock_module))
      MockEx._install_mock(unquote(mock_module), unquote(mocks))
      try do
        # Do all the tests inside so we can kill the mock
        # if any exception occurs.
        unquote(test)
        assert :meck.validate(unquote(mock_module)) == true
      after
        :meck.unload(unquote(mock_module))
      end
    end
  end

  defmacro assert_called(module, f, args) do
    quote do: assert :meck.called unquote(module), unquote(f), unquote(args)
  end

  def _install_mock(_, []), do: :ok
  def _install_mock(mock_module, [ {fn_name, value} | tail ]) do
    :meck.expect(mock_module, fn_name, value)
    MockEx._install_mock(mock_module, tail)
  end
end
