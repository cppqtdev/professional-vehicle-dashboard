QT += quick quickcontrols2 network
CONFIG += c++17

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        appbackend.cpp \
        climatecontroller.cpp \
        main.cpp \
        mediacontroller.cpp \
        quicksettingscontroller.cpp \
        vehiclecontroller.cpp

HEADERS += \
        appbackend.h \
        climatecontroller.h \
        mediacontroller.h \
        quicksettingscontroller.h \
        vehiclecontroller.h

RESOURCES += qml.qrc

# Make the App.* QML modules visible to Qt Creator's code model / Designer.
QML_IMPORT_PATH = $$PWD/qml

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = $$PWD/qml

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
