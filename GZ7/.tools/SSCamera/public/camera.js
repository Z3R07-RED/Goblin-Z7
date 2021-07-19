// Club Secreto 07

var canvas = document.querySelector('#preview');
var context = canvas.getContext('2d');
var emitir = document.querySelector("#emitir");
var stop = document.querySelector("#stop");
const videoSelect = document.querySelector("#dispositivosDeVideo");
canvas.style.display = "none";

canvas.width = 540;
canvas.height = 360;
context.width = canvas.width;
context.height = canvas.height;

var vedeo = document.querySelector('#video');

// const socket = io(); --> importante para que funcione separado el script.

function publicarMensaje(msg) {
    document.querySelector('.status').innerText = msg;

}

function loadCamara(stream) {
    // video.srcObject = stream;
    publicarMensaje('CAMERA = ON');
    document.querySelector('.status').style.color = "green";
}

function errorCamara() {
    publicarMensaje('CAMERA = Error');
    document.querySelector('.status').style.color = "red";
}

function verVidio(video, context) {
    context.drawImage(video, 0, 0, context.width, context.height);
    socket.emit('stream', canvas.toDataURL('image/webp'));

}

// select camera
function bncamera() {
navigator.mediaDevices
    .enumerateDevices()
    .then(gotDevices)
    .then(getStream)
    .catch(handleError);

videoSelect.onchange = getStream;
}

function gotDevices(deviceInfos) {
  for (let i = 0; i !== deviceInfos.length; ++i) {
    const deviceInfo = deviceInfos[i];
    const option = document.createElement("option");
    option.value = deviceInfo.deviceId;
    if (deviceInfo.kind === "videoinput") {
      option.text = deviceInfo.label || "camera " + (videoSelect.length + 1);
      videoSelect.appendChild(option);
    } else {
      console.log("Found another kind of device: ", deviceInfo);
    }
  }
}

function getStream() {
  if (window.stream) {
    window.stream.getTracks().forEach(function (track) {
      track.stop();
    });
  }

  const constraints = {
    video: {
      deviceId: { exact: videoSelect.value },
    },
  };

  navigator.mediaDevices
    .getUserMedia(constraints)
    .then(gotStream)
    .catch(handleError);
}

function gotStream(stream) {
  window.stream = stream; // make stream available to console
  video.srcObject = stream;
  loadCamara();
}

function handleError(error) {
  console.error("Error: ", error);
  errorCamara();
}

//////
navigator.getUserMedia = (navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msgGetUserMedia);

if(navigator.getUserMedia){
    bncamera();
}

stop.addEventListener('click', () => {
    stream.getTracks().forEach(track => track.stop());
    publicarMensaje('CAMERA = OFF');
    document.querySelector('.status').style.color = "blue";
})

emitir.addEventListener('click', () => {
    var intervalo = setInterval(() => {
        verVidio(video, context);
    }, 30);

})

// Club Secreto 07
// Coded by Z3R07-RED
