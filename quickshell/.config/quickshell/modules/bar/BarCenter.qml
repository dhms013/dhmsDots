import QtQuick
import QtQuick.Layouts

RowLayout {
    required property QtObject barTheme

    spacing: 4

    WorkspacesWidget {
        barTheme: parent.barTheme
    }

    ScreenRecordIndicator {
        barTheme: parent.barTheme
    }

}
