module.exports = (robot) ->
#Descobrir o ID da sala RYVER
    robot.hear /room info/, (msg) ->
        msg.send "Room: #{msg.message.room}"
