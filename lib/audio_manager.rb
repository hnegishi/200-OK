# frozen_string_literal: true

class AudioManager
  BGM_PATH = 'assets/audio/bgm.mp3'

  class << self
    def play_bgm
      return unless bgm_exists?
      return if @playing

      @bgm ||= Music.new(BGM_PATH)
      @bgm.loop = true
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
  end
end
