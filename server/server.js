const express = require('express')
const http = require('http')

const socketio = require('socket.io')

const app = express()
const PORT = process.env.PORT || 8000

let server = http.createServer(app)

const io = socketio(server)

app.use(express.json())

const players = []

let gameStarted = false;

io.on('connection', (socket) => {

    // socket.disconnect()

    // const userID = Math.floor(Math.random() * 100000000)

    console.log('Player connected')
    socket.on('playermove', (res) => {
        console.log(res)
        io.emit('playermove', res)
    })

    socket.on('joinlobby', (res) => {
        players.push({'socket': socket, 'username': res})
        socket.emit('joinlobbyresponse', players.length)
        io.emit('userjoinedlobby', res)
    })

    socket.on('startgame', (res) => {
        console.log(socket)

        if(socket == players[0]['socket']) io.emit('hoststartgame')
    })

    socket.on('disconnect', (socket) => {
        io.emit('playerleft')
    })
})


server.listen(PORT, () => {
    console.log('Server started and running on port ' + PORT.toString())
})

