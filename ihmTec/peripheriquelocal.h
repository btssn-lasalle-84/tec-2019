#ifndef PERIPHERIQUELOCAL_H
#define PERIPHERIQUELOCAL_H

#include <QObject>
#include <QBluetoothLocalDevice>
#include <QBluetoothAddress>
#include <QBluetoothUuid>
#include <QBluetoothSocket>
#include <QBluetoothDeviceInfo>
#include <QBluetoothServiceInfo>
#include <QBluetoothDeviceDiscoveryAgent>
#include "trottinette.h"
#include "trame.h"
#include "chronometreutilisation.h"

/**
  *
  * @file PeripheriqueLocal.h
  *
  * @brief Déclaration de la classe PeripheriqueLocal
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * \class PeripheriqueLocal
  *
  * \brief Déclaration de la classe PeripheriqueLocal
  *
  * \author Somphon Sy
  *
  * \version 1.1
  *
  */

class PeripheriqueLocal : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString nom MEMBER nom NOTIFY trottinetteTrouvee)
    Q_PROPERTY(QString adresseMAC MEMBER adresseMAC NOTIFY trottinetteTrouvee)
    Q_PROPERTY(QString batterieTrottinette MEMBER batterieTrottinette NOTIFY batterieChange)
    Q_PROPERTY(QString vitesseTrottinette MEMBER vitesseTrottinette NOTIFY vitesseChange)
    Q_PROPERTY(QString inclinaisonTrottinette MEMBER inclinaisonTrottinette NOTIFY inclinaisonChange)
    Q_PROPERTY(QString distanceParcourueTrottinette MEMBER distanceParcourueTrottinette NOTIFY distanceParcourueChange)
    Q_PROPERTY(QString risqueDeChute MEMBER risqueDeChute NOTIFY risqueDeChuteChange)
    Q_PROPERTY(bool trottinetteDetectee MEMBER trottinetteDetectee NOTIFY trottinetteTrouvee)
    Q_PROPERTY(bool etatRecherche MEMBER etatRecherche NOTIFY recherche)
    Q_PROPERTY(bool etatConnexion MEMBER etatConnexion NOTIFY connecte)
    Q_PROPERTY(bool connexionErreur MEMBER connexionErreur NOTIFY erreur)
    Q_PROPERTY(QString chrono MEMBER chrono NOTIFY chronoChange)

public:
    explicit PeripheriqueLocal(QObject *parent = nullptr); //!< Constructeur de la classe Peripherique Local
    Q_INVOKABLE void rechercher(); //!< Lance la recherche d'appareil Bluetooth
    Q_INVOKABLE void arreter();//!< Arrête la recherche d'appareil Bluetooth
    Q_INVOKABLE QString getTrottinetteAdresseMac(); //!< Retourne l'adresse MAC de la trottinette
    Q_INVOKABLE QString getTrottinetteNom(); //!< Retourne le nom de la trottinette
    Q_INVOKABLE void connecter();//!< Etablis une connexion avec la socket du capteur de l'esp32
    QString getNom();//!< Retourne l'adresse MAC de la trottinette
    QString getAdresseMAC();//!< Retourne le nom de la trottinette

