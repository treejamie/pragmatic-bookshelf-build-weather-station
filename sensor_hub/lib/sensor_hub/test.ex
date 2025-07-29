alias Circuits.I2C

defmodule SGP40Test do
  @addr 0x59

  def check(ref) do
    # Run self‑test command (0x280E)
    :ok = I2C.write(ref, @addr, <<0x28, 0x0E>>)
    # wait ~250ms
    Process.sleep(250)

    case I2C.read(ref, @addr, 3) do
      {:ok, <<0xD4, 0x00, _crc>>} -> IO.puts("SGP40 self‑test OK")
      other -> IO.inspect(other, label: "SGP40 self‑test response")
    end
  end
end
