#include "trottinette.h"
#include "peripheriquelocal.h"

/**
  *
  * @file trottinette.cpp
  *
  * @brief Définition de la classe Trottinette
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
 * @brief Constructeur de la classe Trottinette
 *
 * @fn Trottinette::Trottinette
 *
 * @param nom QString nom
 * @param adresseMAC QString Adresse MAC
 * @param parent QObject Adresse de l'objet Qt parent
 */
Trottinette::Trottinette(QString nom , QString adresseMAC ,QObject *parent) : QObject(parent) , nom(nom) , adresseMAC(adresseMAC)
{

}

/**
 * @brief Accesseur de l'attribut nom
 *
 * @fn Trottinette::getNom
 *
 * @return QString nom du périphérique Bluetooth
 */
QString Trottinette::getNom()
{
    return nom;
}

/**
 * @brief Accesseur de l'attribut adresseMAC
 *
 * @fn Trottinette::getAdresseMAC
 *
 * @return QString adresse MAC du périphérique Bluetooth
 */
QString Trottinette::getAdresseMAC()
{
    return adresseMAC;
}
