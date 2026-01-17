# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../question'
require_relative '../constants'

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
    return unless @buttons_enabled

    @choice_buttons.each_with_index do |button, index|
      next unless button.clicked?(x, y)

      process_answer(index)
      break
    end
  end

  private

  def create_ui
    create_status_display
    create_score_display
    create_progress_display
    create_choice_buttons
    create_feedback_display
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
      x: Constants::Layout::PROGRESS_X,
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
  end

  def hide_feedback
    @showing_feedback = false
    @feedback_text.remove
    @buttons_enabled = true
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
