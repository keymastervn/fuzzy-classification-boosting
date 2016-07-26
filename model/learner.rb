require './model/fuzzy_classifier'
require 'pp'
class Learner
  attr_accessor :itemset, :dp, :cp, :delta, :terminated
  attr_accessor :fuzzy_classifier

  T = 5

  def initialize(itemset)
    # Remember to set forth T
    @itemset = [itemset].flatten
    @dp = 0
    @cp = 0
    @t = 1
    @delta = 0
    @terminated = false

    @fuzzy_classifier = FuzzyClassifier.new(@itemset).generate_if_then_rules

    self
  end

  def get_dp
    @dp
  end

  def add_another_weak_learner(_itemset)
    if @t > T
      @terminated = true
      return
    end

    @itemset = [@itemset, _itemset].flatten
    @t = @t + 1

    # out of paper
    @cp = 0
    #

    @fuzzy_classifier = FuzzyClassifier.new(@itemset).generate_if_then_rules

    self
  end

  def can_classified? item
    @fuzzy_classifier.reasoning(item) != nil
  end

  def assign_class(item)
    cls = @fuzzy_classifier.reasoning(item)
    item.of_class cls
  end

  def action
    self.calculate_cp.calculate_delta.update_dp
  end

  def calculate_cp
    @itemset.each {|item|
      if self.can_classified? item
        self.assign_class item
        @cp += 1
      end
    }

    @terminated = true if @itemset.length == @cp

    self
  end

  def calculate_delta
    m = @itemset.length
    classified = 0
    @itemset.each {|item|
      if !self.can_classified? item
        classified += 1
      end
    }

    epsilon = classified.to_f / m
    @delta = Math.sqrt(1 - epsilon)

    self
  end

  def update_dp
    @dp = @cp.to_f / @t

    self
  end

  def terminated?
    if @terminated
      puts "Terminated: #{self.itemset.collect(&:name)} #{self.itemset.collect(&:cls)}"
      return true
    end 
    return false
  end

end