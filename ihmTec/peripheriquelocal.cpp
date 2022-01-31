#include "peripheriquelocal.h"
#include "trottinette.h"
#include <unistd.h>
#include <QBluetoothDeviceInfo>
#include <QByteArray>
#include <QDebug>
#include <QtEndian>
#include "trame.h"
/**
  *
  * @file peripheriquelocal.cpp
  *
  * @brief Définition de la classe PeripheriqueLocal
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
 * @brief Constructeur de la classe PeripheriqueLocal
 *
 * @fn PeripheriqueLocal::PeripheriqueLocal
 *
 * @param parent QObject Adresse de l'objet Qt parent
 */
PeripheriqueLocal::PeripheriqueLocal(QObject *parent) : QObject(parent), trottinette(nullptr), discoveryAgentDevice(nullptr), socket(nullptr), etatConnexion(false), etatRecherche(false), connexionErreur(false), trottinetteDetectee(false)
{
    // Pointeur sur une classe Trame qui vas permettre de réaliser le traitement de trame
    trame = new Trame();

    connect(this,SIGNAL(trameRecue(QString )), trame , SLOT(traiterTrame(QString)));
    connect(trame,SIGNAL(risqueDeChute(QString)),SLOT(afficherRisqueDeChute(QString)));
    connect(trame, SIGNAL(donneesTrottinette(QString,QString,QString,QString)), this, SLOT(afficherDonneesTrottinette(QString , QString , QString , QString)));

    // Pointeur sur une classe ChronometreUtilisation qui vas permettre de d'acquérir la durée d'utilisation
    chronometreUtilisation = new ChronometreUtilisation();
    connect(this, SIGNAL(departChrono(int)), chronometreUtilisation, SLOT(demarrer(int)));
    connect(this, SIGNAL(arretChrono()), chronometreUtilisation, SLOT(arreter()));
    connect(chronometreUtilisation,SIGNAL(chronoUpdated(QString)),this , SLOT(afficherChrono(QString)));

    if(!terminalMobile.isValid())
     {
         qCritical("Bluetooth désactivé !");
         return;
     }
    terminalMobile.powerOn();

    nom = terminalMobile.name();
    adresseMAC = terminalMobile.address().toString();    

    //terminalMobile.setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    discoveryAgentDevice = new QBluetoothDeviceDiscoveryAgent(this);
    //  Slot  pour  la  recherche  de  périphériques  Bluetooth
    connect(discoveryAgentDevice, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)), this, SLOT(identifierTrottinette(QBluetoothDeviceInfo)));
    connect(discoveryAgentDevice, SIGNAL(finished()), this, SLOT(rechercheTerminee()));
    qDebug() << Q_FUNC_INFO << "nom" << nom << "adresseMAC" << adresseMAC;
}

/**
 * @brief Accesseur de l'attribut nom
 *
 * @fn PeripheriqueLocal::getNom
 *
 * @return QString nom du périphérique local
 */
QString PeripheriqueLocal::getNom()
{
    return nom ;
}

/**
 * @brief Accesseur de l'attribut MAC
 *
 * @fn Trottinette::getNom
 *
 * @return QString MAC du périphérique local
 */
QString PeripheriqueLocal::getAdresseMAC()
{
    return adresseMAC ;
}

/**
 * @brief Active la recherche de périphérique Bluetooth
 *
 * @fn PeripheriqueLocal::rechercher
 *
 */
void PeripheriqueLocal::rechercher()
{
    qDebug() << Q_FUNC_INFO;
    trottinetteDetectee = false ;
    etatRecherche = true;
    if(discoveryAgentDevice != NULL)
    {
        discoveryAgentDevice->start();
        if (discoveryAgentDevice->isActive())
        {
            emit recherche();
        }
    }
}

/**
 * @brief Arrête la recherche de périphérique Bluetooth
 *
 * @fn PeripheriqueLocal::arreter()
 *
 */
void PeripheriqueLocal::arreter()
{
    qDebug() << Q_FUNC_INFO ;
    etatRecherche = false ;
    discoveryAgentDevice->stop();
    emit arretRecherche();
}

/**
 * @brief Identifie la trottinette à partir du nom des appareils Bluetooth externes et lorsque la trottinette est detectée crée un objet dynamique avec les données de la trottinette
 *
 * @fn PeripheriqueLocal::identifierTrottinette
 *
 * @param info const QBluetoothDeviceInfo information sur Périphérique Bluetooth Externe
 *
 */
void PeripheriqueLocal::identifierTrottinette(const QBluetoothDeviceInfo &info)
{
    qDebug() << Q_FUNC_INFO << info.name() << info.address().toString();
    if(info.name() == "tec")
    {
        qDebug() << Q_FUNC_INFO << "Trottinette Detectée :" << info.name() << info.address().toString();
        trottinette = new Trottinette(info.name(),info.address().toString());
        trottinetteDetectee = true;
        discoveryAgentDevice->stop();
        emit trottinetteTrouvee();
    }
}

