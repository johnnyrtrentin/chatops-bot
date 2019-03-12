# Description:
#   <Integração e serviço de mensagems de build do Jenkins para o Ryver>
#
# Dependencies:
#   "N/A"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   <johnnyrtrentin>


module.exports = (robot) ->
    robot.router.post '/hubot/notify/:room', (req, res) ->

        #Enviroment for the room, usage in Hubot Steps Jenkins Plugin
        room = req.params.room
        #The message for the Room in Ryver
        message = req.body.message
        #Enviroment with status of the current build
        #STARTED/ABORTED/SUCCESS/FAILURE/NOT_BUILT/BACK_TO_NORMAL/UNSTABLE
        status = req.body.status

        stepName = req.body.stepName
        #Enviroment to say who do the current build.
        userName = req.body.userName
        #Environment variable for the current build. 
        envVars = req.body.envVars
        #Enviroment to User Name for the builds kicked off by users for others actual build cause. Example TimerTrigger, SCMChange and so on.
        buildCause = req.body.buildCause

        #console.log envVars
        console.log 'build', buildCause
        console.log 'username', userName

        robot.messageRoom room, "Build: #{envVars.JOB_NAME} + #{message}: #{status}"
        res.send 'OK'        
