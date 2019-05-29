module.exports = (robot) ->
#Find it out the ID of your ryver room
    robot.hear /room info/, (msg) ->
        msg.send "Room: #{msg.message.room}"
