class JukeBot < SlackRubyBot::Bot
  help do
    title 'current room'
    desc '`current_room` - tells you current room under control'
  end

  command 'current room' do |client, data, _match|
    room = api.current_room
    response = "Current room under control is #{room}"
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'pause'
    desc '`pause` - pauses music'
  end

  command 'pause' do |client, data, _match|
    api.pause
    response = 'Paused, partner. Say resume to start it up again.'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'resume'
    desc '`resume` - resumes music'
  end

  command 'resume' do |client, data, _match|
    api.play
    response = 'Here we go!'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'mute'
    desc '`mute` - mutes music'
  end

  command 'mute' do |client, data, _match|
    api.groupMute
    response = 'muted'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'unmutes'
    desc '`unmutes` - unmutess music'
  end

  command 'unmute' do |client, data, _match|
    api.groupUnmute
    response = 'unmuted'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'rooms'
    desc '`rooms` - gives you a list of all sonos rooms and groups'
  end

  command 'rooms' do |client, data, _match|
    rooms = api.rooms
    response = "There's currently #{rooms.length} groups of speakers."
    rooms.each_with_index do |room, idx|
      response += "\nGroup #{idx + 1}: #{room.join(', ')}"
    end
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'previous'
    desc '`previous` - plays previous track'
  end

  command 'previous' do |client, data, _match|
    api.previous
    response = 'Playing it again, Sam.'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'next'
    desc '`next` - plays next track'
  end

  command 'next' do |client, data, _match|
    api.next
    response = 'Moving right along'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'lock'
    desc '`lock` - locks volumes of all rooms'
  end

  command 'lock' do |client, data, _match|
    api.lockvolumes
    response = 'Volumes Locked!'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'unlock'
    desc '`unlock` - unlocks volumes of all rooms'
  end

  command 'unlock' do |client, data, _match|
    api.unlockvolumes
    response = 'Moving right along'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'clear queue'
    desc '`clear queue` - clears the whole queue'
    long desc 'Warning: stops current music.'
  end

  command 'clear queue' do |client, data, _match|
    api.clearqueue
    response = 'Alright, queue is empty!'
    client.say(text: response, channel: data.channel)
  end

  help do
    title 'linein'
    desc '`linein` - Switches the current room/group to linein'
  end

  command 'linein' do |client, data, _match|
    api.linein
    response = 'Switching to line input Captain!'
    client.say(text: response, channel: data.channel)
  end
end
