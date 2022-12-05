defmodule AoC.Day01 do
  @moduledoc File.read!("./lib/aoc/day_01.md")

  def part_one do
    Enum.max(chunk_sums())
  end

  def part_two do
    chunk_sums()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp data do
    "./data/day_01.txt"
    |> File.read!()
    |> String.split("\n")
  end

  defp chunk_sums do
    data()
    |> Enum.chunk_while([], &chunk_fun/2, &{:cont, &1, []})
    |> Enum.map(&Enum.sum/1)
  end

  defp chunk_fun("", acc), do: {:cont, acc, []}
  defp chunk_fun(element, acc), do: {:cont, [String.to_integer(element) | acc]}
end
