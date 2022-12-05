defmodule AoC.Day03 do
  @moduledoc File.read!("./lib/aoc/day_03.md")

  def part_one do
    data()
    |> Enum.map(&common_char_in_compartments_priority/1)
    |> Enum.sum()
  end

  defp common_char_in_compartments_priority(line) do
    list = String.to_charlist(line)
    {comp1, comp2} = Enum.split(list, div(length(list), 2))
    [char] = MapSet.intersection(MapSet.new(comp1), MapSet.new(comp2)) |> MapSet.to_list()
    char_priority(char)
  end

  defp char_priority(char) when char >= 97, do: char - 96
  defp char_priority(char), do: char - 38

  def part_two do
    data()
    |> Enum.chunk_every(3)
    |> Enum.map(&common_char_in_group_priority/1)
    |> Enum.sum()
  end

  defp common_char_in_group_priority(group) do
    [elf1, elf2, elf3] =
      Enum.map(group, fn line ->
        line |> String.to_charlist() |> MapSet.new()
      end)

    [char] =
      elf1
      |> MapSet.intersection(elf2)
      |> MapSet.intersection(elf3)
      |> MapSet.to_list()

    char_priority(char)
  end

  defp data do
    "./data/day_03.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end
end
