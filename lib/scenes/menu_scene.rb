# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../mode_card'
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
    @blink_timer = 0
    create_logo
    create_mode_cards
  end

  def update
    @blink_timer += 1
    # ゆっくりとした点滅（約2秒周期）
    opacity = 0.5 + 0.5 * Math.sin(@blink_timer * 0.05)
    @subtitle.color.opacity = opacity
  end

  def handle_click(x, y)
    if @challenge_card.clicked?(x, y)
      change_scene(Constants::Scenes::PLAYING, mode: Constants::GameMode::CHALLENGE)
    elsif @endless_card.clicked?(x, y)
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
      y: 260,
      size: 20,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    add_element(@subtitle)
  end

  def create_mode_cards
    challenge_high = ScoreManager.high_score(Constants::GameMode::CHALLENGE)
    endless_high = ScoreManager.high_score(Constants::GameMode::ENDLESS)

    card_width = 500
    card_height = 85
    card_x = Constants::WINDOW_WIDTH / 2 - card_width / 2

    @challenge_card = ModeCard.new(
      x: card_x,
      y: 310,
      width: card_width,
      height: card_height,
      title: 'チャレンジモード',
      description: '30問のクイズに挑戦！全問正解を目指そう',
      high_score: challenge_high,
      accent_color: '#00b894'
    )
    @challenge_card.elements.each { |el| add_element(el) }

    @endless_card = ModeCard.new(
      x: card_x,
      y: 420,
      width: card_width,
      height: card_height,
      title: 'エンドレスモード',
      description: '3回ミスするまで続く無限チャレンジ',
      high_score: endless_high,
      accent_color: '#e94560'
    )
    @endless_card.elements.each { |el| add_element(el) }
  end
end
