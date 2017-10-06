module JukeBotService
  class Sonos
    require 'blanket'

    API_COMMANDS = %i[mute unmute pause play groupMute groupUnmute togglemute
                      state next previous favorite favorites playlist lockvolumes
                      unlockvolumes repeat shuffle crossfade pauseall resumeall
                      clearqueue linein].freeze

    def initialize(sonos_room: 'Bedroom')
      @api = create_api_call(sonos_room)
    end

    def change_room(room)
      return false unless rooms.include?(room.downcase)
      @api = create_api_call(room)
    end

    def method_missing(method, *args, &block)
      if self.class::API_COMMANDS.include?(method)
        @api.send(method).get
      else
        super
      end
    end

    # when can be 'now', 'next', or 'queue'
    def spotify_play(track:, when_to_play: 'now')
      @api.spotify.get("#{when_to_play}/#{track}")
    end

    def say(text:, volume: 50)
      @api.say.get(URI.encode("#{text}/#{volume}"))
    end

    def change_volume(volume)
      @api.volume.get(volume)
    end

    def change_group_volume(volume)
      @api.groupvolume.get(volume)
    end

    def rooms
      @api.zones.get.map { |z| z.coordinator.roomName }.map(&:downcase)
    end

    def current_track
      state.currentTrack.to_h
    end

    private

    def create_api_call(sonos_room)
      base_uri = URI.encode("#{ENV['NODE_SONOS_HTTP_API_URL']}/#{sonos_room}")
      headers = { Authorization: "Basic #{auth_token}" }
      Blanket.wrap(base_uri, headers: headers)
    end

    def auth_token
      Base64.encode64("#{ENV['USERNAME']}:#{ENV['PASSWORD']}")
    end
  end
end
