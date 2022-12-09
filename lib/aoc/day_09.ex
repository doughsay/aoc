defmodule AoC.Day09 do
  @moduledoc File.read!("./lib/aoc/day_09.md")

  defstruct head: {0, 0}, tail: {0, 0}, visited: MapSet.new()

  def part_one do
    data()
    |> Enum.reduce(%__MODULE__{}, &move/2)
    |> Map.get(:visited)
    |> Enum.count()
  end

  def move({:up, count}, state), do: do_move(state, {0, 1}, count)
  def move({:down, count}, state), do: do_move(state, {0, -1}, count)
  def move({:right, count}, state), do: do_move(state, {1, 0}, count)
  def move({:left, count}, state), do: do_move(state, {-1, 0}, count)

  def do_move(state, dir, count) do
    Enum.reduce(1..count, state, fn _, state ->
      new_head = add(state.head, dir)
      new_tail = fix_tail(state.tail, new_head)
      new_visited = MapSet.put(state.visited, new_tail)

      %{state | head: new_head, tail: new_tail, visited: new_visited}
    end)
  end

  def add({x, y}, {u, v}), do: {x + u, y + v}
  def sub({x, y}, {u, v}), do: {x - u, y - v}

  def fix_tail(tail, head), do: sub(tail, head) |> do_fix_tail(tail)

  # up
  def do_fix_tail({0, -2}, tail), do: add(tail, {0, 1})
  def do_fix_tail({-1, -2}, tail), do: add(tail, {1, 1})
  def do_fix_tail({1, -2}, tail), do: add(tail, {-1, 1})

  # down
  def do_fix_tail({0, 2}, tail), do: add(tail, {0, -1})
  def do_fix_tail({-1, 2}, tail), do: add(tail, {1, -1})
  def do_fix_tail({1, 2}, tail), do: add(tail, {-1, -1})

  # right
  def do_fix_tail({-2, 0}, tail), do: add(tail, {1, 0})
  def do_fix_tail({-2, -1}, tail), do: add(tail, {1, 1})
  def do_fix_tail({-2, 1}, tail), do: add(tail, {1, -1})

  # left
  def do_fix_tail({2, 0}, tail), do: add(tail, {-1, 0})
  def do_fix_tail({2, -1}, tail), do: add(tail, {-1, 1})
  def do_fix_tail({2, 1}, tail), do: add(tail, {-1, -1})

  def do_fix_tail(_, tail), do: tail

  def part_two do
    data()
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
