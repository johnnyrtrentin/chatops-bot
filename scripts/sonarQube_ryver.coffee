# Description:
#  Hubot integration with:
#  Ryver and SonarQube.
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
#  
#
# Author:
#   johnnyrtrentin

module.exports = (robot) ->
    login = process.env.HUBOT_SONAR_USER
    password = process.env.HUBOT_SONAR_PASSWORD

    sonarLogin = JSON.stringify({
    login: login
    password: password
    })

    room = ""
    font = ""

    robot.respond /sonar set server (.*)/, (msg) ->
        server = msg.match[1].replace(/http:\/\//i, '')
        msg.send "**Sonar** server set to _#{server}_"

    ##Faz a autenticação no Sonar
    robot.http("http://#{server}/api/authentication/login")
        .header('Content-Type', 'application/json')
        .post(sonarLogin)  (err, res, body) ->

    ##Verifica a autenticação no Sonar
    robot.http("http://#{server}/api/authentication/validate")
        .get() (err, res, body) ->
            robot.messageRoom room, "Autenticação: #{body}"

    # ##Verica fontes duplicadoos
    # robot.http("http://#{server}/api/duplications/show?key=#{font}")
    #     .get() (err, res, body) ->
    #         if err
    #             robot.emit 'FUDEU', err
    #             return

    #         if res.StatusCode = 200
    #             # console.log "BODY :#{body}"
    #             # robot.messageRoom room, "#{body}"

    ##BRANCHES
    robot.http("http://#{server}/api/project_branches/list?project=projeto")
        .get() (err, res, body) ->
            params = JSON.parse(body)
            robot.messageRoom room, "#{params.status}"

    # ##Verifica a linha do codigo informada
    #     robot.http("http://#{server}/api/sources/show?key=#{font}")
    #         .get() (err, res, body) ->
    #             robot.messageRoom room, "#{err} \n#{body}"

    # robot.http("http://#{server}/api/project_links/search?projectKey=JS-Teste")
    #     .get() (err, res, body) ->
    #         resource = JSON.stringify (body)
    #         console.log "BODY: #{resource} \n"
    #         console.log "RES: #{res} \n"
    #         console.log "ERR: #{err}"