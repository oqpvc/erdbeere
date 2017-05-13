# coding: utf-8

class IncludesTest < ActiveModel::Validator
  def validate(obj)
    return if obj.send_chain(options[:a].split('.')).include? obj.send_chain(options[:b].split('.'))
    obj.errors[:base] << "Mismatch between #{options[:a]} and #{options[:b]}"
  end
end
