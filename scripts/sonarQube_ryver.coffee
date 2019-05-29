# Description:
#  Hubot integration with:
#  Ryver and SonarQube.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_SONAR_USERNAME - The username account of sonarQube
#   HUBOT_SONAR_PASSWORD - The password account of sonarQube
#   HUBOT_SONAR_URL - The URL of sonarQube
#
# Commands:
#   hubot sonar project coverage list <PROJECT> from <INITIAL DATE> to <END DATE>
#       • show the entire the dates and coverage for a project
#   hubot sonar authentication <PARAMS>
#       • do the authentication in sonarQube
#   hubot sonar set room <URL> 
#       • set the ryver room to the robot send the messages about SonarQube
#   hubot sonar show all the infos for project <PROJECT> with filter for <FILTERS>
#       •show the name, directory and coverage with specified filter
#   hubot sonar show entire font <FONT>
#       • show the RAW Source code
#   hubot sonar show font line <FONT> from <START> to <END>
#       • show the exact line code of the font/code
#   hubot sonar show commits info of the font <FONT> from <START> to <END>
#       • show information about commit infos in the specify line
#   hubot sonar show the duplication of the font <FONT>
#       • show the lines and fonts with duplication
#   hubot sonar show branches of the project <PROJECT>
#       • list the branches of a project
#   hubot sonar project coverage list <PROJECT> from <DATE> to <DATE>
#       • show the coverage list of the project
#  * FILTERS
        # BRC - Sub-projects
        # DIR - Directories
        # FIL - Files
        # TRK - Projects
        # UTS - Test Files
#
# Notes:
#  
#
# Author:
#   johnnyrtrentin

