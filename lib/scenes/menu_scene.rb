# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../constants'

class MenuScene < Scene
  def initialize(scene_manager)
    super
    @name = Constants::Scenes::MENU
  end

  def enter(**_params)
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
    @challenge_button = Button.new(
      x: Constants::WINDOW_WIDTH / 2 - 200,
      y: 340,
      width: 400,
      height: 80,
      text: 'チャレンジモード（30問）'
    )
    add_element(@challenge_button)

    @endless_button = Button.new(
      x: Constants::WINDOW_WIDTH / 2 - 200,
      y: 450,
      width: 400,
      height: 80,
      text: 'エンドレスモード（3ミス終了）'
    )
    add_element(@endless_button)
  end
end
