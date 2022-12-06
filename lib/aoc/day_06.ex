defmodule AoC.Day06 do
  @moduledoc File.read!("./lib/aoc/day_06.md")

  def part_one do
    data() |> find_marker(4)
  end

  def part_two do
    data() |> find_marker(14)
  end

  defp find_marker(data, size) do
    data
    |> Enum.chunk_every(size, 1)
    |> Enum.reduce_while(size, fn packet, i ->
      uniques = packet |> MapSet.new() |> MapSet.to_list() |> length()

      if uniques == size do
        {:halt, i}
      else
        {:cont, i + 1}
      end
    end)
  end

  defp data do
    "./data/day_06.txt"
    |> File.read!()
    |> String.trim()
    |> String.to_charlist()
  end
end
