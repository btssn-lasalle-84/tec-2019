#ifndef TRAME_H
#define TRAME_H

#include <QObject>

/**
  *
  * @file Trame.h
  *
  * @brief Déclaration de la classe Trame
  *
  * @author Somphon Sy
  *
  * @version 1.1
  *
  */

/**
  *
  * \class Trame
  *
  * \brief Déclaration de la classe Trame
  *
  * \author Somphon Sy
  *
  * \version 1.1
  *
  */

class Trame : public QObject
{
    Q_OBJECT
public:
    explicit Trame(QObject *parent = nullptr); //!< Constructeur de la classe Trame

signals:
    void donneesTrottinette(QString,QString,QString,QString); //!< Signal émettant les données de fonctionnement de la trottinette
    void risqueDeChute(QString);

public slots:
    void traiterTrame(QString); //!< Slot qui vas traiter la trame
};

#endif // TRAME_H
