import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.3
import QtLocation 5.9
import Qt.labs.platform 1.0

/**
  *
  * @file PageAccueil.qml
  *
  * @brief Définition de la page d'accueil de l'application
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * @class PageAccueil
  *
  * @brief La page d'accueil de l'application
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

Page {
    visible: true
    Connections {
        target: peripheriqueLocal
        onConnecte:
        {
            if(peripheriqueLocal.etatConnexion)
            {
               etatConnexion.text = "Etat : Connectée"
               boutonEtatConnexion.checkable = false
               bouttonConnexion.visible = false
               boutonEtatConnexion.text = "Etat : Connectée"
               boutonEtatConnexion.enabled = true
               messageConnexion.open()
            }
            else
            {
               etatConnexion.text = "Etat : Déconnectée"
            }
        }
        onDeconnecte:
        {
            peripheriqueLocal.etatConnexion=false
            etatConnexion.text = "Etat : Déconnectée"
            boutonEtatConnexion.checkable = true
            bouttonConnexion.visible = true
            boutonEtatConnexion.text = "Etat : Déconnectée"
            switchPopup.checked = false
            switchPopup.enabled = true
            textInformationTrottinetteNom.visible=false
            textInformationTrottinetteMAC.visible=false
            bouttonConnexion.visible = false
            etatConnexion.visible = false
            textIndicateurRecherche.visible=false
            boutonEtatConnexion.enabled = false
        }

        onTrottinetteTrouvee:
        {
            switchPopup.checked = false
            switchPopup.enabled = false
            switchPopup.text = "Recherche terminée"
            indicateurRechercheBluetooth.running = false
            textInformationTrottinetteNom.visible=true
            textInformationTrottinetteMAC.visible=true
            bouttonConnexion.visible = true
            etatConnexion.visible = true
            textInformationTrottinetteNom.text="Nom : " + peripheriqueLocal.getTrottinetteNom()
            textInformationTrottinetteMAC.text="MAC : " + peripheriqueLocal.getTrottinetteAdresseMac()
            etatConnexion.text="Etat : Déconnectée"
            bouttonConnexion.enabled= true
            bouttonConnexion.checkable= true
            peripheriqueLocal.etatRecherche = false
            textIndicateurRecherche.text = "Recherche terminée : Trottinette détectée"
        }
        onRecherche:
        {
            textIndicateurRecherche.visible= true
            textIndicateurRecherche.text = "Recherche en cours"
        }
        onArretRecherche:
        {
            textIndicateurRecherche.visible= false
            textInformationTrottinetteNom.visible=false
            textInformationTrottinetteMAC.visible=false
            bouttonConnexion.visible = false
            etatConnexion.visible = false
        }
    }
    Popup {
           id: popup
           x: (parent.width - width) / 2
           y: (parent.height - height) / 2
           width: Screen.desktopAvailableWidth
           height: Screen.desktopAvailableHeight / 2
           modal: true
           focus: true
           closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
           BusyIndicator{
               id: indicateurRechercheBluetooth
               anchors.top: parent.top
               anchors.right: parent.right
               running: false
           }           
           Switch {
               id:switchPopup
               text: "Rechercher Trottinette"
               anchors.top: parent.top
               anchors.left: parent.left
               onClicked:{
                   peripheriqueLocal.etatRecherche ? peripheriqueLocal.arreter() : peripheriqueLocal.rechercher();
                   peripheriqueLocal.etatRecherche ?  indicateurRechercheBluetooth.running = true :  indicateurRechercheBluetooth.running = false;
                 }
           }
           Label
           {
               id : textIndicateurRecherche
               anchors.top : indicateurRechercheBluetooth.bottom
           }
           Label
           {
               id:textInformationTrottinetteNom
               anchors.top : textIndicateurRecherche.bottom
           }
           Label
           {
               id:textInformationTrottinetteMAC
               anchors.top : textInformationTrottinetteNom.bottom
           }
           Label
           {
               id:etatConnexion
               anchors.top : textInformationTrottinetteMAC.bottom
           }
           Button
           {
               id:bouttonConnexion
               text: "Connexion"
               anchors.horizontalCenter: parent.horizontalCenter
               anchors.top: etatConnexion.bottom
               checkable: false
               visible : false
               onClicked:
               {
                   peripheriqueLocal.connecter()
               }
           }
    }

    MessageDialog {
        id:messageConnexion
        buttons: MessageDialog.Ok
        text: "La connexion avec la trottinette a été établie."
    }

    Button{
        id: boutonRecherche;
        width: Screen.desktopAvailableWidth
        height: Screen.desktopAvailableHeight / 8
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Détecter la trottinette"
        onClicked:{
            popup.open();
        }
    }
    Button{
        id: boutonEtatConnexion;
        anchors.top : boutonRecherche.bottom
        topPadding: 20
        width: Screen.desktopAvailableWidth
        height: Screen.desktopAvailableHeight/3
        anchors.horizontalCenter: parent.horizontalCenter
        text: "Etat : Déconnectée"
        icon.source: "src/icons/32x32/bluetoothon.png"
        icon.color:"transparent"
        enabled: false
    }
}
