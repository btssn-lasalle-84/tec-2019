import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.3
import QtPositioning 5.6
import QtLocation 5.9
import Qt.labs.platform 1.0

import "./helper.js" as Helper

/**
  *
  * @file PageCarte.qml
  *
  * @brief Définition de la page de navigation (Carte et/ou Télémétrie)
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * @class PageCarte
  *
  * @brief La page de navigation (Carte et/ou Télémétrie)
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

Page {
    property variant coordonneeDestination: QtPositioning.coordinate()  // latitude/longitude
    property int estimationBatterie

    Connections {
        target: peripheriqueLocal
        onChronoUpdated:
        {
            indicateurdureeUtilisation.text = peripheriqueLocal.chrono
        }

        onTrottinetteUpdate:
        {
            indicateurRisqueDeChute.visible=true
            indicateurVitesse.text=peripheriqueLocal.vitesseTrottinette + " m/s"
            indicateurInclinaison.text=peripheriqueLocal.inclinaisonTrottinette + " °"
            indicateurBatterie.text=peripheriqueLocal.batterieTrottinette + " %"
            indicateurDistanceParcourue.text = Helper.formatDistance(peripheriqueLocal.distanceParcourueTrottinette)

            etatConnexionBluetoothCarte.source="src/icons/32x32/bluetoothon.png"
            etatBatterieTrottinetteCarte.visible=true

            if(peripheriqueLocal.batterieTrottinette <25)
            {
                etatBatterieTrottinetteCarte.source ="src/icons/32x32/battery1.png"
            }
            else if(peripheriqueLocal.batterieTrottinette >=25 && peripheriqueLocal.batterieTrottinette <50)
            {
                etatBatterieTrottinetteCarte.source ="src/icons/32x32/battery2.png"
            }
            else if(peripheriqueLocal.batterieTrottinette >=50 && peripheriqueLocal.batterieTrottinette <75)
            {
                etatBatterieTrottinetteCarte.source ="src/icons/32x32/battery3.png"
            }
            else
            {
                etatBatterieTrottinetteCarte.source ="src/icons/32x32/battery4.png"
            }

            if(totalDistance.visible == true)
            {
                estimation.visible = true
            }

            estimation.text="Estimation Batterie Restante: " + estimationBatterie


            console.log("La vitesse est de " , peripheriqueLocal.vitesseTrottinette, " m/s","L'inclinaison est de " , peripheriqueLocal.inclinaisonTrottinette , " °")
            console.log("Le pourcentage de batterie est de  " , peripheriqueLocal.batterieTrottinette , " %" , "La distance parcourue est de  " , peripheriqueLocal.distanceParcourueTrottinette , " m")
        }
        onDeconnecte:
        {
            etatBatterieTrottinetteCarte.visible=false
            indicateurRisqueDeChute.visible=false
            etatConnexionBluetoothCarte.source="src/icons/32x32/bluetoothoff.png"
            distanceTotale.visible=false
            estimation.visible=false
            indicateurVitesse.text="__" + " m/s"
            indicateurBatterie.text="__" + " %"
            indicateurInclinaison.text="__" + "°"
            indicateurDistanceParcourue.text= "__" + " m"
            messageDeconnexion.open()
        }
        onRisqueDeChuteUpdate:
        {
            console.log("Risque de chute" , peripheriqueLocal.risqueDeChute)
            if(peripheriqueLocal.risqueDeChute == "RCD")
            {
                indicateurRisqueDeChute.visible=true
                indicateurRisqueDeChute.source="src/icons/32x32/rcd.png"
            }
            else
            {
               if(peripheriqueLocal.risqueDeChute =="RCG")
               {
                   indicateurRisqueDeChute.visible=true
                   indicateurRisqueDeChute.source="src/icons/32x32/rcg.png"
               }
               else
               {
                   indicateurRisqueDeChute.visible=false
               }
            }
        }
    }

    MessageDialog {
        id:messageDeconnexion
        buttons: MessageDialog.Ok
        text: "La Trottinette a été deconnectée."
    }


    Rectangle{
        id: zoneDonnees
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: Screen.desktopAvailableWidth
        height: Screen.desktopAvailableHeight / 4

        SwipeView {
            id: swipeViewDonnees
            interactive: false
            currentIndex: ongletsDonnees.currentIndex
            anchors.fill: parent
            Page
            {
                id:pageItineraire
                width: Screen.desktopAvailableWidth
                TextField {
                    id: zoneRechercheAdresse
                    placeholderText: "Rue ou Avenue"
                    cursorVisible: false
                    height: implicitHeight
                    width: implicitWidth * 1.5
                    font.pixelSize: 24
                    anchors {
                        left:parent.left
                    }
                }

                TextField {
                    id: zoneRechercheVille
                    placeholderText: "Ville"
                    height: implicitHeight
                    width: implicitWidth * 1.5
                    font.pixelSize: 24
                    cursorVisible: false
                    anchors {
                        top: zoneRechercheAdresse.bottom
                        left:parent.left
                    }
                }

                Button {
                    id: bouttonRechercherAdresse
                    visible:true
                    text: "GO"
                    width: implicitWidth * 1.5
                    height: implicitHeight * 1.5
                    anchors {
                        right:parent.right
                        topMargin: 10
                        leftMargin: 8
                    }
                    font.bold: true
                    onClicked:
                    {
                        itineraire.reset()
                        console.log("<rechercherAdresse> GeocodeModel : " + zoneRechercheAdresse.text+","+zoneRechercheVille.text+",France")
                        if(zoneRechercheVille.text != "")
                        {
                            console.log("<rechercherAdresse> GeocodeModel : " + zoneRechercheAdresse.text+","+zoneRechercheVille.text+",France")
                            adresseRecherche.query = zoneRechercheAdresse.text+","+zoneRechercheVille.text+" ,France"
                            adresseRecherche.update()
                        }
                        distanceTotale.visible = true
                        if(peripheriqueLocal.etatConnexion == true)
                        {
                            estimation.visible = true
                        }
                    }
                }
            }
            Page{
                id:données

                Label
                {
                    id:vitesse
                    text:"Vitesse"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                Text
                {
                    id:indicateurVitesse
                    text:"__" + " m/s"
                    color: "white"
                    font.family: "Courier"
                    font.bold: true
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: vitesse.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: vitesse.horizontalCenter
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }

                Label
                {
                    id:batterie
                    text:"Batterie"
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Text
                {
                    id:indicateurBatterie
                    text:"__" + " %"
                    color:"white"
                    font.family: "Courier"
                    font.bold: true
                    anchors.top: batterie.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: batterie.horizontalCenter
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }

                Label
                {
                    id:inclinaison
                    text:"Inclinaison"
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                Text
                {
                    id:indicateurInclinaison
                    text:"__" + "°"
                    color:"white"
                    font.family: "Courier"
                    font.bold: true
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.top: inclinaison.bottom
                    anchors.topMargin: 10
                    //anchors.horizontalCenter: inclinaison.horizontalCenter
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }

                Label
                {
                    id:distanceParcourue
                    text:"Distance Parcourue"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top : indicateurVitesse.bottom
                    anchors.topMargin: 20
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                Text
                {
                    id:indicateurDistanceParcourue
                    text: "__" + " m"
                    color:"white"
                    font.family: "Courier"
                    font.bold: true
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: distanceParcourue.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: distanceParcourue.horizontalCenter
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }

                Label
                {
                    id:dureeUtilisation
                    text:"Durée Utilisation"
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.top : indicateurInclinaison.bottom
                    anchors.topMargin: 20
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }
                Text
                {
                    id:indicateurdureeUtilisation
                    text: "00:" + "00:"+"00"
                    color:"white"
                    font.family: "Courier"
                    font.bold: true
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.top: dureeUtilisation.bottom
                    anchors.topMargin: 10
                    //anchors.horizontalCenter: dureeUtilisation.horizontalCenter
                    font.pixelSize: Qt.application.font.pixelSize * 1.2
                }

                /*RowLayout
                {
                    id:ligneHaut
                    spacing:60
                    anchors.topMargin: 20
                    anchors.top:parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Screen.desktopAvailableWidth

                    ColumnLayout
                    {
                        //leftPadding: 20
                        Layout.fillWidth: true
                        Label
                        {
                            id:vitesse
                            text:"Vitesse"
                        }

                        Text
                        {
                            id:indicateurVitesse
                            anchors.horizontalCenter: vitesse.horizontalCenter
                            text:"__" + " m/s"
                            color: "white"
                            font.family: "Courier"
                            font.bold: true
                        }

                    }

                    ColumnLayout
                    {
                        id:colonneBatterie
                        Layout.fillWidth: true
                        Label
                        {
                            id:batterie
                            text:"Batterie"
                        }

                        Text
                        {
                            id:indicateurBatterie
                            anchors.horizontalCenter: batterie.horizontalCenter
                            text:"__" + " %"
                            color:"white"
                            font.family: "Courier"
                            font.bold: true
                        }
                    }

                    ColumnLayout
                    {
                        Layout.fillWidth: true
                        Label
                        {
                            id:inclinaison
                            text:"Inclinaison"
                        }
                        Text
                        {
                            id:indicateurInclinaison
                            anchors.horizontalCenter: inclinaison.horizontalCenter
                            text:"__" + "°"
                            color:"white"
                            font.family: "Courier"
                            font.bold: true
                        }

                    }
                }*/
                /*RowLayout
                {
                    id:ligneBas
                    anchors.top: ligneHaut.bottom
                    spacing:80
                    ColumnLayout
                    {
                        //topPadding: 20
                        //leftPadding: 20
                        Layout.fillWidth: true
                        Label
                        {
                            id:distanceParcourue
                            text:"Distance Parcourue"
                        }
                        Text
                        {
                            id:indicateurDistanceParcourue
                            anchors.horizontalCenter: distanceParcourue.horizontalCenter
                            text: "__" + " m"
                            color:"white"
                            font.family: "Courier"
                            font.bold: true
                        }
                    }
                    ColumnLayout
                    {
                        //topPadding: 20
                        Label
                        {
                            id:dureeUtilisation
                            anchors.top : indicateurBatterie.top
                            text:"Duree Utilisation"
                            font.family: "Courier"
                            font.bold: true
                        }

                        Text
                        {
                            id:indicateurdureeUtilisation
                            anchors.horizontalCenter: dureeUtilisation.horizontalCenter
                            text: "00:" + "00:"+"00"
                            color:"white"
                            font.family: "Courier"
                            font.bold: true
                        }
                    }
                }*/
            }
        }
        TabBar {
            id: ongletsDonnees
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            currentIndex: swipeViewDonnees.currentIndex
            TabButton {
                icon.source: "src/icons/32x32/destination.png"
                icon.color:"transparent"
                onClicked:
                {
                    pageItineraire.visible = true
                }
            }
            TabButton {
                icon.source: "src/icons/32x32/scooter.png"
                icon.color:"transparent"
                onClicked:
                {
                    if(ongletsDonnees.index != 1)
                    {
                        pageItineraire.visible = false
                    }
                }
            }
        }
    }

    Rectangle {
        id: affichageCarte
        anchors.top: zoneDonnees.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: Screen.desktopAvailableWidth
        height: Screen.desktopAvailableHeight

        Plugin {
            id: mapPlugin
            locales: "fr_FR"
            name: "osm" // OpenStreetMap
            PluginParameter { name: "osm.geocoding.host"; value: "https://nominatim.openstreetmap.org" }
        }
        Map {
            id: map
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(43.95, 4.8167)
            minimumZoomLevel: 5
            zoomLevel: 15
            MapQuickItem{
                id:indicateurPosition
                sourceItem: Rectangle {width: 24; height: 24; color: "red"; border.width: 2; border.color: "blue"; smooth: true; radius: 15;}
                coordinate: src.position.coordinate
            }
            MapItemView {
                model: itineraire
                delegate: MapRoute {
                    route: routeData
                    line.color: "blue"
                    line.width: 5
                    smooth: true
                    opacity: 0.5
                }
            }
            MapQuickItem {
                id: marqueurArrivee
                anchorPoint {
                    x: imageM.width/2
                    y: imageM.height
                }
                sourceItem: Column {
                    Image { id: imageM; source: "src/icons/iconeDestination.png" }
                }
            }
        }
        Image {
            id: etatConnexionBluetoothCarte
            source:"src/icons/32x32/bluetoothoff.png"
            anchors.top:parent.top
            anchors.right: parent.right
            sourceSize.width: 64
            sourceSize.height: 64
        }

        Image {
            id: etatBatterieTrottinetteCarte
            visible: true
            cache: false
            source:""
            anchors.top:etatConnexionBluetoothCarte.bottom
            anchors.topMargin: 5
            anchors.right: parent.right
            sourceSize.width: 64
            sourceSize.height: 64
        }
        Image {
            id: indicateurRisqueDeChute
            visible: false
            source: ""
            cache:false
            anchors.top:etatBatterieTrottinetteCarte.bottom
            anchors.topMargin: 5
            anchors.right: parent.right
            sourceSize.width: 64
            sourceSize.height: 64
        }
    }
    Text{
        id:distanceTotale
        anchors.top : affichageCarte.top
        anchors.left: affichageCarte.left
        topPadding: 20
        text:"Distance Estimée :" + totalDistance
        color:"black"
        visible: false
    }

    Text{
        id:estimation
        anchors.left : affichageCarte.left
        anchors.top : distanceTotale.bottom
        topPadding: 20
        text:"Estimation Batterie Restante: " + estimationBatterie
        color:"black"
        visible: false
    }

    Button {
            id: zoomPlus
            text: 'Zoom +'
            width: implicitWidth * 1.5
            height: implicitHeight * 1.5
            anchors {
                left: parent.left
                leftMargin: 4
                bottom: parent.bottom
                bottomMargin: 30
            }
            font.bold: true
            background: Rectangle {
                color: "lightgray"
                opacity: 0.5
                radius: 10
            }
            onClicked: map.zoomLevel++
        }

    Button {
        id: zoomMoins
        text: 'Zoom -'
        width: implicitWidth * 1.5
        height: implicitHeight * 1.5
        anchors {
            left: zoomPlus.right
            leftMargin: 10
            bottom: parent.bottom
            bottomMargin: 30
        }
        font.bold: true
        background: Rectangle {
            color: "lightgray"
            opacity: 0.5
            radius: 10
        }
        onClicked: map.zoomLevel--
    }
    Button {
        id: bouttonCentre
        text: "Centrer"
        width: implicitWidth * 1.5
        height: implicitHeight * 1.5
        anchors {
            left: zoomMoins.right
            leftMargin: 10
            bottom: parent.bottom
            bottomMargin: 30
        }
        font.bold: true
        background: Rectangle {
            color: "lightgray"
            opacity: 0.5
            radius: 10
        }
        onClicked: map.center=src.position.coordinate
    }

    // Parti Géocalisation
    property string totalDistance

    PositionSource {
        id: src
        updateInterval: 1000
        active: true
        preferredPositioningMethods: PositionSource.AllPositioningMethods
        onPositionChanged: {
            var coord = src.position.coordinate;
            console.log("Coordinate:", coord.longitude, coord.latitude);
        }
    }

    RouteModel {
        id: itineraire
        property bool actif: false
        plugin: mapPlugin
        autoUpdate: true
        query: RouteQuery {
            id: choixItineraire
            travelModes: RouteQuery.BicycleTravel
            routeOptimizations: RouteQuery.ShortestRoute
        }
        onStatusChanged: {
            console.log("RouteModel status : " + status)
            totalDistance = itineraire.count == 0 ? "" : Helper.formatDistance(itineraire.get(0).distance)

            if (totalDistance.indexOf("km")!=-1)
            {
                estimationBatterie= peripheriqueLocal.batterieTrottinette - ((100*parseInt(totalDistance))/32)
            }
            else
            {
                estimationBatterie= peripheriqueLocal.batterieTrottinette - ((100*parseInt(totalDistance))/32000)
            }

            if (status == RouteModel.Ready)
            {
                if (count>=1)
                {
                    console.log("RouteModel : " + count)
                    actif = true
                    var choix = [   "destination atteinte",
                                    "tout droit",
                                    "allez vers la droite",
                                    "tournez légèrement à droite",
                                    "tournez à droite",
                                    "virage serré à droite",
                                    "faites demi-tour à droite",
                                    "faites demi-tour à gauche",
                                    "virage serré à gauche",
                                    "tournez à gauche",
                                    "tournez légèrement à gauche",
                                    "allez vers la gauche"];

                    console.log("<Navigation> distance : " + get(0).segments[0].maneuver.distanceToNextInstruction.toFixed(1))
                    console.log("<Navigation> direction : " + get(0).segments[0].maneuver.direction)
                    console.log("<Navigation> direction : " + choix[get(0).segments[0].maneuver.direction])
                    console.log("<Navigation> Distance Totale: " + totalDistance)
                    console.log("<Navigation> Estimation pourcentage de batterie restant : " + estimationBatterie)

                }
            }
            else if (status == RouteModel.Error)
            {
                //console.log("code : " + error)
                console.log("Erreur RouteModel : " + errorString)
            }
            else if (status == RouteModel.Null)
            {
                actif = false
            }
        }
    }

    GeocodeModel {
        id: adresseRecherche
        plugin: mapPlugin
        onErrorChanged: {
            console.log("<adresseRecherche> onErrorChanged GeocodeModel : " + error + " - " + errorString)
        }
        onLocationsChanged: {
            if(error)
                console.log("<adresseRecherche> Erreur GeocodeModel : " + error + " - " + errorString)
            if (count>=1)
            {
                if(get(0).coordinate.isValid)
                {
                    console.log("<adresseRecherche> : " + get(0).address.text + "\n" + get(0).coordinate + "\n")
                    coordonneeDestination = get(0).coordinate
                    marqueurArrivee.coordinate = coordonneeDestination

                    choixItineraire.clearWaypoints()
                    choixItineraire.addWaypoint(src.position.coordinate)
                    choixItineraire.addWaypoint(coordonneeDestination)
                    map.update()
                }
            }
        }
    }

    GeocodeModel {
        id: adresseLocalisation
        plugin: mapPlugin
        onErrorChanged: {
            console.log("<adresseLocalisation> onErrorChanged GeocodeModel : " + error + " - " + errorString)
        }
        onLocationsChanged: {
            if(error)
                console.log("<adresseLocalisation> Erreur GeocodeModel : " + error + " - " + errorString)
            if (count>=1)
            {
                if(get(0).coordinate.isValid)
                {
                    console.log("<adresseLocalisation> : " + get(0).address.text + "\n" + get(0).coordinate + "\n")
                }
            }
        }
    }
}
