class PlayPlaylist < SlackRubyBot::Commands::Base
  play_regex = /play playlist (?<play>.*)/i
  match BotRegex.new(play_regex)

  help do
    title 'play playlist'
    desc '`play playlist <link>` - plays the given playlist on spotify'
  end

  def self.play_playlist(query)
    playlist = JukeBot.spotify.get_playlist(query)
    unless playlist
      return [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "Sorry, I couldn't find that playlist."
          }
        }
      ]
    end

    JukeBot.api.shuffle(true)
    JukeBot.api.spotify_play(track: playlist.uri)
    preview_image = playlist.images.first['url']

    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Now playing :musical_note:"
        }
      },
      {
        "type": "divider"
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Playlist: #{playlist.name}"
        },
        "accessory": {
          "type": "image",
          "image_url": preview_image,
          "alt_text": "Playlist thumbnail"
        }
      },
      {
        "type": "context",
        "elements": [
          {
            "type": "mrkdwn",
            "text": "*Shuffle:* On"
          }
        ]
      }
    ]
  end

  def self.call(client, data, match)
    blocks = play_playlist(match[:play])
    client.web_client.chat_postMessage(blocks: blocks, channel: data.channel)
  end
end
