defmodule AoC.Day07 do
  @moduledoc File.read!("./lib/aoc/day_07.md")

  alias ExZipper.Zipper

  def part_one do
    data()
    |> Stream.unfold(&get_all_sizes/1)
    |> Stream.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  @total_disk_size 70_000_000
  @unused_required 30_000_000

  def part_two do
    zipper = data()

    total_used = size_of_tree(zipper)
    total_unused = @total_disk_size - total_used
    delete_at_least = @unused_required - total_unused

    zipper
    |> Stream.unfold(&get_all_sizes/1)
    |> Enum.sort()
    |> Enum.find(&(&1 >= delete_at_least))
  end

  defp get_all_sizes(zipper) do
    if Zipper.end?(zipper) do
      nil
    else
      {size_of_tree(zipper), Zipper.next(zipper)}
    end
  end

  defp size_of_tree(%Zipper{focus: node}), do: size_of_tree(node)

  defp size_of_tree(node) do
    node.size +
      (node.dirs
       |> Enum.map(&size_of_tree/1)
       |> Enum.sum())
  end

  defp data do
    "./data/day_07.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> build_tree()
  end

  defp build_tree(lines) do
    zipper =
      Zipper.zipper(
        fn node -> is_map(node) and Map.has_key?(node, :dirs) end,
        fn %{dirs: dirs} -> dirs end,
        fn node, new_dirs -> %{node | dirs: new_dirs} end,
        %{name: "/", dirs: [], size: 0}
      )

    lines
    |> Enum.reduce(zipper, &process_line/2)
    |> Zipper.root()
  end

  defp process_line("$ " <> command, zipper), do: process_command(command, zipper)
  defp process_line("dir " <> dirname, zipper), do: add_dir(zipper, dirname)
  defp process_line(file, zipper), do: add_file(zipper, file_size(file))

  defp process_command("cd /", zipper), do: Zipper.root(zipper)
  defp process_command("cd ..", zipper), do: Zipper.up(zipper)
  defp process_command("cd " <> name, zipper), do: zipper |> Zipper.down() |> navigate_to(name)
  defp process_command("ls", zipper), do: zipper

  defp navigate_to(%Zipper{focus: %{name: dirname}} = zipper, dirname), do: zipper
  defp navigate_to(zipper, dirname), do: zipper |> Zipper.right() |> navigate_to(dirname)

  defp file_size(file) do
    [size, _filename] = String.split(file, " ")
    String.to_integer(size)
  end

  defp add_dir(zipper, dirname) do
    Zipper.append_child(zipper, %{name: dirname, dirs: [], size: 0})
  end

  defp add_file(zipper, size) do
    Zipper.edit(zipper, fn node ->
      Map.update!(node, :size, &(&1 + size))
    end)
  end
end
