import QtQuick
import QtQuick.Layouts

Item {
    id: section

    required property QtObject barTheme
    required property Item contentItem
    property real bottomLeftRadius: 0
    property real bottomRightRadius: 0

    implicitWidth: contentLoader.implicitWidth + 16
    implicitHeight: barTheme.barHeight

    Rectangle {
        anchors.fill: parent
        color: section.barTheme.background
        border.color: Qt.rgba(section.barTheme.foreground.r, section.barTheme.foreground.g, section.barTheme.foreground.b, 0.8)
        border.width: 1
        bottomLeftRadius: section.bottomLeftRadius
        bottomRightRadius: section.bottomRightRadius
        topLeftRadius: 0
        topRightRadius: 0
    }

    Item {
        id: contentLoader

        implicitWidth: section.contentItem.implicitWidth
        implicitHeight: section.contentItem.implicitHeight
        Component.onCompleted: {
            section.contentItem.parent = contentLoader;
            section.contentItem.anchors.fill = contentLoader;
        }

        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
        }

    }

}