module.exports = (robot) ->
    url = process.env.HUBOT_SONAR_URL
    login = process.env.HUBOT_SONAR_USER
    password = process.env.HUBOT_SONAR_PASSWORD
    room = ''

    sonarLogin = JSON.stringify({
    login: login
    password: password
    })

    robot.respond /sonar project coverage list (.*) from (.*) to (.*)/, (msg) ->
        coverageProject = msg.match[1].trim()
        initialDate = msg.match[2].trim()
        endDate =  msg.match[3].trim()
        sonarCoverageList(coverageProject, initialDate, endDate)

    sonarCoverageList = (coverageProject, initialDate, endDate) ->
        robot.http("http://#{url}/api/measures/search_history?metrics=coverage&component=#{coverageProject}&from=#{initialDate}&to=#{endDate}")
            .get() (err, res, body) ->
                bodyReq = JSON.parse(body)
                date = JSON.stringify(bodyReq.measures[0].history[0].date).replace(/"/g,'')
                value = JSON.stringify(bodyReq.measures[0].history[0].value).replace(/"/g,'')

                if err == null
                    error = err
                    robot.messageRoom room, error
                else
                    robot.messageRoom room, "**Date of the Coverage**: #{date} \n **Value of the Coverage**: #{value}%"

    robot.respond /sonar show all the infos for project (.*) with filter for (.*)/, (msg) ->
        projectAll = msg.match[1].trim()
        typeOfSearch = msg.match[2].trim()
        sonarCoverageAll(projectAll, typeOfSearch)

    sonarCoverageAll = (projectAll, typeOfSearch) ->
        robot.http("http://#{url}/api/measures/component_tree?component=#{projectAll}&metricKeys=coverage&additionalFields=metrics,periods&qualifiers=#{typeOfSearch}")
            .get() (err, res, body) ->
                requisition = JSON.parse(body)
                nameFont = JSON.stringify(requisition.components[4].name).replace(/"/g, '')
                dirFont = JSON.stringify(requisition.components[4].path).replace(/"/g, '')
                measureFontValue = JSON.stringify(requisition.components[4].measures[0].value).replace(/"/g, '')
                measureFontBestValue = JSON.stringify(requisition.components[4].measures[0].bestValue).replace(/"/g, '')
                robot.messageRoom room, "_Name:_ **#{nameFont}** \n
                                        _Directory:_ **#{dirFont}** \n
                                        _Coverage:_ Value: **#{measureFontValue}%** | BestValue: **#{measureFontBestValue}**"

    robot.respond /sonar set room (.*)/, (msg) ->
        room = msg.match[1].trim()
        msg.send "Room has been set for: **#{room}**"

    robot.respond /sonar authentication/, (msg) ->
        sonarAuthentication()

    sonarAuthentication = (sonarLogin) ->    
        robot.http("http://#{url}/api/authentication/login")
            .header('Content-Type', 'application/json')
            .post(sonarLogin)  (err, res, body) ->
                robot.messageRoom room, "#{res}, #{body}"
        robot.http("http://#{url}/api/authentication/validate")
            .get() (err, res, body) ->
                robot.messageRoom room, body

    robot.respond /sonar show commits info of the font (.*) from (.*) to (.*)/, (msg) ->
        font = msg.match[1].trim().replace(':/', '%3A')
        initialLine = msg.match[2].trim()
        endLine = msg.match[3].trim()
        sourceCommitInfos(font, initialLine, endLine)

    sourceCommitInfos = (font, initialLine, endLine) ->
        robot.http("http://#{url}/api/sources/scm?&key=#{font}&from=#{initialLine}&to=#{endLine}&commits_by_line=true")
            .get() (err, res, body) ->
                bodyObj = JSON.parse(body)
                result = JSON.stringify(bodyObj.scm)
                robot.messageRoom room, result

    robot.respond /sonar show the duplication of the font (.*)/, (msg) ->
        font = msg.match[1].trim().replace(':/', '%3A')
        sourceDuplicationsInfo(font)

    sourceDuplicationsInfo = (font) ->
        robot.http("http://#{url}/api/duplications/show?key=#{font}")
            .get() (err, res, body) ->
                requisition = JSON.parse(body)
                files = JSON.stringify(requisition.files[2])
                duplications = JSON.stringify(requisition.duplications[0].blocks)
                robot.messageRoom room, "#{files}\n#{duplications}"

    robot.respond /sonar show font line (.*) from (.*) to (.*)/, (msg) ->
        font = msg.match[1].trim().replace(':/', '%3A')
        initialLine = msg.match[2].trim()
        endLine = msg.match[3].trim()
        sourceCodeInfo(font, initialLine, endLine)

    sourceCodeInfo = (font, initialLine, endLine) ->
        robot.http("http://#{url}/api/sources/show?key=#{font}&from=#{initialLine}&to=#{endLine}")
            .get() (err, res, body) ->
                bodyObj = JSON.parse(body)
                line = JSON.stringify(bodyObj.sources[0][0])
                font = JSON.stringify(bodyObj.sources[0][1])
                fontFormated = JSON.stringify(bodyObj.sources)
                robot.messageRoom room, fontFormated

    robot.respond /sonar show branches of the project (.*)/, (msg) ->
        project = msg.match[1].trim()
        branchsList(project)

    branchsList = (project) ->
        robot.http("http://#{url}/api/project_branches/list?project=#{project}")
            .get() (err, res, body) ->
                req = JSON.parse(body)
                name = JSON.stringify(req.branches[0].name).replace(/"/g,'')
                isMain = JSON.stringify(req.branches[0].isMain)
                qualityGate = JSON.stringify(req.branches[0].status.qualityGateStatus).replace(/"/g, '')
                bugs = JSON.stringify(req.branches[0].status.bugs).replace(/"/g, '')
                vulnerabilities = JSON.stringify(req.branches[0].status.vulnerabilities).replace(/"/g, '')
                codeSmells = JSON.stringify(req.branches[0].status.codeSmells).replace(/"/g, '')
                analysisDate = JSON.stringify(req.branches[0].analysisDate).replace(/"/g, '')
                robot.messageRoom room, "Name of the branch: **#{name}** \n
                                        QualityGate Status: **#{qualityGate}** \n
                                        Bugs: **#{bugs}** \n
                                        Vulnerabilities: **#{vulnerabilities}** \n
                                        CodeSmells: **#{codeSmells}** \n
                                        Is main ?: **#{isMain}** \n
                                        Analyse Date: **#{analysisDate}**"

    robot.respond /sonar show entire font (.*)/, (msg) ->
        font = msg.match[1].trim().replace(':/', '%3A')
        sourceCodeRaw(font)

    sourceCodeRaw = (font) ->
        robot.http("http://#{url}/api/sources/raw?key=#{font}")
            .get() (err, res, body) ->
                robot.messageRoom room, "The entire code of: **#{font}** \n#{body}"