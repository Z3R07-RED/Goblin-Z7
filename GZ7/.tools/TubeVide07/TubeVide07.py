from pytube import YouTube

urltube = open(r'logs/youtube.log', 'r')
urlss = urltube.readline()
url = urlss.rstrip()
urltube.close()

directory = open(r'tmp/directory.tmp', 'r')
ddirectory = directory.readline()
sdirectory = ddirectory.rstrip()
directory.close()

youtube = YouTube(url)
youtube.streams.get_by_itag('22').download(sdirectory)

vdone = open(r'tmp/youtube.tmp', 'w')
vdone.close()

# Coded by Z3R07-RED on Dec 21 2020
