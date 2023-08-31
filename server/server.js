const express = require('express')
const http = require('http')
const socketio = require('socket.io')(http)

const app = express()
const PORT = process.env.PORT || 3000

let server = http.createServer(app)

app.use(express.json())

// let clientResponseRef
// app.get('/*', (req, res) => {
//     const pathname = url.parse(req.url).pathname

//     const obj = {
//         'pathname': pathname,
//         'method': 'get',
//         'params': req.body
//     }

//     socketio.emit('page-request', obj)

//     clientResponseRef = res
// })

// app.post('/*', (req, res) => {
//     const pathname = url.parse(req.url).pathname

//     const obj = {
//         'pathname': pathname,
//         'method': 'post',
//         'params': req.query
//     }

//     socketio.emit('page-request', obj)

//     clientResponseRef = res
// })

socketio.on('connection', (socket) => {
    console.log('Player connected')
    socket.on('playermove', (response) => {
        
    })
})

socketio.on('disconnect', (socket) => {
    console.log('Player disconnected')
})

server.listen(PORT, '0.0.0.0', () => {
    console.log('Server started and running on port ' + PORT.toString())
})

