defmodule AoC.Day05Test do
  use ExUnit.Case

  alias AoC.Day05

  test "gets the right answer for part one" do
    assert Day05.part_one() == "FWNSHLDNZ"
  end

  test "gets the right answer for part two" do
    assert Day05.part_two() == "RNRGDNFQG"
  end
end
