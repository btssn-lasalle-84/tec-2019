#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QIcon>
#include <QDebug>
#include "peripheriquelocal.h"

/**
 * @file main.cpp
 *
 * @brief Programme principal
 *
 * @details Crée et affiche la fenêtre principale de l'application
 *
 * @author Somphon Sy
 *
 * @version 1.1
 *
 * @fn main(int argc, char *argv[])
 * @param argc
 * @param argv[]
 * @return int
 *
 */

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material"); // ("Default", "Fusion", "Imagine", "Material", "Universal")
    QIcon::setThemeName("mytheme");

    engine.rootContext()->setContextProperty("peripheriqueLocal", new PeripheriqueLocal());
    engine.load(QUrl(QStringLiteral("qrc:/Application.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
