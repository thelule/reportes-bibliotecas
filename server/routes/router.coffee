process = require "../handlers/process.coffee"
module.exports = (route) ->
    route.get "/", (req, res) ->
        res.render "index", {title: "Reportes de multas - Dirección General de Bibliotecas"}
    route.get "/add", (req, res) ->
        res.render "add", {title: "add"}
    route.post "/add", process.add
    route.get "/view", process.view
    route.get "/remove/:id", process.remove