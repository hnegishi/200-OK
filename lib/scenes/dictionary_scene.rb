# frozen_string_literal: true

require_relative '../scene'
require_relative '../button'
require_relative '../constants'
require_relative '../http_data'

class DictionaryScene < Scene
  ITEM_HEIGHT = 55
  ITEM_START_Y = 70
  SCROLL_SPEED = 30
  VISIBLE_AREA_TOP = 70
  VISIBLE_AREA_BOTTOM = Constants::WINDOW_HEIGHT - 10

  def initialize(scene_manager)
    super
    @name = Constants::Scenes::DICTIONARY
  end

  def enter(**_params)
    @scroll_offset = 0
    @all_codes = HttpData.all_codes.sort
    @list_items = []
    create_ui
  end

  def update; end

  def handle_click(x, y)
    if @back_button.clicked?(x, y)
      change_scene(Constants::Scenes::MENU)
    end
  end

  def handle_scroll(delta_y)
    max_scroll = calculate_max_scroll
    @scroll_offset += delta_y * SCROLL_SPEED
    @scroll_offset = 0 if @scroll_offset > 0
    @scroll_offset = -max_scroll if @scroll_offset < -max_scroll

    update_item_positions
  end

  private

  def create_ui
    create_header_background
    create_title
    create_back_button
    create_list
  end

  def create_header_background
    @header_bg = Rectangle.new(
      x: 0,
      y: 0,
      width: Constants::WINDOW_WIDTH,
      height: 60,
      color: Constants::BACKGROUND_COLOR,
      z: Constants::ZIndex::OVERLAY
    )
    add_element(@header_bg)
  end

  def create_title
    @title = Text.new(
      'HTTP Status Code 辞書',
      x: Constants::WINDOW_WIDTH / 2 - 130,
      y: 15,
      size: 28,
      color: Constants::Colors::ACCENT,
      z: Constants::ZIndex::OVERLAY + 1
    )
    add_element(@title)
  end

  def create_back_button
    @back_button = Button.new(
      x: 20,
      y: 12,
      width: 80,
      height: 35,
      text: '戻る',
      z: Constants::ZIndex::OVERLAY + 1
    )
    add_element(@back_button)
  end

  def create_list
    @all_codes.each_with_index do |code, index|
      create_list_item(code, index)
    end
  end

  def create_list_item(code, index)
    base_y = ITEM_START_Y + (index * ITEM_HEIGHT)
    elements = []

    # 背景
    bg_color = index.even? ? Constants::Colors::PRIMARY : Constants::Colors::SECONDARY
    bg = Rectangle.new(
      x: 20,
      y: base_y,
      width: Constants::WINDOW_WIDTH - 40,
      height: ITEM_HEIGHT - 5,
      color: bg_color,
      z: Constants::ZIndex::BUTTONS
    )
    elements << bg
    add_element(bg)

    # ステータスコード
    code_color = status_code_color(code)
    code_text = Text.new(
      code.to_s,
      x: 40,
      y: base_y + 6,
      size: 22,
      color: code_color,
      z: Constants::ZIndex::TEXT
    )
    elements << code_text
    add_element(code_text)

    # 簡潔な説明
    description = HttpData.description(code)
    desc_text = Text.new(
      description,
      x: 110,
      y: base_y + 10,
      size: 14,
      color: Constants::Colors::TEXT_PRIMARY,
      z: Constants::ZIndex::TEXT
    )
    elements << desc_text
    add_element(desc_text)

    @list_items << { code: code, index: index, base_y: base_y, elements: elements }
  end

  def update_item_positions
    @list_items.each do |item|
      new_y = item[:base_y] + @scroll_offset
      visible = new_y >= VISIBLE_AREA_TOP - ITEM_HEIGHT && new_y < VISIBLE_AREA_BOTTOM

      item[:elements].each_with_index do |el, el_index|
        if visible
          el.add
          # 各要素のY位置を更新
          case el_index
          when 0 # 背景
            el.y = new_y
          when 1 # コード
            el.y = new_y + 6
          when 2 # 説明
            el.y = new_y + 10
          end
        else
          el.remove
        end
      end
    end
  end

  def calculate_max_scroll
    total_height = @all_codes.length * ITEM_HEIGHT
    visible_height = VISIBLE_AREA_BOTTOM - VISIBLE_AREA_TOP
    [total_height - visible_height, 0].max
  end

  def status_code_color(code)
    case code
    when 100..199 then '#74b9ff' # 情報
    when 200..299 then '#00b894' # 成功
    when 300..399 then '#fdcb6e' # リダイレクト
    when 400..499 then '#e17055' # クライアントエラー
    when 500..599 then '#d63031' # サーバーエラー
    else Constants::Colors::TEXT_PRIMARY
    end
  end
end
