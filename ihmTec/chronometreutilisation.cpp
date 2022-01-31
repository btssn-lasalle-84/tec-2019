#include "chronometreutilisation.h"
#include <QDebug>

/**
  *
  * @file chronometreutilisation.cpp
  *
  * @brief Définition de la classe ChronometreUtilisation
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
 * @brief Constructeur de la classe ChronometreUtilisation
 *
 * @fn ChronometreUtilisation::ChronometreUtilisation
 *
 * @param parent QObject Adresse de l'objet Qt parent
 */

ChronometreUtilisation::ChronometreUtilisation(QObject *parent) : QObject(parent)
{
    // initialise la valeur du compteur de tic d'horloge
    m_valeur = 0;

    // instancie le timer (base de temps) de l'horloge
    m_timer = new QTimer(this);

    // connecte le signal d'expiration (timeout) d'une période (top d'horloge) au slot tic()
    connect(m_timer, SIGNAL(timeout()), this, SLOT(tic()));
}

/**
 * @brief Accesseur des minutes du chrono
 *
 * @fn ChronometreUtilisation::getMinute
 *
 * @return long minute du chronomètre
 */

long ChronometreUtilisation::getMinute()
{
    return (m_valeur%36000)/600;
}

/**
 * @brief Accesseur des heures du chrono
 *
 * @fn ChronometreUtilisation::getHeure
 *
 * @return long heure du chronomètre
 */

long ChronometreUtilisation::getHeure()
{
    long heure = m_valeur/36000 ;
    if (heure >= 24)
    {
        heure -= 24;
        return heure;
    }
    else
    return heure;
}

/**
 * @brief Accesseur des secondes du chrono
 *
 * @fn ChronometreUtilisation::getSeconde
 *
 * @return long secondes du chronomètre
 */
long ChronometreUtilisation::getSeconde()
{
     return ((m_valeur/10)%60);
}

/**
 * @brief Met à jour la variable contenant la durée du temps d'utilisation
 *
 * @fn ChronometreUtilisation::update
 */

void ChronometreUtilisation::update()
{
   QString heure, minute , seconde , msec;

   // met à jour l'affichage de l'horloge
   if (getHeure() < 10)
      heure = "0" + QString::number(getHeure());
   else heure = QString::number(getHeure());
   if (getMinute() < 10)
      minute = "0" + QString::number(getMinute());
   else minute = QString::number(getMinute());
   if (getSeconde() < 10 )
       seconde = "0" + QString::number(getSeconde());
   else seconde = QString::number(getSeconde());
   if (getSeconde() < 10 )
       seconde = "0" + QString::number(getSeconde());
   else seconde = QString::number(getSeconde());

   QString text = heure + ":" + minute + ":" + seconde  ;
   emit chronoUpdated(text);
}

/**
 * @brief Incrémente la variable contenant le temps du chronomètre
 *
 * @fn ChronometreUtilisation::tic
 */
void ChronometreUtilisation::tic()
{
    // incrémente le compteur de top d'horloge
    m_valeur++;
    // demande la mise à jour l'affichage de l'horloge
    update();
}

/**
 * @brief Démarre le chronomètre
 *
 * @fn ChronometreUtilisation::demarrer
 */
void ChronometreUtilisation::demarrer(int top/*=PERIODE*/)
{
    qDebug() << "ChronometreUtilisation::demarrer()";
    m_timer->start(top);
}

/**
 * @brief Arrête le chronomètre
 *
 * @fn ChronometreUtilisation::demarrer
 */
void ChronometreUtilisation::arreter()
{
    m_valeur = 0 ;
    m_timer->stop();
    update();
    qDebug() << "ChronometreUtilisation::arreter()";
}

