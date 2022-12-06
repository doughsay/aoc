defmodule AoC.Day06Test do
  use ExUnit.Case

  alias AoC.Day06

  test "gets the right answer for part one" do
    assert Day06.part_one() == 1275
  end

  test "gets the right answer for part two" do
    assert Day06.part_two() == 3605
  end
end
