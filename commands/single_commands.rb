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

  command 'previous' do |client, data, _match|
    api.previous
    response = 'Playing it again, Sam.'
    client.say(text: response, channel: data.channel)
  end

  command 'next' do |client, data, _match|
    api.next
    response = 'Moving right along'
    client.say(text: response, channel: data.channel)
  end

  command 'lock' do |client, data, _match|
    api.lockvolumes
    response = 'Volumes Locked!'
    client.say(text: response, channel: data.channel)
  end

  command 'unlock' do |client, data, _match|
    api.unlockvolumes
    response = 'Moving right along'
    client.say(text: response, channel: data.channel)
  end

  command 'clear queue' do |client, data, _match|
    api.clearqueue
    response = 'Alright, queue is empty!'
    client.say(text: response, channel: data.channel)
  end

  command 'linein' do |client, data, _match|
    api.linein
    response = 'Switching to line input Captain!'
    client.say(text: response, channel: data.channel)
  end
end
