gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/complete_me'
require 'pry'

class CompleteMeTest < Minitest::Test

  def test_can_create_a_complete_me_object
    completion = CompleteMe.new
    assert_equal CompleteMe, completion.class
  end

  def test_can_create_a_trie_object_from_complete_me
    completion = CompleteMe.new
    assert_equal Trie, completion.trie.class
  end

  def test_can_insert_words_and_count_how_many_are_stored
    completion = CompleteMe.new
    completion.insert("pizza")
    assert_equal 1, completion.trie.count
    completion.insert("shithead")
    assert_equal 2, completion.trie.count
  end

  def test_can_suggest_using_inserted_word
    completion = CompleteMe.new
    completion.insert("pizza")
    assert_equal ["pizza"], completion.suggest("piz")
  end

  def test_can_use_populate_with_a_single_word_string
    completion = CompleteMe.new
    completion.populate("shithead")
    assert_equal ["shithead"], completion.suggest("shit")
  end

  def test_can_populate_with_a_string_with_multiple_words
    completion = CompleteMe.new
    string = ["shithead", "idiot", "moron", "fool", "jackass"].join("\n")
    assert_equal 0, completion.count
    completion.populate(string)
    assert_equal 5, completion.count
  end

  def test_opens_dictionary_file_and_counts_all_words
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert_equal 235886, completion.count
  end

  def test_can_suggest_five_words_using_dictionary
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    assert_equal ["pize", "pizza", "pizzeria", "pizzicato", "pizzle"],
      completion.suggest("piz")
  end

  def test_it_can_suggest_only_three_after_user_input_utilizing_select
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    completion.select("piz", "pizzicato")
    completion.select("piz", "pizzeria")
    completion.select("piz", "pizza")
    assert_equal ["pizza", "pizzeria", "pizzicato"],
      completion.suggest("piz")
  end

  def test_it_can_delete_stuff
    completion = CompleteMe.new
    dictionary = File.read("/usr/share/dict/words")
    completion.populate(dictionary)
    completion.select("piz", "pizzicato")
    completion.select("piz", "pizza")
    completion.select("piz", "pizzeria")
    completion.delete("pizza")
    assert_equal "Invalid Selection", completion.select("piz", "pizza")
  end
end
