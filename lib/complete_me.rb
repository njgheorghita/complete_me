require_relative 'trie'

class CompleteMe
  attr_reader :trie,
              :weighted_word_hash

  def initialize
    @trie = Trie.new
    @weighted_word_hash = Hash.new
  end

  def insert(word)
    trie.insert(word)
  end

  def count
    trie.count
  end

  def populate(str)
    trie.populate(str)
  end

  def delete(word)
    trie.delete(word)
  end

  def suggest(sub_string)
    if weighted_word_hash[sub_string].nil?
      trie.suggest(sub_string)
    else
      (all_results_by_weight(sub_string) + trie.suggest(sub_string)).uniq[0..2]
    end
  end

  def all_results_by_weight(sub_string)
    weighted_words = weighted_word_hash[sub_string].sort_by do |word, weight|
      weight
    end
    weighted_words.reverse!
    weighted_words.map! {|word| word[0]}
  end

  def select(sub_string, word)
    return "Invalid Selection" unless trie.is_word_in_dictionary?(word)
    if weighted_word_hash[sub_string].nil?
      weighted_word_hash[sub_string] = {word => 1}
    else
      weighted_word_hash_count(sub_string, word)
    end
  end

  def weighted_word_hash_count(sub_string, word)
    if weighted_word_hash[sub_string][word] = nil
      weighted_word_hash[sub_string][word] += 1
    else
      weighted_word_hash[sub_string][word] = 1
    end
  end
end
