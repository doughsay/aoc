defmodule AoC.Day18 do
  @moduledoc File.read!("./lib/aoc/day_18.md")

  @neighbors [{1, 0, 0}, {-1, 0, 0}, {0, 1, 0}, {0, -1, 0}, {0, 0, 1}, {0, 0, -1}]

  def part_one do
    lava = data() |> MapSet.new()

    for point <- lava,
        neighbor <- neighbors(point),
        !MapSet.member?(lava, neighbor),
        reduce: 0 do
      count -> count + 1
    end
  end

  def part_two do
    lava = data() |> MapSet.new()
    air = build_air_set(lava)

    for point <- lava,
        neighbor <- neighbors(point),
        MapSet.member?(air, neighbor),
        reduce: 0 do
      count -> count + 1
    end
  end

  def neighbors({x, y, z}) do
    for {dx, dy, dz} <- @neighbors, do: {x + dx, y + dy, z + dz}
  end

  def build_air_set(lava) do
    {min_x, max_x} = lava |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = lava |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    {min_z, max_z} = lava |> Enum.map(&elem(&1, 2)) |> Enum.min_max()

    bounding_box = {(min_x - 1)..(max_x + 1), (min_y - 1)..(max_y + 1), (min_z - 1)..(max_z + 1)}

    start_point = {min_x - 1, min_y - 1, min_z - 1}

    flood_fill(start_point, bounding_box, lava)
  end

  def flood_fill(point, bounds, lava, output \\ MapSet.new()) do
    if inside?(point, bounds) and !MapSet.member?(lava, point) and !MapSet.member?(output, point) do
      output = MapSet.put(output, point)

      for neighbor <- neighbors(point), reduce: output do
        output -> flood_fill(neighbor, bounds, lava, output)
      end
    else
      output
    end
  end

  def inside?({x, y, z}, {xs, ys, zs}), do: x in xs and y in ys and z in zs

  def data do
    "./data/day_18.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_triple/1)
  end

  def parse_triple(line) do
    line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end
end
