#ifndef TROTTINETTE_H
#define TROTTINETTE_H

#include <QObject>

/**
  *
  * @file trottinette.h
  *
  * @brief Déclaration de la classe Trottinette
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * \class Trottinette
  *
  * \brief Déclaration de la classe Trottinette
  *
  * \author Somphon Sy
  *
  * \version 1.1
  *
  */

class Trottinette : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString nom READ getNom NOTIFY peripheriqueChanged)
    Q_PROPERTY(QString adresseMAC READ getAdresseMAC NOTIFY peripheriqueChanged)

public:
    explicit Trottinette(QString nom , QString adresseMAC ,QObject *parent = nullptr); //!< Constructeur de la classe Trottinette
    QString getNom(); //!< Retourne le nom de la trottinette
    QString getAdresseMAC();  //!< Retourne l'adresse MAC de la trottinette

private:
    QString nom; //!< nom du périphérique Bluetooth
    QString adresseMAC; //!< adresse MAC du périphérique Bluetooth


public slots:

signals:
    void peripheriqueChanged(); //!< les attributs du périphériques ont changé
};

#endif // TROTTINETTE_H
