import phonenumbers
from phonenumbers import timezone
from phonenumbers import geocoder, carrier


numberfile = open(r'tmp/number.tmp', 'r')
contenido = numberfile.readline()
numberfile.close()
phonenumbersfile = phonenumbers.parse(str(contenido))
valid = phonenumbers.is_valid_number(phonenumbersfile)
zones = timezone.time_zones_for_number(phonenumbersfile)
carriernames = carrier.name_for_number(phonenumbersfile, 'es')
geo = geocoder.description_for_number(phonenumbersfile, 'es')


def createfile():
    infofile = open(r'logs/info.txt', 'w')
    infofile.close()


def createinfo():
    infofile = open(r'logs/info.txt', 'a')
    infofile.write(str(phonenumbersfile)+"\n")
    infofile.write("   Time Zone: "+str(zones)+"\n")
    infofile.write("     Carrier: "+str(carriernames)+"\n")
    infofile.write("     Country: "+str(geo)+"\n")
    if valid is True:
        infofile.write("      Number: valid\n")
    else:
        infofile.write("      Number: not valid\n")
    infofile.close()


createfile()
createinfo()

# Coded by Z3R07-RED on Dec 21 2020
