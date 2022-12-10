defmodule AoC.Day10 do
  @moduledoc File.read!("./lib/aoc/day_10.md")

  @part_one_cycles [20, 60, 100, 140, 180, 220]

  def part_one do
    [first | instructions] = data()

    state = %{
      x: 1,
      instructions_remaining: instructions,
      current_instruction: start_instruction(first),
      signal_strengths: []
    }

    state = Enum.reduce(1..220, state, &clock/2)

    Enum.sum(state.signal_strengths)
  end

  defp start_instruction(:noop), do: {:noop, 0}
  defp start_instruction({:addx, val}), do: {{:addx, val}, 1}

  defp clock(cycle, state) do
    {instruction, cycles_remaining} = state.current_instruction

    state =
      if cycle in @part_one_cycles do
        record_signal_strength(state, cycle)
      else
        state
      end

    if cycles_remaining == 0 do
      state
      |> apply_instruction(instruction)
      |> start_next_instruction()
    else
      continue_instruction(state)
    end
  end

  defp continue_instruction(state) do
    {instruction, cycles_remaining} = state.current_instruction
    %{state | current_instruction: {instruction, cycles_remaining - 1}}
  end

  defp apply_instruction(state, :noop), do: state
  defp apply_instruction(state, {:addx, val}), do: %{state | x: state.x + val}

  defp start_next_instruction(%{instructions_remaining: []} = state),
    do: %{state | current_instruction: start_instruction(:noop)}

  defp start_next_instruction(state) do
    %{instructions_remaining: [next_instruction | rest]} = state

    %{
      state
      | instructions_remaining: rest,
        current_instruction: start_instruction(next_instruction)
    }
  end

  defp record_signal_strength(state, cycle) do
    %{state | signal_strengths: [state.x * cycle | state.signal_strengths]}
  end

  def part_two do
    [first | instructions] = data()

    state = %{
      x: 1,
      instructions_remaining: instructions,
      current_instruction: start_instruction(first),
      screen: []
    }

    state = Enum.reduce(1..240, state, &clock2/2)

    state.screen
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp clock2(cycle, state) do
    {instruction, cycles_remaining} = state.current_instruction

    position = (cycle - 1) |> rem(40)

    state =
      if position in (state.x - 1)..(state.x + 1) do
        draw(state, "#")
      else
        draw(state, ".")
      end

    if cycles_remaining == 0 do
      state
      |> apply_instruction(instruction)
      |> start_next_instruction()
    else
      continue_instruction(state)
    end
  end

  defp draw(state, pixel), do: %{state | screen: [pixel | state.screen]}

  defp data do
    "./data/day_10.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&decode_instruction/1)
  end

  defp decode_instruction("noop"), do: :noop
  defp decode_instruction("addx " <> val), do: {:addx, String.to_integer(val)}
end
