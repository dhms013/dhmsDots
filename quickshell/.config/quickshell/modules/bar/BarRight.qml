import QtQuick
import QtQuick.Layouts

RowLayout {
    required property QtObject barTheme

    spacing: 6

    NetworkWidget {
        barTheme: parent.barTheme
    }

    ClockWidget {
        barTheme: parent.barTheme
    }

    BatteryWidget {
        barTheme: parent.barTheme
    }

}
