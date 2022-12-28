defmodule QRCode do
  @moduledoc """
  QR code generator.
  """

  @doc """
  See `QRCode.QR.create/2`
  """
  defdelegate create(text, ecc_level \\ :low), to: QRCode.QR

  @doc """
  See `QRCode.QR.create!/2`
  """
  defdelegate create!(text, ecc_level \\ :low), to: QRCode.QR

  @doc """
  See `QRCode.Render.render/2`
  """
  defdelegate render(qr, render_module \\ :svg),
    to: QRCode.Render

  @doc """
  See `QRCode.Render.render/3`
  """
  defdelegate render(qr, render_module, render_settings),
    to: QRCode.Render

  @doc """
  Encodes rendered QR matrix as `svg` or `png` binary into a base 64.
  This encoded string can be then used in Html as

  For `svg` use
  ```
  <img src="data:image/svg+xml; base64, encoded_svg_qr_code" alt="QR code" />
  ```

  and in case of `png`
  ```
  <img src="data:image/png; base64, encoded_png_qr_code" alt="QR code" />
  ```
  """
  @spec to_base64(Result.t(String.t(), binary())) :: Result.t(String.t(), binary())
  def to_base64({:ok, rendered_qr_matrix}) do
    rendered_qr_matrix
    |> Base.encode64()
    |> Result.ok()
  end

  def to_base64(error), do: error

  @doc """
  Saves rendered QR code to `svg` or `png` file. See a few examples below:

  ```elixir
    iex> "Hello World"
          |> QRCode.create(:high)
          |> QRCode.render(:svg)
          |> QRCode.save("/path/to/hello.svg")
    {:ok, "/path/to/hello.svg"}
  ```

  ```elixir
    iex> png_settings = %QRCode.Render.PngSettings{qrcode_color: {17, 170, 136}}
    iex> "Hello World"
          |> QRCode.create(:high)
          |> QRCode.render(:png, png_settings)
          |> QRCode.save("/tmp/to/hello.png")
    {:ok, "/path/to/hello.png"}
  ```
  ![QR code color](docs/qrcode_color.png)
  """
  @spec save(Result.t(any(), binary()), Path.t()) ::
          Result.t(String.t() | File.posix() | :badarg | :terminated, Path.t())
  def save({:ok, rendered_qr_matrix}, path_with_file_name) do
    case File.write(path_with_file_name, rendered_qr_matrix) do
      :ok -> {:ok, path_with_file_name}
      err -> err
    end
  end

  def save(error, _path_with_file_name), do: error
end
