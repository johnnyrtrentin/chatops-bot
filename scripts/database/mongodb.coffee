mongoDB = require('mongodb').MongoClient
mongoURL = ''

date = new Date
currentDate = "#{if date.getDate() < 10 then '0' + date.getDate() else date.getDate()}/" +
            "#{if (date.getMonth() + 1) < 10 then '0' + (date.getMonth() + 1) else (date.getMonth() + 1)}/#{date.getFullYear()}"

exports.insertCoverage = (json) ->
    new Promise (resolve, reject) ->
        mongoDB.connect mongoURL, (err, database) ->
            if err != null then throw err

            collection = database.db('')
            collection.collection('').insertOne json, (err, response) ->
                if err != null then throw err
                if response != [] && response.result.ok == 1 && response.ops != []
                    return resolve response
                else return reject throw new Error "Can't inset the document!"

            database.close()

exports.readCoverage = (query) ->
    new Promise (resolve, reject) ->
        mongoDB.connect mongoURL, (err, database) ->
            if err != null then throw err
            
            collection = database.db('')
            collection.collection('').find(query).toArray (err, response) ->
                if err == null && response.length <= 0
                    console.log "[#{currentDate}] - Can't found the document with query ->", query
                    return reject throw new Error 'Could not find the document!'
                else return resolve response

            database.close()

exports.deleteCoverage = (query) ->
    new Promise (resolve, reject) ->
        mongoDB.connect mongoURL, (err, database) ->
            if err != null then throw err

            collection = database.db('')
            collection.collection('').deleteOne query, (err,response) ->
                if err then throw err
                if response.result.n ==  0 && response.deletedCount == 0
                    console.log "[#{currentDate}] - Can't found the document to delete ->", query
                    return reject throw new Error "Could not find the document!"
                else
                    console.log "[#{currentDate}] - 1 Document Deleted!"
                    return resolve response

            database.close()

exports.deleteManyCoverage = (query) ->
    new Promise (resolve, reject) ->
        mongoDB.connect mongoURL, (err, database) ->
            if err != null then throw err

            collection = database.db('')
            collection.collection('').deleteMany query, (err, response) ->
                if err then throw err
                if response.result.n == 0 && response.deletedCount == 0
                    console.log "[#{currentDate}] - Can't found the documents to delete ->", query
                    return reject throw new Error "Can't delete the documents, check the query!"
                else return resolve response

            database.close()