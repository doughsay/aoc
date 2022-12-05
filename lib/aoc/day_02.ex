defmodule AoC.Day02 do
  @moduledoc File.read!("./lib/aoc/day_02.md")

  def part_one do
    (&decode_part_one/1)
    |> data()
    |> Enum.map(&score_round/1)
    |> Enum.sum()
  end

  def part_two do
    (&decode_part_two/1)
    |> data()
    |> Enum.map(&pick_move/1)
    |> Enum.map(&score_round/1)
    |> Enum.sum()
  end

  defp data(decode_fun) do
    "./data/day_02.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn c -> c |> String.split() |> Enum.map(decode_fun) |> List.to_tuple() end)
  end

  defp decode_part_one("A"), do: :rock
  defp decode_part_one("B"), do: :paper
  defp decode_part_one("C"), do: :scissors
  defp decode_part_one("X"), do: :rock
  defp decode_part_one("Y"), do: :paper
  defp decode_part_one("Z"), do: :scissors

  defp decode_part_two("A"), do: :rock
  defp decode_part_two("B"), do: :paper
  defp decode_part_two("C"), do: :scissors
  defp decode_part_two("X"), do: :lose
  defp decode_part_two("Y"), do: :draw
  defp decode_part_two("Z"), do: :win

  defp win?({:scissors, :rock}), do: true
  defp win?({:rock, :paper}), do: true
  defp win?({:paper, :scissors}), do: true
  defp win?(_round), do: false

  defp draw?({same, same}), do: true
  defp draw?(_round), do: false

  defp score_move(:rock), do: 1
  defp score_move(:paper), do: 2
  defp score_move(:scissors), do: 3

  defp score_win(round) do
    cond do
      win?(round) -> 6
      draw?(round) -> 3
      true -> 0
    end
  end

  defp score_round({_their_move, my_move} = round) do
    score_move(my_move) + score_win(round)
  end

  defp pick_move({their_move, :win}), do: {their_move, move_to_win(their_move)}
  defp pick_move({their_move, :lose}), do: {their_move, move_to_lose(their_move)}
  defp pick_move({their_move, :draw}), do: {their_move, their_move}

  defp move_to_win(:rock), do: :paper
  defp move_to_win(:paper), do: :scissors
  defp move_to_win(:scissors), do: :rock

  defp move_to_lose(:rock), do: :scissors
  defp move_to_lose(:paper), do: :rock
  defp move_to_lose(:scissors), do: :paper
end
