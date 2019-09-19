date = new Date
currentDate = 
    "#{if date.getDate() < 10 then '0' + date.getDate() else date.getDate()}/" +
    "#{if (date.getMonth() + 1) < 10 then '0' + (date.getMonth() + 1) else (date.getMonth() + 1)}/#{date.getFullYear()}"

exports.getDate = ->
    return currentDate
