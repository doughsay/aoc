defmodule AoC.Day01Test do
  use ExUnit.Case

  alias AoC.Day01

  test "gets the right answer for part one" do
    assert Day01.part_one() == 71300
  end

  test "gets the right answer for part two" do
    assert Day01.part_two() == 209_691
  end
end
