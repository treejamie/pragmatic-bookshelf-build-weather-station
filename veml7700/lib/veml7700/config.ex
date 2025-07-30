defmodule Veml7700.Config do
  defstruct gain: :gain_1_4th,
            int_time: :it_100_ms,
            shutdown: false,
            interrupt: false

  def new, do: struct(__MODULE__)
  def new(opts), do: struct(__MODULE__, opts)

  def to_integer(config) do
    reserved = 0
    persistance_protect = 0

    <<integer::16>> = <<
      reserved::3,
      gain(config.gain)::2,
      reserved::1,
      int_time(config.int_time)::4,
      persistance_protect::2,
      reserved::2,
      interupt(config.interrupt)::1,
      shutdown(config.shutdown)::1
    >>

    integer
  end

  # in the datasheet, these values are on page 7

  defp gain(:gain_1x), do: 0b0
  defp gain(:gain_2x), do: 0b01
  defp gain(:gain_1_8th), do: 0b10
  defp gain(:gain_1_4th), do: 0b11
  defp gain(:gain_default), do: gain(:gain_1_4th)

  defp int_time(:it_25ms), do: 0b1100
  defp int_time(:it_50ms), do: 0b1000
  defp int_time(:it_100ms), do: 0b0000
  defp int_time(:it_200ms), do: 0b0001
  defp int_time(:it_400ms), do: 0b0010
  defp int_time(:it_800ms), do: 0b0011
  defp int_time(:it_default), do: int_time(:it_100ms)

  defp shutdown(true), do: 1
  defp shurdown(_), do: 0

  defp interrupt(true), do: 1
  defp interrupt(_), do: 0
end
