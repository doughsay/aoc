defmodule AoC.Day09 do
  @moduledoc File.read!("./lib/aoc/day_09.md")

  defstruct knots: [], visited: MapSet.new()

  def new(knot_count \\ 2),
    do: %__MODULE__{knots: Enum.map(0..(knot_count - 1), fn _ -> {0, 0} end)}

  def part_one do
    data()
    |> Enum.reduce(new(), &move/2)
    |> Map.get(:visited)
    |> Enum.count()
  end

  def move({dir, count}, rope) do
    Enum.reduce(1..count, rope, fn _i, %{knots: [head | tail]} = rope ->
      new_knots =
        Enum.scan([add(head, dir) | tail], fn tail, head ->
          fix_tail(head, tail)
        end)

      new_visited = MapSet.put(rope.visited, List.last(new_knots))

      %{rope | knots: new_knots, visited: new_visited}
    end)
  end

  defp add({x, y}, {u, v}), do: {x + u, y + v}
  defp sub({x, y}, {u, v}), do: {x - u, y - v}

  defp fix_tail(head, tail), do: tail |> sub(head) |> fix() |> add(tail)

  defp fix({x, y}) when abs(x) <= 1 and abs(y) <= 1, do: {0, 0}
  defp fix({x, y}), do: {opposite_sign(x), opposite_sign(y)}

  defp opposite_sign(0), do: 0
  defp opposite_sign(x) when x > 0, do: -1
  defp opposite_sign(x) when x < 0, do: 1

  def part_two do
    data()
    |> Enum.reduce(new(10), &move/2)
    |> Map.get(:visited)
    |> Enum.count()
  end

  defp data do
    "./data/day_09.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&decode_move/1)
  end

  defp decode_move(<<dir::binary-size(1)>> <> " " <> count),
    do: {direction(dir), String.to_integer(count)}

  defp direction("U"), do: {0, 1}
  defp direction("D"), do: {0, -1}
  defp direction("L"), do: {-1, 0}
  defp direction("R"), do: {1, 0}
end
