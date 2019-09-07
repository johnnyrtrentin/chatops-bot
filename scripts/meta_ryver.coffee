module.exports = (robot) ->
    ryverRoom = ""
    sonarURL = ""
    meta = this

    robot.respond /meta/, () ->
        coverageOfEachProject()

    sendCoverage = () ->
        robot.messageRoom ryverRoom, "Current coverage percentage is:
                                    \n**#{meta.coverage}%**, of **100%** \n---"

    coverageOfEachProject = () ->
        #FND - UCL
        robot.http("http://#{sonarUrl}/api/measures/component?componentKey=foundation&metricKeys=uncovered_lines")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.uclFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #FND - LTC
        robot.http("http://#{sonarUrl}/api/measures/component?componentKey=foundation&metricKeys=lines_to_cover")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.ltcFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #NewFND - UCL
        robot.http("http://#{sonarUrl}/api/measures/component?componentKey=foundation-nfrw&metricKeys=uncovered_lines")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.uclNewFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #NewFND - LTC
        robot.http("http://#{sonarUrl}/api/measures/component?componentKey=foundation-nfrw&metricKeys=lines_to_cover")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.ltcNewFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #EAI2 - UCL
        robot.http("http://#{sonarUrl}/api/measures/component?componentKey=eai2-progress&metricKeys=uncovered_lines")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.uclEAI2 = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #EAI2 - LTC
        robot.http("http://#{sonarUrl}/api/measures/component?componentKey=eai2-progress&metricKeys=lines_to_cover")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.ltcEAI2 = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')

        calculateCoverage()

    calculateCoverage = () ->
        meta.ltcTotal = parseInt(meta.ltcFnd) + parseInt(meta.ltcNewFnd) + parseInt(meta.ltcEAI2)
        meta.uclTotal = parseInt(meta.uclFnd) + parseInt(meta.uclNewFnd) + parseInt(meta.uclEAI2)

        meta.coverage = (((meta.ltcTotal - meta.uclTotal) / meta.ltcTotal) * 100)
        meta.coverage = meta.coverage.toFixed(2)

        sendCoverage()