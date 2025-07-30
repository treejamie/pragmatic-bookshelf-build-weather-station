defmodule Veml7700.Config do
  defstruct gain: :gain_1_4th,
            int_time: :it_100ms,
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
      interrupt(config.interrupt)::1,
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
  defp shutdown(_), do: 0

  defp interrupt(true), do: 1
  defp interrupt(_), do: 0

  @to_lumens_factor %{
    {:it_800ms, :gain_2x} => 0.0036,
    {:it_800ms, :gain_1x} => 0.0072,
    {:it_800ms, :gain_1_4th} => 0.0288,
    {:it_800ms, :gain_1_8th} => 0.0576,
    {:it_400ms, :gain_2x} => 0.0072,
    {:it_400ms, :gain_1x} => 0.0144,
    {:it_400ms, :gain_1_4th} => 0.0576,
    {:it_400ms, :gain_1_8th} => 0.1152,
    {:it_200ms, :gain_2x} => 0.0144,
    {:it_200ms, :gain_1x} => 0.0288,
    {:it_200ms, :gain_1_4th} => 0.1152,
    {:it_200ms, :gain_1_8th} => 0.2304,
    {:it_100ms, :gain_2x} => 0.0288,
    {:it_100ms, :gain_1x} => 0.0576,
    {:it_100ms, :gain_1_4th} => 0.2304,
    {:it_100ms, :gain_1_8th} => 0.4608,
    {:it_50ms, :gain_2x} => 0.0576,
    {:it_50ms, :gain_1x} => 0.1152,
    {:it_50ms, :gain_1_4th} => 0.4608,
    {:it_50ms, :gain_1_8th} => 0.9216,
    {:it_25ms, :gain_2x} => 0.1152,
    {:it_25ms, :gain_1x} => 0.2304,
    {:it_25ms, :gain_1_4th} => 0.9216,
    {:it_25ms, :gain_1_8th} => 1.8432
  }

  def to_lumens(config, measurement) do
    @to_lumens_factor[{config.int_time, config.gain}] * measurement
  end
end
