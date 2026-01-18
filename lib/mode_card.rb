# frozen_string_literal: true

require_relative 'constants'

class ModeCard
  attr_reader :x, :y, :width, :height

  BORDER_WIDTH = 3

  def initialize(x:, y:, width:, height:, title:, description:, high_score:, accent_color:)
    @x = x
    @y = y
    @width = width
    @height = height
    @title = title
    @description = description
    @high_score = high_score
    @accent_color = accent_color
    @elements = []

    create_visuals
  end

  def contains?(mouse_x, mouse_y)
    mouse_x >= @x && mouse_x <= @x + @width &&
      mouse_y >= @y && mouse_y <= @y + @height
  end

  def clicked?(mouse_x, mouse_y)
    contains?(mouse_x, mouse_y)
  end

  def remove
    @elements.each(&:remove)
  end

  def elements
    @elements
  end

  private

  def create_visuals
    create_border
    create_background
    create_texts
    create_high_score_badge
  end

  def create_border
    @border = Rectangle.new(
      x: @x,
      y: @y,
      width: @width,
      height: @height,
      color: @accent_color,
      z: Constants::ZIndex::BUTTONS
    )
    @elements << @border
  end

  def create_background
    @background = Rectangle.new(
      x: @x + BORDER_WIDTH,
      y: @y + BORDER_WIDTH,
      width: @width - (BORDER_WIDTH * 2),
      height: @height - (BORDER_WIDTH * 2),
      color: Constants::Colors::PRIMARY,
      z: Constants::ZIndex::BUTTONS + 1
    )
    @elements << @background

    @inner_gradient = Rectangle.new(
      x: @x + BORDER_WIDTH,
      y: @y + BORDER_WIDTH,
      width: @width - (BORDER_WIDTH * 2),
      height: (@height - (BORDER_WIDTH * 2)) / 2,
      color: [0.1, 0.15, 0.25, 0.5],
      z: Constants::ZIndex::BUTTONS + 2
    )
    @elements << @inner_gradient
  end

  def create_texts
    text_x = @x + 25

    @title_text = Text.new(
      @title,
      x: text_x,
      y: @y + 18,
      size: 22,
      color: Constants::Colors::TEXT_PRIMARY,
      z: Constants::ZIndex::TEXT
    )
    @elements << @title_text

    @description_text = Text.new(
      @description,
      x: text_x,
      y: @y + 50,
      size: 14,
      color: Constants::Colors::TEXT_SECONDARY,
      z: Constants::ZIndex::TEXT
    )
    @elements << @description_text
  end

  def create_high_score_badge
    text_content = "Best: #{@high_score}"
    # テキスト幅に合わせてバッジサイズを動的に計算
    text_width_estimate = text_content.length * 9
    padding = 16
    badge_width = text_width_estimate + padding
    badge_height = 26
    badge_x = @x + @width - badge_width - 15
    badge_y = @y + (@height / 2) - (badge_height / 2)

    @badge_bg = Rectangle.new(
      x: badge_x,
      y: badge_y,
      width: badge_width,
      height: badge_height,
      color: Constants::Colors::SECONDARY,
      z: Constants::ZIndex::BUTTONS + 3
    )
    @elements << @badge_bg

    text_x = badge_x + padding / 2

    @badge_text = Text.new(
      text_content,
      x: text_x,
      y: badge_y + 4,
      size: 16,
      color: @accent_color,
      z: Constants::ZIndex::TEXT
    )
    @elements << @badge_text
  end
end
