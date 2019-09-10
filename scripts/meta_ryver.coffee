module.exports = (robot) ->
    ryverRoom = ""
    sonarUrl = ""
    meta = this

    robot.respond /meta/, () ->
        coverageOfEachProject()

    sendCoverage = () ->
        robot.messageRoom ryverRoom, "Current coverage percentage is:
                                    \n**#{meta.coverage}%**, of **100%** \n---"

    coverageOfEachProject = () ->
        #FND - UCL
        requestOne = ->
            new Promise (resolve) ->
                robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation&metricKeys=uncovered_lines")
                    .get() (err, res, body) ->
                        bodyReq = JSON.parse body
                        resolve meta.uclFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #FND - LTC
        requestTwo = ->
            new Promise (resolve) ->
                robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation&metricKeys=lines_to_cover")
                    .get() (err, res, body) ->
                        bodyReq = JSON.parse body
                        resolve meta.ltcFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #NewFND - UCL
        requestThree = ->
            new Promise (resolve) ->
                robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation-nfrw&metricKeys=uncovered_lines")
                    .get() (err, res, body) ->
                        bodyReq = JSON.parse body
                        resolve meta.uclNewFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #NewFND - LTC
        requestFour = ->
            new Promise (resolve) ->
                robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation-nfrw&metricKeys=lines_to_cover")
                    .get() (err, res, body) ->
                        bodyReq = JSON.parse body
                        resolve meta.ltcNewFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #EAI2 - UCL
        requestFive = ->
            new Promise (resolve) ->
                robot.http("#{sonarUrl}/api/measures/component?componentKey=eai2-progress&metricKeys=uncovered_lines")
                    .get() (err, res, body) ->
                        bodyReq = JSON.parse body
                        resolve meta.uclEAI2 = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #EAI2 - LTC
        requestSix = ->
            new Promise (resolve) ->
                robot.http("#{sonarUrl}/api/measures/component?componentKey=eai2-progress&metricKeys=lines_to_cover")
                    .get() (err, res, body) ->
                        bodyReq = JSON.parse body
                        resolve meta.ltcEAI2 = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')

        Promise.all([requestOne(), requestTwo(), requestThree(), requestFour(), requestFour(), requestSix()]).then () ->
            calculateCoverage()

    calculateCoverage = () ->
        meta.ltcTotal = parseInt(meta.ltcFnd) + parseInt(meta.ltcNewFnd) + parseInt(meta.ltcEAI2)
        meta.uclTotal = parseInt(meta.uclFnd) + parseInt(meta.uclNewFnd) + parseInt(meta.uclEAI2)

        meta.coverage = (((meta.ltcTotal - meta.uclTotal) / meta.ltcTotal) * 100)
        meta.coverage = meta.coverage.toFixed(2)

        sendCoverage()