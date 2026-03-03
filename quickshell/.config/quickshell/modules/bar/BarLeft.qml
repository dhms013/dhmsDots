import QtQuick
import QtQuick.Layouts

RowLayout {
    required property QtObject barTheme

    spacing: 6

    CpuTempWidget {
        barTheme: parent.barTheme
    }

    CpuUsageWidget {
        barTheme: parent.barTheme
    }

    MemoryWidget {
        barTheme: parent.barTheme
    }

    IdleIndicator {
        barTheme: parent.barTheme
    }

}
