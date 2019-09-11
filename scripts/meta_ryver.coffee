module.exports = (robot) ->
    ryverRoom = ""
    sonarUrl = ""
    meta = this

    robot.respond /meta/, () ->
        waitCoverage()

    sendCoverage = () ->
        robot.messageRoom ryverRoom, "Current coverage percentage is:
                                    \n**#{meta.coverage}%**, of **100%** \n---"

    waitCoverage = ->
        Promise.all([reqUclFnd(), reqLtcFnd(), reqUclNewFnd(), reqLtcNewFnd(), reqLtcEai2(), reqUclEai2()]).then () ->
            calculateCoverage()
        .catch (err) ->
            console.log "Error in requests" , err

    reqUclFnd = ->
        new Promise (resolve) ->
            robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation&metricKeys=uncovered_lines")
                .get() (err, res, body) ->
                    bodyReq = JSON.parse body
                    resolve meta.uclFnd = bodyReq.component.measures[0].value
    reqLtcFnd = ->
        new Promise (resolve) ->
            robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation&metricKeys=lines_to_cover")
                .get() (err, res, body) ->
                    bodyReq = JSON.parse body
                    resolve meta.ltcFnd = bodyReq.component.measures[0].value
    reqUclNewFnd = ->
        new Promise (resolve) ->
            robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation-nfrw&metricKeys=uncovered_lines")
                .get() (err, res, body) ->
                    bodyReq = JSON.parse body
                    resolve meta.uclNewFnd = bodyReq.component.measures[0].value
    reqLtcNewFnd = ->
        new Promise (resolve) ->
            robot.http("#{sonarUrl}/api/measures/component?componentKey=foundation-nfrw&metricKeys=lines_to_cover")
                .get() (err, res, body) ->
                    bodyReq = JSON.parse body
                    resolve meta.ltcNewFnd = bodyReq.component.measures[0].value
    reqUclEai2 = ->
        new Promise (resolve) ->
            robot.http("#{sonarUrl}/api/measures/component?componentKey=eai2-progress&metricKeys=uncovered_lines")
                .get() (err, res, body) ->
                    bodyReq = JSON.parse body
                    resolve meta.uclEAI2 = bodyReq.component.measures[0].value
    reqLtcEai2 = ->
        new Promise (resolve) ->
            robot.http("#{sonarUrl}/api/measures/component?componentKey=eai2-progress&metricKeys=lines_to_cover")
                .get() (err, res, body) ->
                    bodyReq = JSON.parse body
                    resolve meta.ltcEAI2 = bodyReq.component.measures[0].value

    calculateCoverage = () ->
        meta.ltcTotal = parseInt(meta.ltcFnd) + parseInt(meta.ltcNewFnd) + parseInt(meta.ltcEAI2)
        meta.uclTotal = parseInt(meta.uclFnd) + parseInt(meta.uclNewFnd) + parseInt(meta.uclEAI2)

        meta.coverage = (((meta.ltcTotal - meta.uclTotal) / meta.ltcTotal) * 100)
        meta.coverage = meta.coverage.toFixed(2)

        sendCoverage()