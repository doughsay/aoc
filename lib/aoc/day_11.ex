defmodule AoC.Day11 do
  @moduledoc File.read!("./lib/aoc/day_11.md")

  defmodule Monkey do
    defstruct [:id, :items, :operation, :divisor, :true_dest, :false_dest, :inspect_count]

    def new(id, items, operation, divisor, true_dest, false_dest),
      do: %__MODULE__{
        id: id,
        items: items,
        operation: operation,
        divisor: divisor,
        true_dest: true_dest,
        false_dest: false_dest,
        inspect_count: 0
      }
  end

  def part_one do
    monkeys = data()

    Enum.reduce(1..20, monkeys, fn _round, monkeys ->
      Enum.reduce(monkeys, monkeys, fn {id, _stale_monkey}, monkeys ->
        monkey = monkeys[id]

        Enum.reduce(monkey.items, monkeys, fn item, monkeys ->
          monkeys = increment_inspect_count(monkeys, monkey.id)
          new_item = monkey.operation.(item)
          deescalated_item = div(new_item, 3)
          dest = choose_destination_monkey(monkey, deescalated_item)

          throw_current_item_to(monkeys, monkey.id, dest, deescalated_item)
        end)
      end)
    end)
    |> Enum.map(fn {_id, %Monkey{inspect_count: x}} -> x end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp increment_inspect_count(monkeys, id),
    do: update_in(monkeys, [id, Access.key(:inspect_count)], &(&1 + 1))

  defp choose_destination_monkey(monkey, item) do
    if rem(item, monkey.divisor) == 0 do
      monkey.true_dest
    else
      monkey.false_dest
    end
  end

  defp throw_current_item_to(monkeys, source_id, dest_id, worry_level) do
    {_discarded, monkeys} = pop_in(monkeys, [source_id, Access.key(:items), Access.at(0)])

    update_in(monkeys, [dest_id, Access.key(:items)], fn items ->
      items ++ [worry_level]
    end)
  end

  def part_two do
    monkeys = data()

    common_multiple =
      monkeys |> Map.values() |> Enum.map(& &1.divisor) |> Enum.reduce(&Kernel.*/2)

    Enum.reduce(1..10_000, monkeys, fn _round, monkeys ->
      Enum.reduce(monkeys, monkeys, fn {id, _stale_monkey}, monkeys ->
        monkey = monkeys[id]

        Enum.reduce(monkey.items, monkeys, fn item, monkeys ->
          monkeys = increment_inspect_count(monkeys, monkey.id)
          new_item = monkey.operation.(item)
          deescalated_item = rem(new_item, common_multiple)
          dest = choose_destination_monkey(monkey, deescalated_item)

          throw_current_item_to(monkeys, monkey.id, dest, deescalated_item)
        end)
      end)
    end)
    |> Enum.map(fn {_id, %Monkey{inspect_count: x}} -> x end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*/2)
  end

  defp data do
    "./data/day_11.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n\n")
    |> Map.new(&parse_monkey/1)
  end

  defp parse_monkey(monkey_string) do
    [
      title,
      starting_items,
      operation,
      test,
      if_true,
      if_false
    ] = monkey_string |> String.split("\n") |> Enum.map(&String.trim/1)

    id = parse_title(title)

    monkey =
      Monkey.new(
        id,
        parse_starting_items(starting_items),
        parse_operation(operation),
        parse_divisor(test),
        parse_true_dest(if_true),
        parse_false_dest(if_false)
      )

    {id, monkey}
  end

  defp parse_title("Monkey " <> index), do: index |> Integer.parse() |> elem(0)

  defp parse_starting_items("Starting items: " <> items),
    do: items |> String.split(", ") |> Enum.map(&String.to_integer/1)

  defp parse_operation("Operation: new = old * old"), do: fn x -> x * x end

  defp parse_operation("Operation: new = old " <> <<op::binary-size(1)>> <> " " <> val),
    do: do_parse_op(op, String.to_integer(val))

  defp do_parse_op("*", val), do: fn x -> x * val end
  defp do_parse_op("+", val), do: fn x -> x + val end

  defp parse_divisor("Test: divisible by " <> val), do: String.to_integer(val)
  defp parse_true_dest("If true: throw to monkey " <> true_to), do: String.to_integer(true_to)
  defp parse_false_dest("If false: throw to monkey " <> false_to), do: String.to_integer(false_to)
end
