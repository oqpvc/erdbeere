# coding: utf-8
class EqualityTest < ActiveModel::Validator
  def validate(obj)
    if obj.send_chain(options[:a].split('.')) != obj.send_chain(options[:b].split('.'))
      obj.errors[:base] << "Mismatch between #{options[:a]} and #{options[:b]}"
    end
  end
end
