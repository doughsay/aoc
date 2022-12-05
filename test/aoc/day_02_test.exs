defmodule AoC.Day02Test do
  use ExUnit.Case

  alias AoC.Day02

  test "gets the right answer for part one" do
    assert Day02.part_one() == 8933
  end

  test "gets the right answer for part two" do
    assert Day02.part_two() == 11998
  end
end
