# Description:
#  Hubot Steps Plugin integration with Ryver Chat.
#  Plugin: https://github.com/jenkinsci/hubot-steps-plugin#build-notifications
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Notes:
#   Installed and configurated the "Hubot Steps Plugin"
#
# Author:
#   johnnyrtrentin

module.exports = (robot) ->
    robot.router.post '/hubot/notify/:room', (req, res) ->

        #Enviroments
        room = req.params.room
        status = req.body.status
        userID = req.body.userId
        message = req.body.message
        envVars = req.body.envVars
        userName = req.body.userName
        extraData = req.body.extraData

        messageHubotPlugin = "\n _#{message}_."

        jobInfo = "Jenkins: » _#{envVars.JOB_NAME}_ » _#{envVars.JOB_NAME}_ _#{envVars.BUILD_DISPLAY_NAME}_"
        buildSucess = "_Project_ **#{envVars.JOB_NAME}** :large_blue_circle:
        \n _**#{envVars.BUILD_DISPLAY_NAME}**_ was #{messageHubotPlugin}"
        buildAborted = "\n * Project: **#{envVars.JOB_NAME}** :white_circle: 
        \n * Build: **#{envVars.BUILD_DISPLAY_NAME}** 
        \n * URL of the project: **#{envVars.JOB_DISPLAY_URL}** 
        \n * Build URL: **#{envVars.BUILD_URL}** 
        \n * Aborted by user: **#{userName}** 
        \n * Status of the build: **#{status}.**"
        buildFailure = "\n * Project: **#{envVars.JOB_NAME}** :red_circle: 
        \n * Build: **#{envVars.BUILD_DISPLAY_NAME}** 
        \n * Build URL: #{envVars.BUILD_URL} 
        \n * Status of the build: **#{status}.**"

        if status == "STARTED"
            robot.messageRoom room, "**#{jobInfo}** #{messageHubotPlugin}"
        else if status == "SUCCESS"
            robot.messageRoom room, buildSucess
        else if status == "ABORTED"
            robot.messageRoom room, "**#{jobInfo}** #{buildAborted}"
        else if status == "FAILURE"
            robot.messageRoom room, "## #{jobInfo} #{buildFailure}"
            
        res.send 'OK'