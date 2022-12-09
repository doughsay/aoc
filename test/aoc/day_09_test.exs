defmodule AoC.Day09Test do
  use ExUnit.Case

  alias AoC.Day09

  test "gets the right answer for part one" do
    assert Day09.part_one() == 5883
  end

  test "gets the right answer for part two" do
    assert Day09.part_two() == 2367
  end
end
