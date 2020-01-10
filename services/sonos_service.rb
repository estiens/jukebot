module JukeBotService
  class Sonos
    require 'blanket'

    API_COMMANDS = %i[mute unmute pause play groupMute groupUnmute togglemute
                      state next previous favorite favorites playlist lockvolumes
                      unlockvolumes repeat shuffle crossfade pauseall resumeall
                      clearqueue linein leave].freeze

    attr_reader :current_room

    def initialize
      @global_api = create_api_call
      @current_room = find_first_zone
      @api = @global_api.send(@current_room)
    end

    def change_room(room)
      return false unless room_list.include?(room.downcase)
      @current_room = room
      @api = @global_api.send(@current_room)
    end

    def method_missing(method, *args, &block)
      if self.class::API_COMMANDS.include?(method)
        @api.send(method).get
      else
        super
      end
    end

    def join(room)
      return false unless room_list.include?(room.downcase)
      @api.join.get(URI.encode(room))
    end

    # when can be 'now', 'next', or 'queue'
    def spotify_play(track:, when_to_play: 'now')
      @api.spotify.get("#{when_to_play}/#{track}")
    end

    def radio_play(station_id:)
      @api.tunein.play.get(station_id)
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

    def room_list
      rooms.flatten.uniq
    end

    def rooms(api: @api)
      groups = api.zones.get.map(&:members)
      groups.map { |group| group.map { |g| g.roomName.downcase } }
    end

    def current_track
      state.currentTrack.to_h
    end

    def shuffle(enabled)
      if enabled && !shuffle?
        @api.shuffle.on.get
      elsif !enabled && shuffle?
        @api.shuffle.off.get
      end
    end

    def shuffle?
      state.playMode.shuffle
    end

    private

    def create_api_call
      base_uri = URI.encode("#{ENV['NODE_SONOS_HTTP_API_URL']}")
      headers = { Authorization: "Basic #{auth_token}" }
      Blanket.wrap(base_uri, headers: headers)
    end

    def auth_token
      Base64.strict_encode64("#{ENV['USERNAME']}:#{ENV['PASSWORD']}")
    end

    def find_first_zone
      rooms(api: @global_api).flatten.first
    end
  end
end
