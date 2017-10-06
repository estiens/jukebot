class JukeBot < SlackRubyBot::Bot
  command 'current room' do |client, data, _match|
    room = api.current_room
    response = "Current room under control is #{room}"
    client.say(text: response, channel: data.channel)
  end

  command 'pause' do |client, data, _match|
    api.pause
    response = 'Paused, partner. Say resume to start it up again.'
    client.say(text: response, channel: data.channel)
  end

  command 'resume' do |client, data, _match|
    api.play
    response = 'Here we go!'
    client.say(text: response, channel: data.channel)
  end

  command 'mute' do |client, data, _match|
    api.groupMute
    response = 'muted'
    client.say(text: response, channel: data.channel)
  end

  command 'unmute' do |client, data, _match|
    api.groupUnmute
    response = 'unmuted'
    client.say(text: response, channel: data.channel)
  end

  command 'rooms' do |client, data, _match|
    response = "Current rooms available for control are #{api.rooms}"
    client.say(text: response, channel: data.channel)
  end
end
