module.exports = (robot) ->
    room = "tnt18095+329510b3579148c6b03c19a61f80d508@conference.ryver.com"
    meta = this

    robot.respond /meta/, () ->
        coverageOfEachProject()

    sendCoverage = () ->
        robot.messageRoom room, "O porcentual de cobertura atual é de:
                               \n**#{meta.coverage}%**, de **30%** \n---"

    coverageOfEachProject = () ->
        #FND - UCL
        robot.http("http://surfistas:9999/api/measures/component?componentKey=foundation&metricKeys=uncovered_lines")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.uclFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #FND - LTC
        robot.http("http://surfistas:9999/api/measures/component?componentKey=foundation&metricKeys=lines_to_cover")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.ltcFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #NewFND - UCL
        robot.http("http://surfistas:9999/api/measures/component?componentKey=foundation-nfrw&metricKeys=uncovered_lines")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.uclNewFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #NewFND - LTC
        robot.http("http://surfistas:9999/api/measures/component?componentKey=foundation-nfrw&metricKeys=lines_to_cover")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.ltcNewFnd = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #EAI2 - UCL
        robot.http("http://surfistas:9999/api/measures/component?componentKey=eai2-progress&metricKeys=uncovered_lines")
            .get() (err, res, body) ->
                bodyReq = JSON.parse body
                meta.uclEAI2 = JSON.stringify(bodyReq.component.measures[0].value).replace(/"/g, '')
        #EAI2 - LTC
        robot.http("http://surfistas:9999/api/measures/component?componentKey=eai2-progress&metricKeys=lines_to_cover")
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