# frozen_string_literal: true

require_relative 'constants'
require_relative 'scenes/menu_scene'
require_relative 'scenes/playing_scene'
require_relative 'scenes/game_over_scene'

class SceneManager
  attr_reader :current_scene

  def initialize
    @scenes = {}
    @current_scene = nil
    register_scenes
  end

  def change_scene(scene_name, **params)
    @current_scene&.exit
    @current_scene = @scenes[scene_name]
    @current_scene.enter(**params)
  end

  def update
    @current_scene&.update
  end

  def handle_click(x, y)
    @current_scene&.handle_click(x, y)
  end

  private

  def register_scenes
    @scenes[Constants::Scenes::MENU] = MenuScene.new(self)
    @scenes[Constants::Scenes::PLAYING] = PlayingScene.new(self)
    @scenes[Constants::Scenes::GAME_OVER] = GameOverScene.new(self)
  end
end
