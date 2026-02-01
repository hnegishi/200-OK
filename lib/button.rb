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

  def initialize(x:, y:, width:, height:, text:, z: Constants::ZIndex::BUTTONS, align: :left)
    @x = x
    @y = y
    @width = width
    @height = height
    @text_content = text
    @z = z
    @align = align
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
    @text.x = calculate_text_x
  end

  def align=(new_align)
    @align = new_align
    @text.x = calculate_text_x
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

    # テキスト位置を計算
    text_x = calculate_text_x

    @text = Text.new(
      @text_content,
      x: text_x,
      y: @y + (@height / 2) - 10,
      size: 18,
      color: Constants::Colors::TEXT_PRIMARY,
      z: @z + 1
    )
  end

  def calculate_text_x
    case @align
    when :center
      text_width = estimate_text_width(@text_content, 18)
      @x + (@width - text_width) / 2
    else
      @x + 20
    end
  end

  def estimate_text_width(text, font_size)
    # 日本語文字はフォントサイズとほぼ同じ幅、ASCII文字は約半分
    text.chars.sum do |char|
      if char.ord > 127
        font_size
      else
        font_size * 0.6
      end
    end
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
