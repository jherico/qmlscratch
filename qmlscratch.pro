TEMPLATE = app

QT += gui qml quick xml webengine widgets

CONFIG += c++11

SOURCES += main.cpp \
    ScriptsModel.cpp \
    ScriptsModelFilter.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    ScriptsModel.h \
    ScriptsModelFilter.h
