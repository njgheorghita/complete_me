require_relative 'trie'

class CompleteMe
  attr_reader :trie,
              :library_hash

  def initialize
    @trie = Trie.new
    @library_hash = Hash.new
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
    if library_hash[sub_string].nil?
      trie.suggest(sub_string)
    else
      (all_results_by_weight(sub_string) + trie.suggest(sub_string)).uniq[0..2]
    end
  end

  def all_results_by_weight(sub_string)
    weighted_words = library_hash[sub_string].sort_by do |word, weight|
      weight
    end.reverse!
    weighted_words.map! {|word| word[0]}
  end

  def select(sub_string, word)
    return "Invalid Selection" unless trie.is_word_in_dictionary?(word)
    if library_hash[sub_string].nil?
      library_hash[sub_string] = {word => 1}
    else
      library_hash_weight_count(sub_string, word)
    end
  end

  def library_hash_weight_count(sub_string, word)
    if library_hash[sub_string][word] = nil
      library_hash[sub_string][word] += 1
    else
      library_hash[sub_string][word] = 1
    end
  end

end
