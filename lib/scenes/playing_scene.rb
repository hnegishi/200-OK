# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../question'
require_relative '../constants'
require_relative '../http_data'

class PlayingScene < Scene
  def initialize(scene_manager)
    super
    @name = Constants::Scenes::PLAYING
  end

  def enter(mode: Constants::GameMode::CHALLENGE)
    @mode = mode
    @score = 0
    @question_number = 0
    @wrong_count = 0
    @feedback_timer = 0
    @showing_feedback = false
    @buttons_enabled = true

    create_ui
    next_question
  end

  def update
    return unless @showing_feedback

    @feedback_timer -= 1
    return unless @feedback_timer <= 0

    hide_feedback
    check_game_over_or_continue
  end

  def handle_click(x, y)
    if @menu_button.clicked?(x, y)
      change_scene(Constants::Scenes::MENU)
      return
    end

    return unless @buttons_enabled

    @choice_buttons.each_with_index do |button, index|
      next unless button.clicked?(x, y)

      process_answer(index)
      break
    end
  end

  private

  def create_ui
    create_menu_button
    create_status_display
    create_score_display
    create_progress_display
    create_choice_buttons
    create_feedback_display
    create_explanation_display
  end

  def create_menu_button
    @menu_button = Button.new(
      x: Constants::WINDOW_WIDTH - 120,
      y: 10,
      width: 110,
      height: 35,
      text: 'メニュー'
    )
    add_element(@menu_button)
  end

  def create_status_display
    @status_code_text = Text.new(
      '',
      x: Constants::WINDOW_WIDTH / 2 - 60,
      y: Constants::Layout::STATUS_CODE_Y,
      size: Constants::Layout::STATUS_CODE_SIZE,
      color: Constants::Colors::ACCENT,
      z: Constants::ZIndex::TEXT
    )
    add_element(@status_code_text)
  end

  def create_score_display
    @score_text = Text.new(
      'スコア: 0',
      x: Constants::Layout::SCORE_X,
      y: Constants::Layout::SCORE_Y,
      size: Constants::Layout::SCORE_SIZE,
      color: Constants::Colors::TEXT_PRIMARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@score_text)
  end

  def create_progress_display
    @progress_text = Text.new(
      progress_label,
      x: Constants::WINDOW_WIDTH / 2 - 45,
      y: Constants::Layout::PROGRESS_Y,
      size: Constants::Layout::SCORE_SIZE,
      color: Constants::Colors::TEXT_PRIMARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@progress_text)
  end

  def create_choice_buttons
    @choice_buttons = []
    Constants::GameSettings::CHOICES_COUNT.times do |i|
      y_pos = Constants::Layout::BUTTON_START_Y +
              (i * (Constants::Layout::BUTTON_HEIGHT + Constants::Layout::BUTTON_MARGIN))

      button = Button.new(
        x: Constants::Layout::BUTTON_X,
        y: y_pos,
        width: Constants::Layout::BUTTON_WIDTH,
        height: Constants::Layout::BUTTON_HEIGHT,
        text: ''
      )
      @choice_buttons << button
      add_element(button)
    end
  end

  def create_feedback_display
    @feedback_text = Text.new(
      '',
      x: Constants::WINDOW_WIDTH / 2 - 50,
      y: Constants::Layout::QUESTION_Y,
      size: 32,
      color: Constants::Colors::SUCCESS,
      z: Constants::ZIndex::FEEDBACK
    )
    @feedback_text.remove # Hidden initially
    add_element(@feedback_text)
  end

  def create_explanation_display
    @explanation_texts = []
  end

  def next_question
    @question_number += 1
    @current_question = Question.new
    update_display
  end

  def update_display
    @status_code_text.text = @current_question.correct_code.to_s
    @score_text.text = "スコア: #{@score}"
    @progress_text.text = progress_label

    @choice_buttons.each_with_index do |button, index|
      description = @current_question.choice_description(index)
      button.text = description
      button.set_state(Button::STATE_DEFAULT)
      button.enabled = true
    end
  end

  def progress_label
    case @mode
    when Constants::GameMode::CHALLENGE
      "問題: #{@question_number}/#{Constants::GameSettings::MODE_CHALLENGE_QUESTIONS}"
    when Constants::GameMode::ENDLESS
      "ミス: #{@wrong_count}/#{Constants::GameSettings::MODE_ENDLESS_MAX_WRONG}"
    end
  end

  def process_answer(selected_index)
    @buttons_enabled = false
    correct = @current_question.check_answer(selected_index)

    if correct
      @score += 1
      @choice_buttons[selected_index].set_state(Button::STATE_CORRECT)
      show_feedback(true)
    else
      @wrong_count += 1
      @choice_buttons[selected_index].set_state(Button::STATE_WRONG)
      @choice_buttons[@current_question.correct_index].set_state(Button::STATE_CORRECT)
      show_feedback(false)
    end
  end

  def show_feedback(correct)
    @showing_feedback = true
    @feedback_timer = Constants::GameSettings::FEEDBACK_DISPLAY_FRAMES

    if correct
      @feedback_text.text = '正解!'
      @feedback_text.color = Constants::Colors::SUCCESS
    else
      @feedback_text.text = '不正解...'
      @feedback_text.color = Constants::Colors::ERROR
    end
    @feedback_text.add

    show_explanation
  end

  def show_explanation
    explanation = HttpData.detailed_explanation(@current_question.correct_code)
    wrapped_lines = wrap_text(explanation, Constants::Layout::EXPLANATION_MAX_WIDTH)

    wrapped_lines.each_with_index do |line, index|
      text = Text.new(
        line,
        x: Constants::Layout::BUTTON_X,
        y: Constants::Layout::EXPLANATION_Y + (index * Constants::Layout::EXPLANATION_LINE_HEIGHT),
        size: Constants::Layout::EXPLANATION_SIZE,
        color: Constants::Colors::TEXT_SECONDARY,
        z: Constants::ZIndex::FEEDBACK
      )
      @explanation_texts << text
      add_element(text)
    end
  end

  def wrap_text(text, max_width)
    # 日本語文字はフォントサイズとほぼ同じ幅を持つ
    chars_per_line = (max_width / Constants::Layout::EXPLANATION_SIZE).to_i
    lines = []
    current_line = ''

    text.each_char do |char|
      test_line = current_line + char
      if test_line.length >= chars_per_line
        lines << current_line
        current_line = char
      else
        current_line = test_line
      end
    end
    lines << current_line unless current_line.empty?
    lines
  end

  def hide_feedback
    @showing_feedback = false
    @feedback_text.remove
    hide_explanation
    @buttons_enabled = true
  end

  def hide_explanation
    @explanation_texts.each do |text|
      text.remove
      @elements.delete(text)
    end
    @explanation_texts.clear
  end

  def check_game_over_or_continue
    if game_over?
      change_scene(
        Constants::Scenes::GAME_OVER,
        score: @score,
        total: @question_number,
        mode: @mode
      )
    else
      next_question
    end
  end

  def game_over?
    case @mode
    when Constants::GameMode::CHALLENGE
      @question_number >= Constants::GameSettings::MODE_CHALLENGE_QUESTIONS
    when Constants::GameMode::ENDLESS
      @wrong_count >= Constants::GameSettings::MODE_ENDLESS_MAX_WRONG
    end
  end
end
