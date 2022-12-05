defmodule AoC.Day05 do
  @moduledoc File.read!("./lib/aoc/day_05.md")

  # Just hard-coding the literal initial data-structure so I don't have to
  # figure out how to parse it...😜
  @initial_crates %{
    1 => ~w(N W F R Z S M D),
    2 => ~w(S G Q P W),
    3 => ~w(C J N F Q V R W),
    4 => ~w(L D G C P Z F),
    5 => ~w(S P T),
    6 => ~w(L R W F D H),
    7 => ~w(C D N Z),
    8 => ~w(Q J S V F R N W),
    9 => ~w(V W Z G S M R)
  }

  def part_one do
    data()
    |> Enum.reduce(@initial_crates, &apply_move/2)
    |> get_answer()
  end

  def part_two do
    data()
    |> Enum.reduce(@initial_crates, &apply_move(&1, &2, false))
    |> get_answer()
  end

  defp apply_move(move, crates, reverse? \\ true) do
    {taken, new_from} = Enum.split(crates[move.from], move.count)

    new_to =
      if reverse? do
        Enum.reverse(taken) ++ crates[move.to]
      else
        taken ++ crates[move.to]
      end

    crates
    |> Map.put(move.from, new_from)
    |> Map.put(move.to, new_to)
  end

  defp get_answer(crates) do
    1..9
    |> Enum.map(fn i -> hd(crates[i]) end)
    |> Enum.join("")
  end

  defp data do
    [_crates, moves] =
      "./data/day_05.txt"
      |> File.read!()
      |> String.trim()
      |> String.split("\n\n")

    moves
    |> String.split("\n")
    |> Enum.map(&decode_move/1)
  end

  @move_regex ~r/move (\d+) from (\d+) to (\d+)/
  defp decode_move(line) do
    [_match, count, from, to] = Regex.run(@move_regex, line)

    %{
      count: String.to_integer(count),
      from: String.to_integer(from),
      to: String.to_integer(to)
    }
  end
end
