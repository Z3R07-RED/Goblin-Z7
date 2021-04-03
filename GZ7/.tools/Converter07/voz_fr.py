
from gtts import gTTS


audioname = open(r'tmp/audio_name.txt', 'r')
nameaudios = audioname.readline()
name_file = nameaudios.rstrip()
audioname.close()


def voz(text_file, lang, name_file):
    with open(text_file, "r") as file:
        text = file.read()

    file = gTTS(text=text, lang=lang)
    filename = name_file
    file.save(filename)


voz("tmp/text.txt", "fr", name_file)


audiodone = open(r'tmp/audiocreated.tmp', 'w')
audiodone.close()


# Coded by Z3R07-RED on Dec 23 2020
