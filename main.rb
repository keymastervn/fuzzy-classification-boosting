require 'pp'
require './helper'
require './model/human'
require './model/fuzzy_attribute'
require './model/output'
require './fuzzy_rule/height'
require './fuzzy_rule/weight'
require './model/fuzzy_classifier'
require './model/learner'

FULL_SET = []

File.open('training_patterns').each_line {|line|
  line.chomp!
  FULL_SET << Human.new(
      line.split("\t")[0],
      line.split("\t")[1].to_i,
      line.split("\t")[2].to_i,
      line.split("\t")[3]
    ).get_fuzzy_info
}

def boosting()
  weak_learner = []
  boost_set = {}

  # Create minimal itemset for each item
  FULL_SET.each {|item|
    boost_set[item] = Learner.new(item).action
  }

  # removed terminated learner
  boost_set.reject! {|k,learner|
    learner.terminated?
  }

  round = 0
  while boost_set.length > 0

    boost_set.each {|item,v|
      weak_learner << item.name
    }
    puts "Weak learner: #{weak_learner.join(" ")}"

    # low dp will be placed at first
    ramp = boost_set.sort_by {|k,learner| learner.get_dp}

    # lowest weak learner will be joined to the other weak learner
    item = ramp.first.first
    item_learner = ramp.first.last

    puts "Weakest learner to be combined: #{item_learner.itemset.collect(&:name)}"

    boost_set.delete(item)

    boost_set.each {|k,learner|
      learner.add_another_weak_learner(item)
    }

    boost_set.each {|k,learner|
      learner.action
    }

    # removed terminated learner
    boost_set.reject! {|k,learner|
      learner.terminated?
    }

    round += 1
    weak_learner = []
    puts "-----------8<---------- round: #{round} input_left: #{boost_set.length}"
  end
end

boosting