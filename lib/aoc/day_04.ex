defmodule AoC.Day04 do
  @moduledoc File.read!("./lib/aoc/day_04.md")

  def part_one do
    data()
    |> Enum.map(&as_sets/1)
    |> Enum.count(&subsets?/1)
  end

  def part_two do
    data()
    |> Enum.map(&as_sets/1)
    |> Enum.count(&has_overlap?/1)
  end

  defp as_sets(line) do
    line
    |> String.split(",")
    |> Enum.map(fn range ->
      [first, last] = String.split(range, "-")
      Range.new(String.to_integer(first), String.to_integer(last)) |> MapSet.new()
    end)
  end

  defp subsets?([set1, set2]),
    do: MapSet.subset?(set1, set2) or MapSet.subset?(set2, set1)

  defp has_overlap?([set1, set2]), do: !MapSet.disjoint?(set1, set2)

  defp data do
    "./data/day_04.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
