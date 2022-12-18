defmodule AoC.Day18Test do
  use ExUnit.Case

  alias AoC.Day18

  test "gets the right answer for part one" do
    assert Day18.part_one() == 4310
  end

  test "gets the right answer for part two" do
    assert Day18.part_two() == 2466
  end
end
