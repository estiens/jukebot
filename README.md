# jukebot
Slack bot in Ruby that can control your Sonos system through the node-sonos-http-api. [https://github.com/jishi/node-sonos-http-api]. Interacts heavily with Spotify and TuneIn.

Built on the slack-ruby-bot framework. [https://github.com/slack-ruby/slack-ruby-bot]

## INSTALLATION

### Before You Start
  1) Have a Slack Bot API Token[https://api.slack.com/bot-users]

  2) Have a Spotify app username and passwork.[https://developer.spotify.com]

  3) The computer where you run this app must be able to talk to your node-sonos-http-api. This means if you are running this app externally to your network you must have ports forwarded appropriately.

  4) Have a username and password setup on your node-sonos-http-api.

  5) Fork/Clone this repo.

### Setting Environment Variables
  1) Copy `.env.sample` to `.env`
  2) Enter values for all the variables.

  *  SLACK_API_TOKEN (api token for slack bot)
  * RSPOTIFY_TOKEN (spotify app token)
  * RSPOTIFY_PASSWORD (spotify app password)
  * USERNAME (username for sonos api)
  * PASSWORD (password for sonos api)
  * NODE_SONOS_HTTP_API_URL (url for sonos api)
  * SLACK_RUBY_BOT_ALIASES (any aliases you want jukebot to respond to)

### Run It
1) `ruby jukebot.rb`

### Run It With Docker
  1) Edit `docker-compose.yml` to set environment variables
  2) `docker-compose build --pull`
  3) `docker-compose up -d`

#### View the logs:

  `docker-compose logs -f`

#### Stop:

  `docker-compose down`

#### Upgrade:

  1) `docker-compose down`
  2) `git pull`
  3) `docker-compose build --pull`
  4) `docker-compose up -d`

### JukeBot controls your Sonos rooms
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/1o2O0L2h3M0f2w2k0h0R/Screen%20Shot%202017-10-07%20at%205.52.34%20PM.png?X-CloudApp-Visitor-Id=75963&v=b33e37de "Room Control")

### JukeBot finds music
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/012B1V3f0x1o0X0K2z1r/Screen%20Shot%202017-10-07%20at%205.48.02%20PM.png?X-CloudApp-Visitor-Id=75963&v=378eb3b3 "Music Search")

### JukeBot plays music
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/3e1N3P1d1f0m1N0d1r0I/Screen%20Shot%202017-10-07%20at%205.48.22%20PM.png?X-CloudApp-Visitor-Id=75963&v=e06e52dc "Music Playback")

### JukeBot likes the radio
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/0h2s2u0f2i202G3s3V0D/Screen%20Shot%202017-10-07%20at%205.59.57%20PM.png?X-CloudApp-Visitor-Id=75963&v=897ccbb0 "Radio Search/Playback")

### JukeBot makes it louder
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/0T0d1L1a1x2I3G0P2H2I/Screen%20Shot%202017-10-07%20at%205.51.11%20PM.png?X-CloudApp-Visitor-Id=75963&v=c1d20900 "Volume Control")

### JukeBot pauses it
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/2r2a1B461L0i3Y2U0C2b/Screen%20Shot%202017-10-07%20at%206.02.57%20PM.png?X-CloudApp-Visitor-Id=75963&v=e7331f93 "Pause Control")

### JukeBot moves it along
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/290J220A1O1n023L3I25/Screen%20Shot%202017-10-07%20at%206.10.36%20PM.png?X-CloudApp-Visitor-Id=75963&v=e92223cb "Next/Previous Control")

### JukeBot tells you what's playing
![alt text](https://d3vv6lp55qjaqc.cloudfront.net/items/2K2D0J2s0X0E3i3X3C3w/Screen%20Shot%202017-10-07%20at%206.10.17%20PM.png?X-CloudApp-Visitor-Id=75963&v=bd728b8a "Current Track")
