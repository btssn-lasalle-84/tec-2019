import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtLocation 5.9

/**
  *
  * @file Application.qml
  *
  * @brief Définition de la fenêtre principale de l'application terminal mobile
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * @class Application
  *
  * @brief La fenêtre principale de l'application terminal mobile
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

ApplicationWindow {
    id: window
    title: qsTr("TEC BTS SN IR")
    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    Material.theme: Material.Dark
    //Material.primary: Material.BlueGrey
    Material.accent: Material.BlueGrey
    //Material.background : Material.DeepPurple
    //Material.foreground: Material.DeepPurple
    SwipeView {
        id: vuePrincipale
        interactive: false        
        currentIndex: onglets.currentIndex
        anchors.fill: parent
        PageAccueil {
            id: pageAccueil
        }
        PageCarte {
            id: pageCarte
        }
    }
    footer: TabBar {
        id: onglets
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        currentIndex: vuePrincipale.currentIndex
        TabButton {
            icon.source: "src/icons/32x32/home.png"
            icon.color:"transparent"
        }
        TabButton {
            icon.source: "src/icons/32x32/map-location.png"
            icon.color:"transparent"
        }        
    }
}
