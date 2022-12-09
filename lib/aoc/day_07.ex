defmodule AoC.Day07 do
  @moduledoc File.read!("./lib/aoc/day_07.md")

  def part_one do
    data()
    |> build_tree()

    # |> calculate_dir_sizes()
    # |> traverse_tree()
  end

  # defp calculate_dir_sizes(tree) do
  #   # {files, _dirs} = Map.pop(tree, :files)
  #   # files |> Enum.map(&elem(&1, 0)) |> Enum.sum()
  # end

  # defp traverse_tree(tree) when map_size(tree) == 1 do
  #   IO.inspect(tree, label: "leaf")
  #   Map.put(tree, :size, get_size(tree[:files]))
  # end

  defp traverse_tree(tree) do
    # tree = Map.put(tree, :size, get_size(tree[:files]))

    # Map.new(tree, fn
    #   {:files, files} ->
    #     {:files, files}

    #   {:size, size} ->
    #     {:size, size}

    #   {dir, child_tree} ->
    #     # IO.inspect(dir, label: "node")
    #     {dir, traverse_tree(child_tree)}
    # end)

    ###

    my_size = tree[:size]

    sizes =
      Enum.map(tree, fn
        {dir, child_tree} when is_binary(dir) ->
          traverse_tree(child_tree)

        _other ->
          0
      end)

    # |> IO.inspect()

    # {child_sizes, new_children} = Enum.unzip(new_children_and_their_sizes)
    # IO.inspect(new_children)
    # new_tree = Map.new(new_children)

    my_total_size = Enum.sum(sizes) + my_size

    if my_total_size > 3_636_666, do: IO.inspect(my_total_size)
    # new_me = Map.put(new_tree, :size, my_total_size)

    my_total_size
  end

  def tree_size(tree) do
    (tree
     |> Enum.map(fn
       {dir, child_tree} when is_binary(dir) ->
         tree_size(child_tree)

       _other ->
         0
     end)
     |> Enum.sum()) + tree[:size]
  end

  def depth_first(tree) do
    my_size = tree[:size]

    x =
      Enum.flat_map(tree, fn
        {:size, _value} -> []
        {subdir, subtree} -> [depth_first(subtree)]
      end)
  end

  def zipper do
    ExZipper.Zipper.zipper(
      fn node -> is_map(node) and Map.has_key?(node, :dirs) end,
      fn %{dirs: dirs} -> dirs end,
      fn node, new_dirs -> %{node | dirs: new_dirs} end,
      %{name: "/", dirs: [], size: 0}
    )
  end

  # defp get_size(files), do: files |> Enum.map(&elem(&1, 0)) |> Enum.sum()

  def part_two do
    data()
  end

  defp data do
    "./data/day_07.txt"
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
  end

  defp build_tree(lines) do
    {_final_pwd, tree} = Enum.reduce(lines, {["/"], %{"/" => %{size: 0}}}, &process_line/2)
    tree["/"]
  end

  defp process_line("$ " <> command, state), do: process_command(command, state)

  defp process_line("dir " <> dirname, {pwd, tree}) do
    {pwd, add_dir(tree, pwd, dirname)}
  end

  defp process_line(size_and_filename, {pwd, tree}) do
    size = parse_file_size(size_and_filename)
    {pwd, add_file(tree, pwd, size)}
  end

  defp process_command("cd /", {_pwd, tree}), do: {["/"], tree}
  defp process_command("cd ..", {[_ | parent], tree}), do: {parent, tree}
  defp process_command("cd " <> path, {pwd, tree}), do: {[path | pwd], tree}
  defp process_command("ls", state), do: state

  defp parse_file_size(size_and_filename) do
    [size, _filename] = String.split(size_and_filename, " ")
    String.to_integer(size)
  end

  defp add_dir(tree, pwd, dirname) do
    update_in(tree, Enum.reverse([dirname | pwd]), fn
      nil -> %{size: 0}
      already_exists -> already_exists
    end)
  end

  defp add_file(tree, pwd, size) do
    update_in(tree, Enum.reverse([:size | pwd]), &(&1 + size))
  end
end

defmodule AoC.Day07Zipper do
  @moduledoc File.read!("./lib/aoc/day_07.md")

  alias ExZipper.Zipper

  def part_one do
    data()
    |> Stream.unfold(&get_all_sizes/1)
    |> Stream.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  defp get_all_sizes(tree) do
    if Zipper.end?(tree) do
      nil
    else
      {size_of_tree(tree.focus), Zipper.next(tree)}
    end
  end

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
