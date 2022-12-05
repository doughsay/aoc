defmodule AoC.Day03Test do
  use ExUnit.Case

  alias AoC.Day03

  test "gets the right answer for part one" do
    assert Day03.part_one() == 7428
  end

  test "gets the right answer for part two" do
    assert Day03.part_two() == 2650
  end
end
