defmodule AoC.Day08Test do
  use ExUnit.Case

  alias AoC.Day08

  test "gets the right answer for part one" do
    assert Day08.part_one() == 1713
  end

  test "gets the right answer for part two" do
    assert Day08.part_two() == 268_464
  end
end
