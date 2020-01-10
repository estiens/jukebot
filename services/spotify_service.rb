require 'rspotify'

module JukeBotService
  class Spotify
    attr_reader :last_search

    def initialize
      @last_search = []
    end

    def get_track_from_query(query)
      if query.number?
        track_from_last_search(query)
      else
        find_track(query)
      end
    end

    def track_from_last_search(query)
      song_index = query.to_i - 1
      @last_search[song_index]
    end

    def find_track(name)
      find_tracks(query: name, limit: 1).first
    end

    def find_tracks(query:, limit:)
      limit ||= 3
      RSpotify.authenticate(ENV['RSPOTIFY_TOKEN'], ENV['RSPOTIFY_PASSWORD'])
      tracks = RSpotify::Track.search(query, limit: limit, market: 'US')
      @last_search = tracks.sort_by { |track| -track.popularity }
    end

    def get_album_info(uri)
      RSpotify.authenticate(ENV['RSPOTIFY_TOKEN'], ENV['RSPOTIFY_PASSWORD'])
      uri = uri.gsub('spotify:album:', '')
      RSpotify::Album.find(uri)
    end

    def get_playlist(uri)
      if uri =~ %r[https://open\.spotify\.com/playlist/(?<id>\w+)]
        uri = Regexp.last_match[:id]
      elsif uri =~ %r[(?:spotify:user:)?spotify:playlist:(?<id>\w+)]
        uri = Regexp.last_match[:id]
      end

      RSpotify.authenticate(ENV['RSPOTIFY_TOKEN'], ENV['RSPOTIFY_PASSWORD'])
      RSpotify::Playlist.find_by_id(uri)
    end
  end
end
