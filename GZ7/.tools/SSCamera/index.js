const path = require('path');
const express = require('express');
const app = express();

//Settings
app.set('port', process.env.PORT || 3000);

//static files
//console.log(path.join('PATH: ', __dirname, 'public'));
app.use(express.static(path.join(__dirname, 'public')));

//Start the server
const server = app.listen(app.get('port'), () => {
    console.log('server on port', app.get('port'));
    console.log('Local -->> http://localhost:3000');
    console.log('Waiting for connections, Ctrl + C to exit...');
});

//websockers
const socketIO = require('socket.io');
const io = socketIO(server);

io.on('connection', (socket) => {
    console.log('new connection', socket.id);

     socket.on('chat:message', (data) => {
        io.sockets.emit('chat:message', data);

    })

    socket.on('chat:typing', (data) => {
        socket.broadcast.emit('chat:typing', data);
    })

    socket.on('stream', (image) => {
        socket.broadcast.emit('stream', image);
        //io.sockets.emit('stream', image);
    })
});
