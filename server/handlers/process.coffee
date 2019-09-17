mongoose = require "mongoose"
Schema = mongoose.Schema

schemaReport = 
    reportTitle: 
        type: String
        required: true
        trim: true
    reportOp: 
        type: String
        required: true
        trim: true
    reportUser : 
        type: String
        required: true
        trim: true
    updatedAt:
        type: Date
        default: Date.now

isDbConnected = false
dbUrl = "mongodb://localhost:27017/reportdb"
dbConnection = mongoose.createConnection dbUrl,  { useNewUrlParser: true, useUnifiedTopology: true }

dbConnection.on("error", (argument) -> 
    isDbConnected = false
    console.log 'Error en la conexión'
)
dbConnection.on("open", (argument) -> 
    isDbConnected = true
    console.log 'Éxito en la conexión'
)
checkDbConnection = () ->
    return isDbConnected

reportObject = new Schema schemaReport
Report = dbConnection.model "reports", reportObject
module.exports =
    add: (req, res, next) ->
        if checkDbConnection()
            postReport = new Report req.body
            postReport.save((err, result) -> 
                if(err)
                    obj=
                        flag: 2
                        msj: err.message
                    res.send obj
                else
                    obj=
                        flag: 1
                    res.redirect "view"
            )
        else
            obj = 
                flag: 2
                msg: 'MongoDb is not installed or not runnig'
            res.send obj
    view: (req, res, next) ->
        if checkDbConnection()
            Report.find({}, (error, result, next) ->
                if (error)
                    next error
                else
                    obj =
                        flag: 1
                        data: result
                        title: "View"
                    res.render "view", obj
            )
        else
            obj = 
                flag: 2
                msg: 'MongoDb is not installed or not runnig'
            res.send obj
    remove: (req, res, next) ->
        if checkDbConnection()
            Report.findOneAndRemove({'_id': req.params.id}, (error, result, next) ->
                if (error)
                    next error
                else
                    obj =
                        flag: 1
                        data: result
                    res.redirect "/view"
            )
        else
            obj = 
                flag: 2
                msg: 'MongoDb is not installed or not runnig'
            res.send obj