@echo off

call npm install
SETLOCAL
SET PATH=node_modules\.bin;node_modules\hubot\node_modules\.bin;%PATH%

rem [Hubot] Configuration
SET HUBOT_ADAPTER=ryver
SET HUBOT_IP=192.168.25.23
SET HUBOT_NAME="robo"
SET HUBOT_LOG_LEVEL="debug"

rem [Ryver] Configuration
SET HUBOT_RYVER_USERNAME=robo
SET HUBOT_RYVER_PASSWORD=96695811@B
SET HUBOT_RYVER_APP_URL=chatopsteste2.ryver.com
SET HUBOT_RYVER_JOIN_FORUMS=yes
SET HUBOT_RYVER_USE_SSL=yes  

rem [Git] Configuration
SET HUBOT_GITHUB_TOKEN=
SET HUBOT_GITHUB_USER=johnnyrtrentin
SET HUBOT_GITHUB_REPO=johnnyrtrentin/chatops-bot

rem [Jira] Configuration
SET HUBOT_JIRA_URL=
SET HUBOT_JIRA_USERNAME=
SET HUBOT_JIRA_PASSWORD=

rem [Jenkins] Configuration
SET HUBOT_JENKINS_URL=http://192.168.99.100:8080
SET HUBOT_JENKINS_AUTH=admin:johnny@123

rem [Redis] Configuration
rem SET REDIS_URL=redis://:password@192.168.25.6:6379

rem [Expresss] Configuration
SET EXPRESS_PORT=9999

node_modules\.bin\hubot.cmd --name "robo" %*