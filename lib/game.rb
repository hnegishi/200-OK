# frozen_string_literal: true

require 'ruby2d'
require_relative 'constants'
require_relative 'scene_manager'

class Game
  include Ruby2D::DSL

  def initialize
    configure_window
    @scene_manager = SceneManager.new
  end

  def run
    setup_event_handlers
    @scene_manager.change_scene(Constants::Scenes::MENU)
    show
  end

  private

  def configure_window
    set(
      title: Constants::WINDOW_TITLE,
      width: Constants::WINDOW_WIDTH,
      height: Constants::WINDOW_HEIGHT,
      background: Constants::BACKGROUND_COLOR
    )
  end

  def setup_event_handlers
    scene_manager = @scene_manager

    on :mouse_down do |event|
      scene_manager.handle_click(event.x, event.y) if event.button == :left
    end

    update do
      scene_manager.update
    end
  end
end
