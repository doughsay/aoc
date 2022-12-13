defmodule AoC.Day13 do
  @moduledoc File.read!("./lib/aoc/day_13.md")

  def part_one do
    data()
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {[left, right], idx} ->
      if is_right_order(left, right), do: [idx], else: []
    end)
    |> Enum.sum()
  end

  @sep1 [[2]]
  @sep2 [[6]]
  def part_two do
    packets = Enum.sort([@sep1, @sep2 | data()], &is_right_order/2)
    find_packet_index(packets, @sep1) * find_packet_index(packets, @sep2)
  end

  defp find_packet_index(packets, packet) do
    Enum.find_index(packets, fn
      ^packet -> true
      _else -> false
    end) + 1
  end

  def is_right_order([same | lefts], [same | rights]) when is_integer(same),
    do: is_right_order(lefts, rights)

  def is_right_order([left | _lefts], [right | _rights])
      when is_integer(left) and is_integer(right),
      do: left < right

  def is_right_order([left | lefts], [right | rights]) when is_list(left) and is_list(right) do
    case is_right_order(left, right) do
      true -> true
      false -> false
      :continue -> is_right_order(lefts, rights)
    end
  end

  def is_right_order([left | lefts], [right | rights]) when is_integer(left) and is_list(right),
    do: is_right_order([[left] | lefts], [right | rights])

  def is_right_order([left | lefts], [right | rights]) when is_list(left) and is_integer(right),
    do: is_right_order([left | lefts], [[right] | rights])

  def is_right_order([], [_right | _rights]), do: true
  def is_right_order([_left | _lefts], []), do: false
  def is_right_order([], []), do: :continue

  defp data do
    "./data/day_13.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&Jason.decode!/1)
  end
end
