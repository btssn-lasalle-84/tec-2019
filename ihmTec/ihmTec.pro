QT += quick quickcontrols2 bluetooth location positioning
#QT += qml quick bluetooth quickcontrols2 location positioning gui
CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    peripheriquelocal.cpp \
    trottinette.cpp \
    trame.cpp \
    chronometreutilisation.cpp

HEADERS += \
    peripheriquelocal.h \
    trottinette.h \
    trame.h \
    chronometreutilisation.h

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

DISTFILES += \
    android/AndroidManifest.xml \
    helper.js \
    src/icons/32x32/bluetoothoff.png \
    src/icons/32x32/bluetoothon.png

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

ANDROID_EXTRA_LIBS = \
        $$PWD/android/libs/arm/libcrypto.so \
        $$PWD/android/libs/arm/libssl.so

#ANDROID_PERMISSIONS =
#        android.permission.BLUETOOTH
#        android.permission.BLUETOOTH_ADMIN
#        android.permission.ACCESS_COARSE_LOCATION
