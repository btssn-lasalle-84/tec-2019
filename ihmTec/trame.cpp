#include "trame.h"
#include <QDebug>

/**
  *
  * @file trame.cpp
  *
  * @brief Définition de la classe Trame
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
 * @brief Constructeur de la classe Trame
 *
 * @fn Trame::Trame
 *
 * @param parent QObject Adresse de l'objet Qt parent
 */


Trame::Trame(QObject *parent) : QObject(parent)
{

}

/**
 * @brief Slot qui vas traiter la trame vas emettre le signal contenant les données de fonctionnement de la trottinette
 *
 * @fn Trame::traiterTrame
 *
 * @param trame QString trame émise par la trottinette
 */

void Trame::traiterTrame(QString trame)
{
    QString vitesse;
    QString inclinaison;
    QString batterie;
    QString distanceParcourue ;
    QString indicateurRisqueDeChute;
    qDebug() << Q_FUNC_INFO << trame;
    if(trame.startsWith("TEC"))
    {
        inclinaison = trame.section(';',1,1);
        batterie = trame.section(';',2,2);
        vitesse = trame.section(';',3,3);
        distanceParcourue = trame.section(';',4,4);
        indicateurRisqueDeChute=trame.section(";",5,5);

        qDebug()<< "La vitesse est de : " << vitesse << "L'inclinaison est de : " << inclinaison;
        qDebug()<< "La batterie est de : " << batterie << "La distance parcourue est de : " << distanceParcourue;
        qDebug()<< "Risque de chute: " << indicateurRisqueDeChute ;
        emit donneesTrottinette(vitesse , inclinaison,batterie , distanceParcourue);
        emit risqueDeChute(indicateurRisqueDeChute);
    }
}
