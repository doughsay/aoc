defmodule AoC.Day09 do
  @moduledoc File.read!("./lib/aoc/day_09.md")

  defstruct head: {0, 0}, tail: [], visited: MapSet.new()

  defp new(tail_count \\ 1),
    do: %__MODULE__{tail: Enum.map(0..(tail_count - 1), fn _ -> {0, 0} end)}

  def part_one do
    data()
    |> Enum.reduce(new(), &move/2)
    |> Map.get(:visited)
    |> Enum.count()
  end

  defp move({:up, count}, state), do: do_move(state, {0, 1}, count)
  defp move({:down, count}, state), do: do_move(state, {0, -1}, count)
  defp move({:right, count}, state), do: do_move(state, {1, 0}, count)
  defp move({:left, count}, state), do: do_move(state, {-1, 0}, count)

  defp do_move(state, dir, count) do
    Enum.reduce(1..count, state, fn _, state ->
      new_head = add(state.head, dir)

      {_, new_tail} =
        Enum.reduce(state.tail, {new_head, []}, fn tail, {head, acc} ->
          new_tail = fix_tail(head, tail)
          {new_tail, [new_tail | acc]}
        end)

      new_visited = MapSet.put(state.visited, hd(new_tail))

      %{state | head: new_head, tail: Enum.reverse(new_tail), visited: new_visited}
    end)
  end

  defp add({x, y}, {u, v}), do: {x + u, y + v}
  defp sub({x, y}, {u, v}), do: {x - u, y - v}

  defp fix_tail(head, tail), do: sub(tail, head) |> do_fix_tail(tail)

  # up
  defp do_fix_tail({0, -2}, tail), do: add(tail, {0, 1})
  defp do_fix_tail({-1, -2}, tail), do: add(tail, {1, 1})
  defp do_fix_tail({1, -2}, tail), do: add(tail, {-1, 1})

  # down
  defp do_fix_tail({0, 2}, tail), do: add(tail, {0, -1})
  defp do_fix_tail({-1, 2}, tail), do: add(tail, {1, -1})
  defp do_fix_tail({1, 2}, tail), do: add(tail, {-1, -1})

  # right
  defp do_fix_tail({-2, 0}, tail), do: add(tail, {1, 0})
  defp do_fix_tail({-2, -1}, tail), do: add(tail, {1, 1})
  defp do_fix_tail({-2, 1}, tail), do: add(tail, {1, -1})

  # left
  defp do_fix_tail({2, 0}, tail), do: add(tail, {-1, 0})
  defp do_fix_tail({2, -1}, tail), do: add(tail, {-1, 1})
  defp do_fix_tail({2, 1}, tail), do: add(tail, {-1, -1})

  # diagonals
  defp do_fix_tail({2, 2}, tail), do: add(tail, {-1, -1})
  defp do_fix_tail({-2, -2}, tail), do: add(tail, {1, 1})
  defp do_fix_tail({-2, 2}, tail), do: add(tail, {1, -1})
  defp do_fix_tail({2, -2}, tail), do: add(tail, {-1, 1})

  defp do_fix_tail({x, y}, tail) when abs(x) <= 1 and abs(y) <= 1, do: tail

  def part_two do
    data()
    |> Enum.reduce(new(9), &move/2)
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

  defp direction("U"), do: :up
  defp direction("D"), do: :down
  defp direction("L"), do: :left
  defp direction("R"), do: :right
end
