module ApplicationHelper

  def pass_generate(len=7) chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a - ['o', 'O', 'i', 'I']
    return Array.new(len) { chars[rand(chars.size)] }.join
  end

end
