# frozen_string_literal: true

require_relative 'http_data'
require_relative 'constants'

class Question
  attr_reader :correct_code, :choices, :correct_index

  def initialize
    generate_question
  end

  def check_answer(selected_index)
    selected_index == @correct_index
  end

  def correct_description
    HttpData.description(@correct_code)
  end

  def choice_description(index)
    HttpData.description(@choices[index])
  end

  def choice_code(index)
    @choices[index].to_s
  end

  private

  def generate_question
    @correct_code = HttpData.random_code
    wrong_codes = HttpData.random_codes_except(
      @correct_code,
      count: Constants::GameSettings::CHOICES_COUNT - 1
    )

    # Combine correct and wrong answers
    all_choices = [@correct_code] + wrong_codes

    # Shuffle and track correct answer position
    @choices = all_choices.shuffle
    @correct_index = @choices.index(@correct_code)
  end
end
