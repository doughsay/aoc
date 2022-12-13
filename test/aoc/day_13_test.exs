defmodule AoC.Day13Test do
  use ExUnit.Case

  alias AoC.Day13

  test "gets the right answer for part one" do
    assert Day13.part_one() == 5330
  end

  test "gets the right answer for part two" do
    assert Day13.part_two() == 27648
  end
end
