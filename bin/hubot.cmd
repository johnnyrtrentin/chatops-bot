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
SET HUBOT_RYVER_USERNAME=
SET HUBOT_RYVER_PASSWORD=
SET HUBOT_RYVER_APP_URL=
SET HUBOT_RYVER_JOIN_FORUMS=
SET HUBOT_RYVER_USE_SSL=

rem [Git] Configuration
SET HUBOT_GITHUB_TOKEN=
SET HUBOT_GITHUB_USER=
SET HUBOT_GITHUB_REPO=

rem [Jira] Configuration
SET HUBOT_JIRA_URL=
SET HUBOT_JIRA_USERNAME=
SET HUBOT_JIRA_PASSWORD=

rem [Jenkins] Configuration
SET HUBOT_JENKINS_URL=
SET HUBOT_JENKINS_AUTH=

rem [SonarQube] Configuration
SET HUBOT_SONAR_USERNAME=
SET HUBOT_SONAR_PASSWORD=

rem [Redis] Configuration
SET REDIS_URL=

rem [Expresss] Configuration
SET EXPRESS_PORT=

node_modules\.bin\hubot.cmd --name "robo" %*