defmodule AoC.Day12 do
  @moduledoc File.read!("./lib/aoc/day_12.md")

  def part_one do
    {graph, start_point, end_point, _lows} = build_graph()

    count_steps(graph, start_point, end_point)
  end

  defp build_graph do
    {grid, start_point, end_point, lows} = data()
    max_x = Arrays.size(grid[0]) - 1
    max_y = Arrays.size(grid) - 1

    graph = Graph.new()

    graph =
      for y <- 0..max_y, x <- 0..max_x, reduce: graph do
        graph -> Graph.add_vertex(graph, {x, y})
      end

    graph =
      for y <- 0..max_y,
          x <- 0..max_x,
          neighbor <- get_reachable_neighbors(grid, {x, y}),
          reduce: graph do
        graph -> Graph.add_edge(graph, {x, y}, neighbor)
      end

    {graph, start_point, end_point, lows}
  end

  defp count_steps(graph, start_point, end_point) do
    case Graph.a_star(graph, start_point, end_point, &manhattan_distance(&1, end_point)) do
      nil -> nil
      # why is it + 1?
      steps -> Enum.count(steps) - 1
    end
  end

  def manhattan_distance({a, b}, {c, d}), do: abs(a - c) + abs(b - d)

  def get_reachable_neighbors(grid, {x, y}) do
    max_x = Arrays.size(grid[0]) - 1
    max_y = Arrays.size(grid) - 1
    height = grid[y][x]

    for {dx, dy} <- [{0, -1}, {0, 1}, {-1, 0}, {1, 0}],
        nx = x + dx,
        ny = y + dy,
        nx in 0..max_x,
        ny in 0..max_y,
        grid[ny][nx] <= height + 1 do
      {nx, ny}
    end
  end

  def part_two do
    {graph, _start_point, end_point, lows} = build_graph()

    Enum.map(lows, fn point -> count_steps(graph, point, end_point) end)
    |> Enum.filter(& &1)
    |> Enum.min()
  end

  def data do
    grid =
      "./data/day_12.txt"
      |> File.read!()
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line ->
        line |> String.to_charlist() |> Enum.map(&(&1 - 97)) |> Arrays.new()
      end)
      |> Arrays.new()

    {start_point, grid} = find_and_fix(grid, -14, 0)
    {end_point, grid} = find_and_fix(grid, -28, 25)

    all_lows = find_all_lows(grid)

    {grid, start_point, end_point, all_lows}
  end

  def find_and_fix(grid, find, replace) do
    {x, y} =
      grid
      |> Enum.with_index()
      |> Enum.find_value(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.find_value(fn {cell, x} ->
          if cell == find, do: {x, y}
        end)
      end)

    {{x, y}, put_in(grid, [y, x], replace)}
  end

  def find_all_lows(grid) do
    max_x = Arrays.size(grid[0]) - 1
    max_y = Arrays.size(grid) - 1

    for y <- 0..max_y, x <- 0..max_x, reduce: [] do
      acc -> if grid[y][x] == 0, do: [{x, y} | acc], else: acc
    end
  end
end
