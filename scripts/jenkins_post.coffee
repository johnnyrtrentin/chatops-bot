module.exports = (robot) ->
    robot.hear /abc/ , (res) ->
        res.send "ok"

    robot.respond /teste/ , (res) ->
        res.reply "ok2"
    
    robot.hear /chamada/ , (res) ->
        res.emote "ok3"

    robot.router.post '/hubot/notify/:room', (req, res) ->
        room = req.params.room
        message = req.body.message      
          
        console.log "1: #{message}"
        console.log "2: #{room}"

        robot.messageRoom room, "#{message}"
        res.send 'OK'
        res.end()