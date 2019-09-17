express = require "express"
main = require "./server/main.coffee"
router = express.Router()
app = express()
bodyParser = require "body-parser"
morgan = require "morgan"

app.use morgan "dev"
app.use bodyParser.urlencoded({extended: false})
app.use bodyParser.json()

app.set "views", __dirname+"/server/views"
app.set "view engine", "pug"

port = process.env.PORT || 3000

app.use "/", router
main(router)

app.listen port, ->
    console.log "server running at port " + port