/**
 * @brief Est activée lorsque le discoveryAgentDevice a fini sa recherche et change l'état du booléen etatRecherche
 *
 * @fn PeripheriqueLocal::rechercheTerminee
 *
 */
void PeripheriqueLocal::rechercheTerminee()
{
    qDebug() << Q_FUNC_INFO;
    etatRecherche = false ;
    emit arretRecherche();
}

/**
 * @brief Accesseur de l'adresseMAC de la trottinette
 *
 * @fn PeripheriqueLocal::getTrottinetteAdresseMac
 *
 * @return QString adresse Mac de la trottinette
 */
QString PeripheriqueLocal::getTrottinetteAdresseMac()
{
    return trottinette->getAdresseMAC();
}

/**
 * @brief Accesseur du nom de la trottinette
 *
 * @fn PeripheriqueLocal::getTrottinetteNom
 *
 * @return QString nom de la trottinette
 */
QString PeripheriqueLocal::getTrottinetteNom()
{
    return trottinette->getNom();
}

/**
 * @brief Crée un socket client et connecte le socket au port série de la carte d'acquisition de la trottinette
 *
 * @fn PeripheriqueLocal::connecter
 *
 */
void PeripheriqueLocal::connecter()
{
    //qDebug() << Q_FUNC_INFO << "trottinetteDetectee" << trottinetteDetectee;

    if(!trottinetteDetectee)
        return;

    if (!socket)
    {
        socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
        connect(socket, SIGNAL(connected()), this, SLOT(trottinetteConnectee()));
        connect(socket, SIGNAL(connected()),this, SLOT(reglerChrono()));
        connect(socket, SIGNAL(disconnected()), this, SLOT(trottinetteDeconnectee()));
        connect(socket, SIGNAL(readyRead()), this, SLOT(socketReadyRead()));

    }

    if (socket->isOpen())
    {
        socket->close();
    }

    if(etatConnexion == false)
    {
        QBluetoothUuid uuid = QBluetoothUuid(QBluetoothUuid::SerialPort);
        socket->connectToService(QBluetoothAddress(this->getTrottinetteAdresseMac()), uuid);
        socket->open(QIODevice::ReadWrite);
        qDebug() << Q_FUNC_INFO << "demande connexion" << this->getTrottinetteAdresseMac();
    }
}

/**
 * @brief Change l'état du booléen etatConnexion lorsque la liaison entre la trottinette et le terminal mobile est effectué
 *
 * @fn PeripheriqueLocal::trottinetteConnectee
 *
 */
void PeripheriqueLocal::trottinetteConnectee()
{
    qDebug() << Q_FUNC_INFO << "Trottinette Connectée";
    etatConnexion = true;
    etatRecherche= false;
    emit connecte();
}

/**
 * @brief Change l'état du booléen etatConnexion lorsque la liaison entre la trottinette et le terminal mobile se termine
 *
 * @fn PeripheriqueLocal::trottinetteDeconnectee
 *
 */
void PeripheriqueLocal::trottinetteDeconnectee()
{
    etatConnexion = false;
    etatRecherche = false;
    emit arretChrono();
    emit deconnecte();
    qDebug() << Q_FUNC_INFO ;
}

/**
 * @brief Lorsque des données sont disponibles, les lit et émet un signal avec le contenu de la trame reçue
 *
 * @fn PeripheriqueLocal::socketReadyRead
 *
 */
void PeripheriqueLocal::socketReadyRead()
{    
    QByteArray donnees;

    while (socket->bytesAvailable())
    {
        donnees += socket->readAll();
        usleep(150000); // cf. timeout
    }

    emit trameRecue(QString(donnees));
    qDebug() << Q_FUNC_INFO << QString(donnees);
}

/**
 * @brief Affiche l'erreur dans le terminal de la console
 *
 * @fn PeripheriqueLocal::erreurConnexion
 *
 * @param error QBluetoothSocket::SocketError numéro d'erreur
 *
 */
void PeripheriqueLocal::erreurConnexion(QBluetoothSocket::SocketError error)
{
    qDebug() << Q_FUNC_INFO << error;
    etatConnexion = false;
    emit erreur();
}

void PeripheriqueLocal::afficherDonneesTrottinette(QString vitesse , QString inclinaison , QString batterie, QString distanceParcourue)
{
    qDebug() << Q_FUNC_INFO;
    this->vitesseTrottinette= vitesse ;
    this->inclinaisonTrottinette = inclinaison;
    this->batterieTrottinette = batterie;
    this->distanceParcourueTrottinette = distanceParcourue;
    emit trottinetteUpdate();
}

void PeripheriqueLocal::reglerChrono()
{
    // arrêt de l'horloge
    emit arretChrono();
     // redémarrage de l'horloge
    emit departChrono(PERIODE);
}

void PeripheriqueLocal::afficherChrono(QString chrono)
{
    this->chrono = chrono;
    emit chronoUpdated();
}

void PeripheriqueLocal::afficherRisqueDeChute(QString indicateurRisqueDeChute)
{
    risqueDeChute= indicateurRisqueDeChute;
    emit risqueDeChuteUpdate();
    qDebug() << Q_FUNC_INFO ;
}
