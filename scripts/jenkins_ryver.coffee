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

        #Variables
        room = req.params.room
        status = req.body.status
        userID = req.body.userId
        message = req.body.message
        envVars = req.body.envVars
        userName = req.body.userName
        extraData = req.body.extraData

        messageHubotPlugin = "_#{message}_."
        logo = "![a](http://mirrors.jenkins.io/art/jenkins-logo/32x32/headshot.png)"

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
        \n * Build: **[#{envVars.BUILD_DISPLAY_NAME}](#{envVars.BUILD_URL})**"

        buildBackNormal = "Project **[#{envVars.JOB_NAME}](#{envVars.JOB_DISPLAY_URL})** :rain_cloud: _is back to normal!_"

        buildUnstable = "Project **[#{envVars.JOB_NAME}](#{envVars.JOB_DISPLAY_URL})** :thunder_cloud_and_rain: _is unstable!_"

        if status == "STARTED"
            robot.messageRoom room, "**#{jobInfo}** \n#{messageHubotPlugin}"
        else if status == "SUCCESS"
            robot.messageRoom room, buildSucess
        else if status == "ABORTED"
            robot.messageRoom room, "#{logo} **#{jobInfo}** \n#{buildAborted}"
        else if status == "FAILURE"
            robot.messageRoom room, buildFailure
        else if status == "BACK_TO_NORMAL"
            robot.messageRoom room, buildBackNormal
        else if status == "UNSTABLE"
            robot.messageRoom room, buildUnstable

        res.send 'OK'