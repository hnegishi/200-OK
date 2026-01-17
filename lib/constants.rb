# frozen_string_literal: true

module Constants
  # Window Settings
  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600
  WINDOW_TITLE = '200-OK HTTPステータスコードクイズ'
  BACKGROUND_COLOR = '#1a1a2e'

  # Colors
  module Colors
    PRIMARY = '#16213e'
    SECONDARY = '#0f3460'
    ACCENT = '#e94560'
    SUCCESS = '#00b894'
    ERROR = '#d63031'
    TEXT_PRIMARY = '#ffffff'
    TEXT_SECONDARY = '#a0a0a0'
    BUTTON_DEFAULT = '#0f3460'
    BUTTON_HOVER = '#16213e'
    BUTTON_CORRECT = '#00b894'
    BUTTON_WRONG = '#d63031'
  end

  # Layout
  module Layout
    # Status code display area
    STATUS_CODE_Y = 80
    STATUS_CODE_SIZE = 72

    # Question area
    QUESTION_Y = 180
    QUESTION_SIZE = 24

    # Button area
    BUTTON_START_Y = 280
    BUTTON_HEIGHT = 60
    BUTTON_MARGIN = 15
    BUTTON_WIDTH = 700
    BUTTON_X = 50

    # Score display
    SCORE_X = 20
    SCORE_Y = 20
    SCORE_SIZE = 20

    # Progress display
    PROGRESS_X = 600
    PROGRESS_Y = 20
  end

  # Z-Index layers
  module ZIndex
    BACKGROUND = 0
    BUTTONS = 10
    TEXT = 20
    OVERLAY = 30
    FEEDBACK = 40
  end

  # Game Settings
  module GameSettings
    MODE_CHALLENGE_QUESTIONS = 30
    MODE_ENDLESS_MAX_WRONG = 3
    CHOICES_COUNT = 4
    FEEDBACK_DISPLAY_FRAMES = 90 # 1.5 seconds at 60 FPS
  end

  # Game Modes
  module GameMode
    CHALLENGE = :challenge
    ENDLESS = :endless
  end

  # Scene Names
  module Scenes
    MENU = :menu
    PLAYING = :playing
    GAME_OVER = :game_over
  end
end
