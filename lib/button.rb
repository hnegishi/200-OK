# frozen_string_literal: true

require_relative 'constants'

class Button
  attr_reader :x, :y, :width, :height, :text_content
  attr_accessor :enabled, :state

  # Button states
  STATE_DEFAULT = :default
  STATE_CORRECT = :correct
  STATE_WRONG = :wrong
  STATE_DISABLED = :disabled

  def initialize(x:, y:, width:, height:, text:, z: Constants::ZIndex::BUTTONS)
    @x = x
    @y = y
    @width = width
    @height = height
    @text_content = text
    @z = z
    @enabled = true
    @state = STATE_DEFAULT
    @visible = true

    create_visuals
  end

  def contains?(mouse_x, mouse_y)
    @rectangle.contains?(mouse_x, mouse_y)
  end

  def clicked?(mouse_x, mouse_y)
    @enabled && @visible && contains?(mouse_x, mouse_y)
  end

  def text=(new_text)
    @text_content = new_text
    @text.text = new_text
  end

  def set_state(new_state)
    @state = new_state
    update_color
  end

  def show
    @visible = true
    @rectangle.add
    @text.add
  end

  def hide
    @visible = false
    @rectangle.remove
    @text.remove
  end

  def remove
    hide
  end

  private

  def create_visuals
    @rectangle = Rectangle.new(
      x: @x,
      y: @y,
      width: @width,
      height: @height,
      color: color_for_state,
      z: @z
    )

    @text = Text.new(
      @text_content,
      x: @x + 20,
      y: @y + (@height / 2) - 10,
      size: 18,
      color: Constants::Colors::TEXT_PRIMARY,
      z: @z + 1
    )
  end

  def update_color
    @rectangle.color = color_for_state
  end

  def color_for_state
    case @state
    when STATE_CORRECT
      Constants::Colors::BUTTON_CORRECT
    when STATE_WRONG
      Constants::Colors::BUTTON_WRONG
    when STATE_DISABLED
      Constants::Colors::TEXT_SECONDARY
    else
      Constants::Colors::BUTTON_DEFAULT
    end
  end
end
