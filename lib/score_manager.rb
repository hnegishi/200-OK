# frozen_string_literal: true

require 'json'
require_relative 'constants'

class ScoreManager
  SCORE_FILE = 'data/highscores.json'

  class << self
    def high_score(mode)
      scores = load_scores
      scores[mode.to_s] || 0
    end

    def update_high_score(mode, score)
      scores = load_scores
      current_high = scores[mode.to_s] || 0

      if score > current_high
        scores[mode.to_s] = score
        save_scores(scores)
        true # New high score
      else
        false
      end
    end

    def new_record?(mode, score)
      score > high_score(mode)
    end

    private

    def load_scores
      return {} unless File.exist?(SCORE_FILE)

      JSON.parse(File.read(SCORE_FILE))
    rescue JSON::ParserError
      {}
    end

    def save_scores(scores)
      ensure_data_directory
      File.write(SCORE_FILE, JSON.pretty_generate(scores))
    end

    def ensure_data_directory
      dir = File.dirname(SCORE_FILE)
      Dir.mkdir(dir) unless Dir.exist?(dir)
    end
  end
end
