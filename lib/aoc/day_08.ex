defmodule AoC.Day08 do
  @moduledoc File.read!("./lib/aoc/day_08.md")

  def part_one do
    grid = data()
    max_x = Arrays.size(grid[0]) - 1
    max_y = Arrays.size(grid) - 1

    visible_trees =
      for y <- 1..(max_y - 1),
          x <- 1..(max_x - 1),
          visible?(grid, {x, y}, max_x, max_y) do
        {x, y}
      end

    Enum.count(visible_trees) + ((max_x + 1) * 2 + (max_y + 1) * 2) - 4
  end

  defp visible?(grid, {x, y}, max_x, max_y) do
    visible_from_north(grid, {x, y}) or visible_from_south(grid, {x, y}, max_y) or
      visible_from_east(grid, {x, y}) or visible_from_west(grid, {x, y}, max_x)
  end

  def visible_from_north(grid, {x, y}) do
    height = grid[y][x]

    Enum.reduce((y - 1)..0//-1, true, fn new_y, acc ->
      acc and grid[new_y][x] < height
    end)
  end

  def visible_from_south(grid, {x, y}, max_y) do
    height = grid[y][x]

    Enum.reduce((y + 1)..max_y, true, fn new_y, acc ->
      acc and grid[new_y][x] < height
    end)
  end

  def visible_from_east(grid, {x, y}) do
    height = grid[y][x]

    Enum.reduce((x - 1)..0//-1, true, fn new_x, acc ->
      acc and grid[y][new_x] < height
    end)
  end

  def visible_from_west(grid, {x, y}, max_x) do
    height = grid[y][x]

    Enum.reduce((x + 1)..max_x, true, fn new_x, acc ->
      acc and grid[y][new_x] < height
    end)
  end

  def part_two do
    grid = data()
    max_x = Arrays.size(grid[0]) - 1
    max_y = Arrays.size(grid) - 1

    for y <- 0..max_y,
        x <- 0..max_x do
      {x, y}
    end
    |> Enum.map(fn {x, y} ->
      calculate_scenic_score(grid, {x, y}, max_x, max_y)
    end)
    |> Enum.max()
  end

  defp calculate_scenic_score(grid, {x, y}, max_x, max_y) do
    num_visible_north(grid, {x, y}) * num_visible_south(grid, {x, y}, max_y) *
      num_visible_east(grid, {x, y}) * num_visible_west(grid, {x, y}, max_x)
  end

  defp num_visible_north(_grid, {_x, 0}), do: 0

  defp num_visible_north(grid, {x, y}) do
    height = grid[y][x]

    Enum.reduce_while((y - 1)..0//-1, 0, fn new_y, acc ->
      if grid[new_y][x] >= height do
        {:halt, acc + 1}
      else
        {:cont, acc + 1}
      end
    end)
  end

  defp num_visible_south(_grid, {_x, max_y}, max_y), do: 0

  defp num_visible_south(grid, {x, y}, max_y) do
    height = grid[y][x]

    Enum.reduce_while((y + 1)..max_y, 0, fn new_y, acc ->
      if grid[new_y][x] >= height do
        {:halt, acc + 1}
      else
        {:cont, acc + 1}
      end
    end)
  end

  defp num_visible_east(_grid, {0, _y}), do: 0

  defp num_visible_east(grid, {x, y}) do
    height = grid[y][x]

    Enum.reduce_while((x - 1)..0//-1, 0, fn new_x, acc ->
      if grid[y][new_x] >= height do
        {:halt, acc + 1}
      else
        {:cont, acc + 1}
      end
    end)
  end

  defp num_visible_west(_grid, {max_x, _y}, max_x), do: 0

  defp num_visible_west(grid, {x, y}, max_x) do
    height = grid[y][x]

    Enum.reduce_while((x + 1)..max_x, 0, fn new_x, acc ->
      if grid[y][new_x] >= height do
        {:halt, acc + 1}
      else
        {:cont, acc + 1}
      end
    end)
  end

  def data do
    "./data/day_08.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1) |> Arrays.new()
    end)
    |> Arrays.new()
  end
end
