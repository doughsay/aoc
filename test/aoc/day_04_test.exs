defmodule AoC.Day04Test do
  use ExUnit.Case

  alias AoC.Day04

  test "gets the right answer for part one" do
    assert Day04.part_one() == 500
  end

  test "gets the right answer for part two" do
    assert Day04.part_two() == 815
  end
end