private:
    Trottinette* trottinette; //!< Pointeur sur un objet Trottinette
    Trame* trame; //!< Pointeur sur un objet Trame
    ChronometreUtilisation *chronometreUtilisation; //!< Pointeur sur un objet ChronometreUtilisation
    QString nom; //!< Nom du périphérique local
    QString adresseMAC; //!< Adresse physique du périphérique local
    QString vitesseTrottinette; //!< Récupère la vitesse de la Trottinette
    QString inclinaisonTrottinette; //!< Récupère l'inclinaison de la Trottinette
    QString batterieTrottinette; //!< Récupère la batterie de la Trottinette
    QString distanceParcourueTrottinette; //!< Récupère la distance Parcourue de la Trottinette
    QString chrono; //!< Récupère la durée d'utilisation de la Trottinette
    QString risqueDeChute;
    QBluetoothLocalDevice terminalMobile; //!< Objet QBluetoothLocalDevice qui permet d'avoir accès au bluetooth du périphérique local
    QBluetoothDeviceDiscoveryAgent* discoveryAgentDevice; //!< Pointeur sur un objet QBluetoothDeviceDiscoveryAgent qui permet d'utiliser le service DiscoveryAgent (recherche de périphériques Bluetooth)
    QBluetoothSocket *socket; //!< Pointeur sur un objet QBluetoothSocket qui permet de communiquer avec la trottinette
    bool etatConnexion; //!< Booléen qui indique l'etat de connexion du périphérique Local
    bool etatRecherche; //!< Booléen qui indique la recherche de la trottinette
    bool connexionErreur; //!< Booléen qui indique si il y a eu une erreur de connexion
    bool trottinetteDetectee; //!< Booléen qui indique si une trottinette a été detectée

protected slots:
    // recherche
    void identifierTrottinette(const QBluetoothDeviceInfo &info); //!< Slot permettant l'identification de la trottinette lors de la recherche d'appareil bluetooth externe
    void trottinetteConnectee(); //!< Slot permettant le changement d'êtat du booléen état connexion
    void trottinetteDeconnectee(); //!< Slot permettant le changement d'êtat du booléen état connexion
    void erreurConnexion(QBluetoothSocket::SocketError error); //!< Slot qui change l'état de connexion en false si il y a une erreur et affiche l'erreur dans la console
    void rechercheTerminee(); //!< Slot qui change l'état de recherche d'appareil
    void socketReadyRead(); //!< Slot qui envoie à la classe Trame les données reçues
    void afficherDonneesTrottinette(QString , QString , QString , QString); //!< Slot qui modifie les attributs liées au données de fonctionnement la trottinette dans la classe peripheriqueLocal
    void reglerChrono(); //!< Slot qui démarre le Chrono lors de la connexion avec la trottinette
    void afficherChrono(QString); //!< Slot qui modifie l'attribut chrono contenant les données d'utilisation de la trottinette
    void afficherRisqueDeChute(QString);

signals:
    void connecte(); //!< Signal émis lorsque la trottinette est connectée au périphérique Local
    void deconnecte(); //!< Signal émis lorsque la trottinette est déconnectée du périphérique Local
    void recherche(); //!< Signal émis lorsque le périphérique Local recherche la trottinette
    void erreur(); //!< Signal émis lorsque qu'il y a une erreur de connexion entre la trottinette et le périphérique Local
    void trottinetteTrouvee(); //!< Signal émis lorsque la trottinette a été detectée
    void arretRecherche(); //!< Signal émis lorsque la recherche a été arrêtée
    void trameRecue(QString ); //!< Signal émis lorsqu'une trame a été reçue de la trottinette
    void vitesseChange();//!< Signal émis lorsque l'attribut vitesseTrottinette change
    void batterieChange(); //!< Signal émis lorsque l'attribut batterieTrottinette change
    void inclinaisonChange();//!< Signal émis lorsque l'attribut inclinaisonTrottinette change
    void distanceParcourueChange();//!< Signal émis lorsque l'attribut distanceParcourueTrottinette change
    void trottinetteUpdate();//!< Signal émis lorsque le traitement de la trame a été effectué
    void departChrono(int); //!< Signal émis pour lancer le chrono
    void arretChrono(); //!< Signal émis pour arrêter le chrono
    void chronoChange(); //!< Signal émis lorsque le chrono change
    void chronoUpdated();//!< Signal émis lorsque le chrono a changé
    void risqueDeChuteChange();//!< Signal émis lorsque le risque a changé
    void risqueDeChuteUpdate();//!< Signal émis lorsque le risque a changé
};

#endif // PERIPHERIQUELOCAL_H
