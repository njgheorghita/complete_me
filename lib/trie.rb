require_relative 'node'

class Trie
  attr_reader :root_node,
              :count

  def initialize
    @root_node = Node.new
    @count = 0
    @node_storage_arr = Array.new
    @word_storage_arr = Array.new
  end

  def insert(word, node = @root_node)
    place(make_lowercase_and_format(word))
    @count += 1
  end

  def make_lowercase_and_format(str)
    if validate?(str) == false
      puts "Invalid entry"
    end
    formatted_node_list = format_input(str.downcase)
  end

  def validate?(word)
    word.class == String ? true : false
  end

  def format_input(word)
    word.chars.map do |letter|
      Node.new(letter)
    end
  end

  def place(node_list, parent = @root_node)
    return                                          if node_list.empty?
    set_as_word(node_list, parent)                  if node_list.length == 1
    node = node_list.shift
    parent.add_child(node)                          if !child_exists?(node, parent)
    place(node_list, parent.children[node.letter])  if child_exists?(node, parent)
  end

  def set_as_word(node_list, parent = @root_node)
    if (parent.children[(node_list.last).letter]).nil?
      (node_list.last).toggle_end_of_word
    else !(parent.children[(node_list.last).letter]).nil?
      (parent.children[(node_list.last).letter]).toggle_end_of_word
    end
  end

  def child_exists?(node, parent)
    parent.children.has_key?(node.letter)
  end

  def populate(str)
    (str.gsub("\r\n", "\n").split("\n")).each do |word|
      insert(word)
    end
  end

  def browse_down_through_the_tree(node_list, parent = @root_node)
    return nil if parent.nil?
    return @node_storage_arr.last if node_list.empty?
    node = node_list.shift
    @node_storage_arr << parent.children[node.letter]
    browse_down_through_the_tree(node_list, parent.children[node.letter])
  end

  def suggest(str)
    node = browse_down_through_the_tree(make_lowercase_and_format(str))
    if node.nil?
      []
    end
    find_all_child_words(node, str)
    stored = @word_storage_arr
    @word_storage_arr = Array.new
    stored
  end

  def find_all_child_words(node, str)
    @word_storage_arr << str if node.last_letter_of_word?
    if !node.children.empty?
      node.children.each do |letter, child_node|
        new_string = str
        new_string += letter
        find_all_child_words(child_node, new_string)
      end
    end
  end

  def is_word_in_dictionary?(word)
    node = browse_down_through_the_tree(make_lowercase_and_format(word))
    if node.nil?
      return false
    end
    stored = @node_storage_arr
    @node_storage_arr = Array.new
    stored.last.last_letter_of_word? ? true : false
  end

  def delete(word)
    node = browse_down_through_the_tree(make_lowercase_and_format(word))
    if node.nil?
      return nil
    else !node.children.empty? && node.word?
      return node.toggle_end_of_word
    end
    node.toggle_end_of_word
    delete_across_the_trie(@node_storage_arr)
    @count -= 1
    @node_storage_arr = Array.new
  end

  def delete_across_the_trie(node_list)
    node = node_list.last
    return if node == @root_node || !node.children.empty?
    node = node_list.pop
    (parent_finder(node, node_list)).children.delete(node.letter) if node.children.empty?
    delete_across_the_trie(node_list)
  end

  def parent_finder(node, node_list)
    if node_list.length == 1
      node.list.last
    end
      node = node_list.last
  end
end
