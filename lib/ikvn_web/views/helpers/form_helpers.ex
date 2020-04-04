defmodule IkvnWeb.FormHelpers do
  import Phoenix.HTML.Tag

  def submit_data(text, opts \\ [])

  def submit_data(opts, do: block_option) do
    {to, opts} = Keyword.pop(opts, :to)
    {method, opts} = Keyword.pop(opts, :method, :get)
    method = to_string(method)
    {data, opts} = Keyword.pop(opts, :data, %{})
    {form_opts, opts} = Keyword.pop(opts, :form, [])

    form_tag(to, Keyword.put(form_opts, :method, method)) do
      Enum.map(data, fn {k, v} ->
        tag :input, type: :hidden, name: k, value: v
      end)
      ++
      content_tag :button, Keyword.put(opts, :type, :submit) do
        block_option
      end
    end
  end

  def submit_data(text, opts) do
    submit_data opts, do: text
  end
end
