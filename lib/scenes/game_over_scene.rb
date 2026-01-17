# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../constants'
require_relative '../score_manager'

class GameOverScene < Scene
  def initialize(scene_manager)
    super
    @name = Constants::Scenes::GAME_OVER
  end

  def enter(score: 0, total: 0, mode: Constants::GameMode::CHALLENGE)
    @score = score
    @total = total
    @mode = mode
    @is_new_record = ScoreManager.update_high_score(mode, score)
    @high_score = ScoreManager.high_score(mode)

    create_results_display
    create_action_buttons
  end

  def handle_click(x, y)
    if @retry_button.clicked?(x, y)
      change_scene(Constants::Scenes::PLAYING, mode: @mode)
    elsif @menu_button.clicked?(x, y)
      change_scene(Constants::Scenes::MENU)
    end
  end

  private

  def create_results_display
    content_x = Constants::WINDOW_WIDTH / 2 - 200

    title_text = @is_new_record ? 'NEW RECORD!' : 'ゲーム終了'
    title_color = @is_new_record ? Constants::Colors::SUCCESS : Constants::Colors::ACCENT

    @title = Text.new(
      title_text,
      x: content_x,
      y: 80,
      size: 48,
      color: title_color,
      z: Constants::ZIndex::TEXT
    )
    add_element(@title)

    @score_label = Text.new(
      "最終スコア: #{@score}/#{@total}",
      x: content_x,
      y: 160,
      size: 32,
      color: Constants::Colors::TEXT_PRIMARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@score_label)

    @high_score_label = Text.new(
      "ハイスコア: #{@high_score}",
      x: content_x,
      y: 210,
      size: 24,
      color: Constants::Colors::ACCENT,
      z: Constants::ZIndex::TEXT
    )
    add_element(@high_score_label)

    percentage = @total.positive? ? (@score.to_f / @total * 100).round(1) : 0
    @percentage_label = Text.new(
      "正答率: #{percentage}%",
      x: content_x,
      y: 260,
      size: 24,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@percentage_label)

    @message = Text.new(
      result_message(percentage),
      x: content_x,
      y: 310,
      size: 20,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@message)
  end

  def create_action_buttons
    @retry_button = Button.new(
      x: Constants::WINDOW_WIDTH / 2 - 200,
      y: 380,
      width: 400,
      height: 60,
      text: 'もう一度プレイ'
    )
    add_element(@retry_button)

    @menu_button = Button.new(
      x: Constants::WINDOW_WIDTH / 2 - 200,
      y: 460,
      width: 400,
      height: 60,
      text: 'メニューに戻る'
    )
    add_element(@menu_button)
  end

  def result_message(percentage)
    case percentage
    when 90..100 then 'すばらしい! HTTPマスターです!'
    when 70...90 then 'よくできました! もう少しで完璧です!'
    when 50...70 then 'まあまあです。もっと練習しましょう!'
    else '頑張りましょう! 復習が必要です。'
    end
  end
end
