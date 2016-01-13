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

DISTFILES += \
    ../hifi/interface/resources/qml/Global.js \
    ../hifi/interface/resources/qml/qml.pro.user \
    ../hifi/interface/resources/qml/AddressBarDialog.qml \
    ../hifi/interface/resources/qml/AvatarInputs.qml \
    ../hifi/interface/resources/qml/Browser.qml \
    ../hifi/interface/resources/qml/ErrorDialog.qml \
    ../hifi/interface/resources/qml/InfoView.qml \
    ../hifi/interface/resources/qml/LoginDialog.qml \
    ../hifi/interface/resources/qml/MarketplaceDialog.qml \
    ../hifi/interface/resources/qml/MessageDialog.qml \
    ../hifi/interface/resources/qml/Palettes.qml \
    ../hifi/interface/resources/qml/QmlWebWindow.qml \
    ../hifi/interface/resources/qml/QmlWindow.qml \
    ../hifi/interface/resources/qml/RecorderDialog.qml \
    ../hifi/interface/resources/qml/Root.qml \
    ../hifi/interface/resources/qml/ScrollingGraph.qml \
    ../hifi/interface/resources/qml/Stats.qml \
    ../hifi/interface/resources/qml/TestControllers.qml \
    ../hifi/interface/resources/qml/TestDialog.qml \
    ../hifi/interface/resources/qml/TestMenu.qml \
    ../hifi/interface/resources/qml/TestRoot.qml \
    ../hifi/interface/resources/qml/TextOverlayElement.qml \
    ../hifi/interface/resources/qml/Tooltip.qml \
    ../hifi/interface/resources/qml/UpdateDialog.qml \
    ../hifi/interface/resources/qml/VrMenu.qml \
    ../hifi/interface/resources/qml/VrMenuItem.qml \
    ../hifi/interface/resources/qml/VrMenuView.qml \
    ../hifi/interface/resources/qml/WebEntity.qml \
    ../hifi/interface/resources/qml/controller/hydra/HydraButtons.qml \
    ../hifi/interface/resources/qml/controller/hydra/HydraStick.qml \
    ../hifi/interface/resources/qml/controller/xbox/DPad.qml \
    ../hifi/interface/resources/qml/controller/xbox/LeftAnalogStick.qml \
    ../hifi/interface/resources/qml/controller/xbox/RightAnalogStick.qml \
    ../hifi/interface/resources/qml/controller/xbox/XboxButtons.qml \
    ../hifi/interface/resources/qml/controller/AnalogButton.qml \
    ../hifi/interface/resources/qml/controller/AnalogStick.qml \
    ../hifi/interface/resources/qml/controller/Hydra.qml \
    ../hifi/interface/resources/qml/controller/Standard.qml \
    ../hifi/interface/resources/qml/controller/ToggleButton.qml \
    ../hifi/interface/resources/qml/controller/Xbox.qml \
    ../hifi/interface/resources/qml/controls/Button.qml \
    ../hifi/interface/resources/qml/controls/ButtonAwesome.qml \
    ../hifi/interface/resources/qml/controls/CheckBox.qml \
    ../hifi/interface/resources/qml/controls/DialogBase.qml \
    ../hifi/interface/resources/qml/controls/DialogContainer.qml \
    ../hifi/interface/resources/qml/controls/FontAwesome.qml \
    ../hifi/interface/resources/qml/controls/Player.qml \
    ../hifi/interface/resources/qml/controls/Slider.qml \
    ../hifi/interface/resources/qml/controls/Spacer.qml \
    ../hifi/interface/resources/qml/controls/SpinBox.qml \
    ../hifi/interface/resources/qml/controls/Text.qml \
    ../hifi/interface/resources/qml/controls/TextAndSlider.qml \
    ../hifi/interface/resources/qml/controls/TextAndSpinBox.qml \
    ../hifi/interface/resources/qml/controls/TextArea.qml \
    ../hifi/interface/resources/qml/controls/TextEdit.qml \
    ../hifi/interface/resources/qml/controls/TextHeader.qml \
    ../hifi/interface/resources/qml/controls/TextInput.qml \
    ../hifi/interface/resources/qml/controls/TextInputAndButton.qml \
    ../hifi/interface/resources/qml/controls/VrDialog.qml \
    ../hifi/interface/resources/qml/dialogs/FileDialog.qml \
    ../hifi/interface/resources/qml/dialogs/RunningScripts.qml \
    ../hifi/interface/resources/qml/styles/Border.qml \
    ../hifi/interface/resources/qml/styles/ButtonStyle.qml \
    ../hifi/interface/resources/qml/styles/HifiConstants.qml \
    ../hifi/interface/resources/qml/styles/HifiPalette.qml \
    ../hifi/interface/resources/qml/styles/IconButtonStyle.qml \
    ../hifi/interface/resources/qml/windows/DefaultFrame.qml \
    ../hifi/interface/resources/qml/windows/Frame.qml \
    ../hifi/interface/resources/qml/windows/Window.qml \
    ../hifi/interface/resources/qml/test/Stubs.qml \
    ../hifi/interface/resources/qml/ToolWindow.qml \
    ../hifi/interface/resources/qml/controls/WebView.qml

SUBDIRS += \
    ../hifi/interface/resources/qml/qml.pro
