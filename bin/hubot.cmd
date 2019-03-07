@echo off

call npm install
SETLOCAL
SET PATH=node_modules\.bin;node_modules\hubot\node_modules\.bin;%PATH%

SET HUBOT_ADAPTER=ryver
SET HUBOT_NAME="chatOps_E2E"
SET HUBOT_LOG_LEVEL="debug"
rem SET HUBOT_IP='192.168.25.13'
SET HUBOT_URL=http://192.168.25.13:9999
SET PORT=9999

SET HUBOT_RYVER_USERNAME=chatOps_E2E
SET HUBOT_RYVER_PASSWORD=96695811@B
SET HUBOT_RYVER_APP_URL=chatopsteste.ryver.com
SET HUBOT_RYVER_JOIN_FORUMS=no
SET HUBOT_RYVER_USE_SSL=yes

SET HUBOT_JENKINS_URL=http://192.168.99.100:8080
SET HUBOT_JENKINS_AUTH=admin:johnny@123

node_modules\.bin\hubot.cmd --name "chatOps_E2E" %*

rem # tolken 11c1bec7894ffe2a3e346f55242520cfb4