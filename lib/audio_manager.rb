# frozen_string_literal: true

require 'json'
require 'fileutils'

class AudioManager
  BGM_PATH = 'assets/audio/bgm.mp3'
  SETTINGS_DIR = 'data'
  SETTINGS_FILE = "#{SETTINGS_DIR}/audio_settings.json"

  class << self
    def play_bgm
      return unless bgm_exists?
      return if @playing

      load_settings if @muted.nil?

      @bgm ||= Music.new(BGM_PATH)
      @bgm.loop = true
      @bgm.volume = @muted ? 0 : 100
      @bgm.play
      @playing = true
    end

    def stop_bgm
      @bgm&.stop
      @playing = false
    end

    def pause_bgm
      @bgm&.pause
      @playing = false
    end

    def resume_bgm
      @bgm&.resume
      @playing = true
    end

    def playing?
      @playing || false
    end

    def bgm_exists?
      File.exist?(BGM_PATH)
    end

    def toggle_mute
      @muted = !muted?
      @bgm.volume = @muted ? 0 : 100 if @bgm
      save_settings
      @muted
    end

    def muted?
      load_settings if @muted.nil?
      @muted || false
    end

    private

    def load_settings
      return unless File.exist?(SETTINGS_FILE)

      data = JSON.parse(File.read(SETTINGS_FILE))
      @muted = data['muted'] || false
    rescue JSON::ParserError
      @muted = false
    end

    def save_settings
      FileUtils.mkdir_p(SETTINGS_DIR)
      File.write(SETTINGS_FILE, JSON.pretty_generate({ muted: @muted }))
    end
  end
end
