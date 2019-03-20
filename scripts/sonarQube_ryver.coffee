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
    server = ""
    room = ""
    font = ""

    ##Array com o login e senha do usuário
    loggin = JSON.stringify({
    login: ''
    password: ''
    })

    ##Faz a autenticação no Sonar
    robot.http("http://#{server}/api/authentication/login")
        .header('Content-Type', 'application/json')
        .post(loggin)  (err, res, body) ->
            console.log "ERRO POST: #{err}"

    ##Verifica a autenticação no Sonar
    robot.http("http://#{server}/api/authentication/validate")
        .get() (err, res, body) ->
            robot.messageRoom room, "#{body}"

    ##Verica fontes duplicadoos
    robot.http("http://#{server}/api/duplications/show?key=#{font}")
        .get() (err, res, body) ->
            console.log "Fontes duplicados #{err} \n#{body} \n #{res}"

    ##Verifica a linha do codigo informada
        robot.http("http://#{server}/api/sources/show?key=#{font}")
            .get() (err, res, body) ->
                robot.messageRoom room, "#{err} \n#{body}"

    # robot.http("http://#{server}/api/project_links/search?projectKey=JS-Teste")
    #     .get() (err, res, body) ->
    #         resource = JSON.stringify (body)
            
    #         console.log "BODY: #{resource} \n"
    #         console.log "RES: #{res} \n"
    #         console.log "ERR: #{err}"