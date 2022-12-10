defmodule AoC.Day10Test do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias AoC.Day10

  test "gets the right answer for part one" do
    assert Day10.part_one() == 13060
  end

  test "gets the right answer for part two" do
    assert capture_io(fn -> Day10.part_two() end) ==
             """
             ####...##.#..#.###..#..#.#....###..####.
             #.......#.#..#.#..#.#..#.#....#..#....#.
             ###.....#.#..#.###..#..#.#....#..#...#..
             #.......#.#..#.#..#.#..#.#....###...#...
             #....#..#.#..#.#..#.#..#.#....#.#..#....
             #.....##...##..###...##..####.#..#.####.
             """
  end
end
