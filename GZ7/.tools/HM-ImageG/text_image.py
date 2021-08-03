import cv2

img = cv2.imread(r'tmp/goblin_07.jpg')

texto = "Goblin-Z7"

posicion = (50, 100)

font = cv2.FONT_HERSHEY_TRIPLEX

tamanoLetra = 2

nuncolor = 0

color_text_file = open(r'tmp/bgr_color.tmp', 'r')
for i in color_text_file:
    nuncolor += 1
    if nuncolor == 1:
        bcolor = int(i)

    if nuncolor == 2:
        gcolor = int(i)

    if nuncolor == 3:
        rcolor = int(i)

# bcolor = 71
# gcolor = 212
# rcolor = 317

colorLetra = (bcolor, gcolor, rcolor)

grosorLetra = 1

cv2.putText(img, texto, posicion, font, tamanoLetra, colorLetra, grosorLetra)

cv2.imwrite(r'tmp/goblin.jpg', img)

# Coded by Z3R07-RED
# Club Secreto 07
