require './helper'
require './model/human'
require './model/fuzzy_attribute'
require './model/output'
require './fuzzy_rule/height'
require './fuzzy_rule/weight'

class FuzzyClassifier
  attr_accessor :rule_classify, :class_determine, :output_class, :combined_rules
  attr_accessor :itemset, :deleted_rule

  def initialize(itemset)
    @rule_classify = {
      "fuzzy_short|fuzzy_light"=>ShouldEatMore,
      "fuzzy_short|fuzzy_medium"=>ShouldDoExcercise,
      "fuzzy_short|fuzzy_heavy"=>ShouldEatLess,
      "fuzzy_average|fuzzy_light"=>ShouldDoExcercise,
      "fuzzy_average|fuzzy_medium"=>Fine,
      "fuzzy_average|fuzzy_heavy"=>ShouldEatLess,
      "fuzzy_tall|fuzzy_light"=>ShouldEatMore,
      "fuzzy_tall|fuzzy_medium"=>Fine,
      "fuzzy_tall|fuzzy_heavy"=>ShouldDoExcercise
    }

    @class_determine = @rule_classify.safe_invert

    @output_class = {
      ShouldEatLess => FuzzyAttribute.new,
      ShouldEatMore => FuzzyAttribute.new,
      ShouldDoExcercise => FuzzyAttribute.new,
      Fine => FuzzyAttribute.new
    }

    @itemset = itemset

    get_combined_rules

    self
  end

  def get_combined_rules
    r = {}

    Height.list.each {|r1|
      Weight.list.each {|r2|
        r["#{r1}|#{r2}"] = FuzzyAttribute.new
      }
    }
    @deleted_rule = []
    @combined_rules = r
  end

  def calculate_combined_rules_membership(item, applied_rule)
    dom = 1
    item.fuzzy_dom.each_key {|key|
      if applied_rule.include? key.to_s
        dom = dom * item.fuzzy_dom[key]
      end
    }
    return dom
  end

  def calculate_beta
    @combined_rules.each {|k,v|
      applied_rule = k.split("|")
      beta_rule = 0

      @itemset.each {|obj|
        dom = calculate_combined_rules_membership(obj, applied_rule)
        beta_rule = beta_rule + dom
      }
      @combined_rules[k].beta = beta_rule
    }
  end

  def calculate_certainty_factor
    @class_determine.each {|k,v|
      rj = v
      beta_arr = []
      rj.each {|rule|
        beta_arr << @combined_rules[rule].beta
      }
      beta_arr = beta_arr.sort.reverse
      if beta_arr.length == 1
        @output_class[k].set_certainty_factor(1.0)
      elsif beta_arr.length == 0
        @output_class.delete(k)
        @deleted_rule << k
        next
      elsif beta_arr.length >= 2 && beta_arr[0] == beta_arr[1] #same value
        @output_class.delete(k)
        @deleted_rule << k
        next
      else
        # Calculate CFj for the highest beta of the @output_class
        @output_class[k].set_certainty_factor(Helper.calculate_certainty_factor(beta_arr, beta_arr[0]))
      end
    }
  end

  def generate_if_then_rules
    calculate_beta
    calculate_certainty_factor

    self
  end

  def reasoning(item)
    # an instance for @output_class execution
    cls_attr = {
      ShouldEatLess => FuzzyAttribute.new,
      ShouldEatMore => FuzzyAttribute.new,
      ShouldDoExcercise => FuzzyAttribute.new,
      Fine => FuzzyAttribute.new
    }

    @deleted_rule.each {|r|
      cls_attr.delete(r)
    }

    @class_determine.each {|cls,rj|
      if @output_class[cls].nil?
        # It is violating beta rules about having more than one max value
        next
      end

      rj.each {|rules|
        applied_rule = rules.split("|")

        dom = calculate_combined_rules_membership(item, applied_rule)
        alpha = @output_class[cls].get_certainty_factor * dom
        alpha > cls_attr[cls].get_alpha ? cls_attr[cls].set_alpha(alpha) : nil
      }
    }

    deduce(cls_attr)
  end

  def deduce(cls_attr)
    # sort by alpha incrementing
    cls_attr =  cls_attr.sort_by{|k,v| v.get_alpha}
    # puts "------------------"
    # p cls_attr
    # puts "------------------"

    if cls_attr.length == 1
      return cls_attr[-1].first
    end

    if cls_attr[-2].last.get_alpha == cls_attr[-1].last.get_alpha
      # It is violating alpha rules cos there are more than one max value
      return nil
    else
      return cls_attr[-1].first
    end
  end

end