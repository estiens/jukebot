require 'nokogiri'
require 'open-uri'

module JukeBotService
  class TuneIn
    attr_reader :last_search

    def initialize
      @base_url = 'http://opml.radiotime.com/Search.ashx'
      @last_search = []
    end

    def search(query:, limit:)
      limit = limit&.number? ? limit.to_i : 3
      response = open(URI.encode("#{@base_url}?query=#{query}"))
      xml = Nokogiri::XML(response.read)
      first_five = xml.xpath('//opml//body//outline').first(limit)
      @last_search = first_five.map { |node| parse_xml(node) }
    end

    def get_station_for(query)
      station = nil
      if query.number?
        station = @last_search[query.to_i - 1]
      elsif query.starts_with?('s')
        station = lookup_station(query)
        station.merge!({ guide_id: query }) if station
      end
      station
    end

    private

    def lookup_station(id)
      response = open(URI.encode("http://opml.radiotime.com/Browse.ashx?id=#{id}"))
      xml = Nokogiri::XML(response.read)
      station = parse_station_info(xml)
    end

    def parse_station_info(xml)
      { name: xml.xpath('//opml//head//title').text }
    end

    def parse_xml(node)
      hash = {}
      hash[:name] = node['text']
      hash[:image] = node['image']
      hash[:guide_id] = node['guide_id']
      hash[:bitrate] = node['bitrate']
      hash[:subtext] = node['subtext']
      hash
    end
  end
end
