#ifndef CHRONOMETREUTILISATION_H
#define CHRONOMETREUTILISATION_H

#include <QObject>
#include <QTimer>
// en ms
#define PERIODE 100

/**
  *
  * @file chronometreutilisation.h
  *
  * @brief Déclaration de la classe ChronometreUtilisation
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * \class ChronometreUtilisation
  *
  * \brief Déclaration de la classe ChronometreUtilisation
  *
  * \author Somphon Sy
  *
  * \version 1.1
  *
  */

class ChronometreUtilisation : public QObject
{
    Q_OBJECT
public:
    explicit ChronometreUtilisation(QObject *parent = nullptr);  //!< Constructeur de la classe ChronometreUtilisation
    long getMinute();  //!< Retourne les minutes du chrono
    long getHeure();//!< Retourne l'heure du chrono
    long getSeconde(); //!< Retourne les secondes du chrono

private:
    QTimer    *m_timer; //!< Pointeur sur une classe QTimer
    long      m_valeur; //!< Compteur de l'horloge
    void update(); //!< Met à jour la variable contenant l'heure

signals:
    void chronoUpdated(QString); //!< Signal contenant la variable contenant l'heure

public slots:
    void  demarrer(int top=PERIODE); //!< Slot lançant le timer du chrono
    void  arreter(); //!< Slot arrêtant le timer du chrono

private slots:
    void  tic(); //!< Slot qui incrémente le timer du chrono
};


#endif // CHRONOMETREUTILISATION_H
