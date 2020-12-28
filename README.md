# Simulaattori

TIYn simulaattorin tiedostot - täällä aina uusimmat versiot.

**Jos muokkaat simulla tiedostoja, toimita muutokset tänne!**

## Alusta

* Ubuntu 20.04
* X-Plane 11 hakemistossa ~/XPlane11

## Paneeli

* Extplane-Panel https://github.com/vranki/ExtPlane-Panel

Konffi löytyy paneeli-hakemistosta, simpassa ~/.config/vranki/ExtPlane-panel-qmlui.conf

## Kustomoinnit

* simulaattori.sh -skripti, käynnistää paneelin ja X-Planen

## Maastot

* apilotx HD Scenery Mesh v4 (Suomi)
* EFJM https://forums.x-plane.org/index.php?/files/file/42996-efjm-j%C3%A4mij%C3%A4rvi/
* EFTS https://forums.x-plane.org/index.php?/files/file/20354-efts-teisko-airfield/
* OpenSceneryX objektipaketti https://www.opensceneryx.com/

Maaston järjestyksen määrittelytiedosto scenery_packs.ini

## X-Plane pluginit

* ExtPlane https://github.com/vranki/ExtPlane
* FlyWithLua NG https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/

## X-Plane koneet

### ASK-21

X-Planen aski, näillä muutoksilla:

* Rollratea korjattu pienemmäksi
* 2D-ohjaamo jossa villalanka ja ohjaamon maskaus
* Disabloitu lentojarrun ja pyöräjarrun yhteys
* Ohjaamon pystyasento viilattu simuun sopivaksi

Muutetut tiedostot gitissä

### ASW-24

Täältä löytyy: https://forums.x-plane.org/index.php?/files/file/52504-flux-glider-bundle/

Mallinnus huono, vaatii vielä työtä

## X-Plane Lua-skriptit

Kopioidaan Resources/plugins/FlyWithLua/Scripts

* asksounds.lua (ja sounds/) - Alphan ja betan mukaan muuttuva suhina
* X-Visibility.lua (muokatut parametrit) https://forums.x-plane.org/index.php?/files/file/46845-x-visibility-dynamic-haze-control/

## Tilanteet

Muista säätää järkevät säät tilanteisiin. Oletus: Tyyntä, näkyvyys 50km, 
ei termiikkiä.

* Oletus.sit - Jämin länsipuolella 1000m
