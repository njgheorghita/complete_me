gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/trie'

class TrieTest < Minitest::Test
  def test_can_create_a_trie_object
    trie = Trie.new
    assert_equal Trie, trie.class
  end

  def test_can_insert_word_and_count_how_many_are_stored
    trie = Trie.new
    assert_equal 1, trie.insert("shithead")
  end

  def test_trie_can_check_if_arguement_is_a_string
    trie = Trie.new
    assert trie.validate?("shithead")
    refute trie.validate?([1,2,3,4,5])
  end

  def test_trie_root
    trie = Trie.new
    assert Node.new, trie.root_node
  end
end
