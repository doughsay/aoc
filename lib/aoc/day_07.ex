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
    tree = data()

    total_used = size_of_tree(tree)
    total_unused = @total_disk_size - total_used
    delete_at_least = @unused_required - total_unused

    tree
    |> Stream.unfold(&get_all_sizes/1)
    |> Enum.sort()
    |> Enum.find(&(&1 >= delete_at_least))
  end

  defp get_all_sizes(tree) do
    if Zipper.end?(tree) do
      nil
    else
      {size_of_tree(tree), Zipper.next(tree)}
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
    tree =
      Zipper.zipper(
        fn node -> is_map(node) and Map.has_key?(node, :dirs) end,
        fn %{dirs: dirs} -> dirs end,
        fn node, new_dirs -> %{node | dirs: new_dirs} end,
        %{name: "/", dirs: [], size: 0}
      )

    lines
    |> Enum.reduce(tree, &process_line/2)
    |> Zipper.root()
  end

  defp process_line("$ " <> command, tree), do: process_command(command, tree)
  defp process_line("dir " <> dirname, tree), do: add_dir(tree, dirname)
  defp process_line(size_and_filename, tree), do: add_file(tree, file_size(size_and_filename))

  defp process_command("cd /", tree), do: Zipper.root(tree)
  defp process_command("cd ..", tree), do: Zipper.up(tree)
  defp process_command("cd " <> name, tree), do: tree |> Zipper.down() |> navigate_to(name)
  defp process_command("ls", tree), do: tree

  defp navigate_to(%Zipper{focus: %{name: dirname}} = tree, dirname), do: tree
  defp navigate_to(tree, dirname), do: tree |> Zipper.right() |> navigate_to(dirname)

  defp file_size(size_and_filename) do
    [size, _filename] = String.split(size_and_filename, " ")
    String.to_integer(size)
  end

  defp add_dir(tree, dirname) do
    Zipper.append_child(tree, %{name: dirname, dirs: [], size: 0})
  end

  defp add_file(tree, size) do
    Zipper.edit(tree, fn node ->
      Map.update!(node, :size, &(&1 + size))
    end)
  end
end
