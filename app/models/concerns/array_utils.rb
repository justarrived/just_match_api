class ArrayUtils
  def self.all_match?(first_array, second_array)
    (first_array & second_array).length == second_array.length
  end
end
