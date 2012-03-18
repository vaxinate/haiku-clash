require 'ruby_rhymes'
require 'swearjar'
require 'mongoid'

class Haiku
  include Mongoid::Document

  field :lines, :type => Array
  field :record, :type => Hash, :default => {:win => 0, :loss => 0}

  validate :proper_number_of_syllables, :only_3_lines

  def proper_number_of_syllables
    unless syllables == [5, 7, 5]
      errors[:base] = "Sorry, your syllable counts are wrong! We were expecting 5,7,5."
    end
  end

  def only_3_lines
    unless lines.length == 3 
      errors[:base] = "A haiku must have exactly 3 lines. No more, No Less."
    end
  end

  def syllables
    lines.map { |l| l.to_phrase.syllables }
  end

  def update_record!(sym)
    record[sym.to_s] += 1
    self
  end

  # def valid?
  #   lines < 4 && syllables == [5, 7, 5] 
  # end
end
