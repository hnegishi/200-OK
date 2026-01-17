# frozen_string_literal: true

require 'ruby2d'
require_relative 'constants'
require_relative 'scene_manager'
require_relative 'button'
require_relative 'audio_manager'

class Game
  include Ruby2D::DSL

  def initialize
    configure_window
    @scene_manager = SceneManager.new
    create_mute_button
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

  def create_mute_button
    @mute_button_size = 24
    @mute_button_x = Constants::WINDOW_WIDTH - @mute_button_size - 10
    @mute_button_y = Constants::WINDOW_HEIGHT - @mute_button_size - 10

    @mute_icon_play = Image.new(
      'assets/images/mucis-play.svg',
      x: @mute_button_x,
      y: @mute_button_y,
      width: @mute_button_size,
      height: @mute_button_size,
      z: Constants::ZIndex::OVERLAY
    )

    @mute_icon_mute = Image.new(
      'assets/images/mucis-mute.svg',
      x: @mute_button_x,
      y: @mute_button_y,
      width: @mute_button_size,
      height: @mute_button_size,
      z: Constants::ZIndex::OVERLAY
    )
    @mute_icon_mute.remove

    update_mute_icon
  end

  def update_mute_icon
    if AudioManager.muted?
      @mute_icon_play.remove
      @mute_icon_mute.add
    else
      @mute_icon_mute.remove
      @mute_icon_play.add
    end
  end

  def mute_button_clicked?(x, y)
    x >= @mute_button_x && x <= @mute_button_x + @mute_button_size &&
      y >= @mute_button_y && y <= @mute_button_y + @mute_button_size
  end

  def setup_event_handlers
    scene_manager = @scene_manager
    game = self

    on :mouse_down do |event|
      next unless event.button == :left

      if game.send(:mute_button_clicked?, event.x, event.y)
        AudioManager.toggle_mute
        game.send(:update_mute_icon)
      else
        scene_manager.handle_click(event.x, event.y)
      end
    end

    update do
      scene_manager.update
    end
  end
end
