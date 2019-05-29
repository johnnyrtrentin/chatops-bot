@echo off

call npm install
SETLOCAL
SET PATH=node_modules\.bin;node_modules\hubot\node_modules\.bin;%PATH%

rem [Hubot] Configuration
SET HUBOT_ADAPTER=
SET HUBOT_IP=
SET HUBOT_NAME=
SET HUBOT_LOG_LEVEL=

rem [Ryver] Configuration
SET HUBOT_RYVER_USERNAME=robo
SET HUBOT_RYVER_PASSWORD=96695811@B
SET HUBOT_RYVER_APP_URL=totvs.ryver.com
SET HUBOT_RYVER_JOIN_FORUMS=yes
SET HUBOT_RYVER_USE_SSL=yes

rem [Jenkins] Configuration
SET HUBOT_JENKINS_URL=
SET HUBOT_JENKINS_AUTH=

rem [SonarQube] Configuration
SET HUBOT_SONAR_URL=
SET HUBOT_SONAR_USERNAME=
SET HUBOT_SONAR_PASSWORD=

rem [Expresss] Configuration
SET EXPRESS_PORT=9999

node_modules\.bin\hubot.cmd --name "" %*