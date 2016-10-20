gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test
  def test_can_create_a_node_object
    node = Node.new
    assert_equal Node, node.class
  end

  def test_it_knows_when_at_last_letter_of_word
    node = Node.new
    refute node.last_letter_of_word?
  end

  def test_add_child
    node = Node.new
    assert_equal node, node.add_child(node)
  end

  def test_can_indicate_when_at_final_letter
    node = Node.new
    assert node.toggle_end_of_word
  end

  def test_starts_upon_initialization_with_an_empty_hash
    node = Node.new
    assert_equal ({}), node.children
  end

  def test_letter_has_nil_value_as_default
    node = Node.new
    assert_equal nil, node.letter
  end
end
