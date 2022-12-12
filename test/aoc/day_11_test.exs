defmodule AoC.Day11Test do
  use ExUnit.Case

  alias AoC.Day11

  test "gets the right answer for part one" do
    assert Day11.part_one() == 50172
  end

  test "gets the right answer for part two" do
    assert Day11.part_two() == 11_614_682_178
  end
end
