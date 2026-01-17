# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../constants'
require_relative '../score_manager'
require_relative '../audio_manager'

class MenuScene < Scene
  def initialize(scene_manager)
    super
    @name = Constants::Scenes::MENU
  end

  def enter(**_params)
    AudioManager.play_bgm
    create_logo
    create_mode_buttons
  end

  def handle_click(x, y)
    if @challenge_button.clicked?(x, y)
      change_scene(Constants::Scenes::PLAYING, mode: Constants::GameMode::CHALLENGE)
    elsif @endless_button.clicked?(x, y)
      change_scene(Constants::Scenes::PLAYING, mode: Constants::GameMode::ENDLESS)
    end
  end

  private

  def create_logo
    @logo = Image.new(
      'assets/images/image.png',
      x: 50,
      y: 30,
      width: 700,
      height: 210,
      z: Constants::ZIndex::TEXT
    )
    add_element(@logo)

    @subtitle = Text.new(
      'ゲームモードを選択してください',
      x: Constants::WINDOW_WIDTH / 2 - 140,
      y: 270,
      size: 20,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@subtitle)
  end

  def create_mode_buttons
    challenge_high = ScoreManager.high_score(Constants::GameMode::CHALLENGE)
    endless_high = ScoreManager.high_score(Constants::GameMode::ENDLESS)

    @challenge_button = Button.new(
      x: Constants::WINDOW_WIDTH / 2 - 200,
      y: 320,
      width: 400,
      height: 70,
      text: 'チャレンジモード（30問）'
    )
    add_element(@challenge_button)

    @challenge_high_text = Text.new(
      "ハイスコア: #{challenge_high}",
      x: Constants::WINDOW_WIDTH / 2 - 50,
      y: 395,
      size: 16,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@challenge_high_text)

    @endless_button = Button.new(
      x: Constants::WINDOW_WIDTH / 2 - 200,
      y: 440,
      width: 400,
      height: 70,
      text: 'エンドレスモード（3ミス終了）'
    )
    add_element(@endless_button)

    @endless_high_text = Text.new(
      "ハイスコア: #{endless_high}",
      x: Constants::WINDOW_WIDTH / 2 - 50,
      y: 515,
      size: 16,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@endless_high_text)
  end
end
