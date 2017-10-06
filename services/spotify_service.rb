require 'rspotify'

module JukeBotService
  class Spotify
    attr_reader :last_search

    def initialize
      @last_search = nil
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
  end
end
