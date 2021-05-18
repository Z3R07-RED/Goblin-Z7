<?php
/**
    * Grabar vídeo y audio obtenido del micrófono y cámara web
    * con JavaScript, seleccionando el dispositivo de grabación de audio
    * y el dispositivo de vídeo (cámara web) de una lista; 
    * usando MediaRecorder y getUserMedia
    * 
    * Extra: enviar el vídeo a un servidor con PHP y guardarlo en el disco duro
    * 
    * @author Z3R07-RED
    * @see https://github.com/Z3R07-RED
 */
# Si no hay archivos, salir inmediatamente
if (count($_FILES) <= 0 || empty($_FILES["video"])) {
    exit("No hay archivos");
}

# De dónde viene el vídeo y en dónde lo ponemos
$rutaVideoSubido = $_FILES["video"]["tmp_name"];
$nuevoNombre = uniqid() . ".webm";
$rutaDeGuardado = __DIR__ . "/" . $nuevoNombre;
// Mover el archivo subido a la ruta de guardado
move_uploaded_file($_FILES["video"]["tmp_name"], $rutaDeGuardado);
// Imprimir el nombre para que la petición lo lea
echo $nuevoNombre;
