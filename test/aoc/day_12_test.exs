defmodule AoC.Day12Test do
  use ExUnit.Case

  alias AoC.Day12

  test "gets the right answer for part one" do
    assert Day12.part_one() == 437
  end

  test "gets the right answer for part two" do
    assert Day12.part_two() == 430
  end
end
