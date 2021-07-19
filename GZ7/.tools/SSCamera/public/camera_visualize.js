// Coded by Z3R07-RED

function publicarMensaje(msg) {
    document.querySelector('.status').innerText = msg;

}

socket.on('stream', (image) => {
    let img = document.getElementById('play');
    img.src = image;
    publicarMensaje('CAMERA = ON');
})
