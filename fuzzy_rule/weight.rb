require 'fuzzy-logic'
require './helper'

class Weight
  MALE = 'm'
  FEMALE = 'f'


  def self.list
    self.methods.keep_if {|meth| meth.to_s.start_with? "fuzzy"}
  end

  def self.fuzzy_light
    return FuzzyLogic::Set.new(1) { |human|
      # default output is zero
      dom = 0.0
      case human.sex
      when MALE
        left = 60
        top = 60
        right = 70
      when FEMALE
        left = 44
        top = 44
        right = 50
      end

      if human.weight <= left
        dom = 1.0
      end

      if human.weight > left && human.weight < right
        dom = 1.0 - (top - human.weight)/(top - right).to_f
      end

      dom.round(3)
    }
  end

  def self.fuzzy_medium
    return FuzzyLogic::Set.new(1) { |human|
      dom = 0.0

      case human.sex
      when MALE
        left = 60
        top = 70
        right = 80
      when FEMALE
        left = 44
        top = 50
        right = 56
      end

      if human.weight > left && human.weight < right
        dom = Helper.triangle_calculate_membership(left,top,right,human.weight)
      end

      dom.round(3)
    }
  end

  def self.fuzzy_heavy
    return FuzzyLogic::Set.new(1) { |human|
      dom = 0.0
      case human.sex
      when MALE
        left = 70
        top = 80
        right = 80
      when FEMALE
        left = 50
        top = 56
        right = 56
      end

      if human.weight >= right
        dom = 1.0
      end

      if human.weight > left && human.weight < right
        dom = 1.0 - (top - human.weight)/(top - left).to_f
      end

      dom.round(3)
    }
  end
end