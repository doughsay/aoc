defmodule AoC.Day07Test do
  use ExUnit.Case

  alias AoC.Day07

  test "gets the right answer for part one" do
    assert Day07.part_one() == 1_297_159
  end

  test "gets the right answer for part two" do
    assert Day07.part_two() == 3_866_390
  end
end
