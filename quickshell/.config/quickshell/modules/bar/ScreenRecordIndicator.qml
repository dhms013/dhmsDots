import QtQuick
import Quickshell.Io

Item {
    id: root
    required property QtObject barTheme
    implicitWidth: visible ? dot.width+lbl.implicitWidth+6 : 0
    implicitHeight: barTheme.barHeight
    visible: rec

    property bool rec: false

    Process {
        id: proc
        command:["sh","-c","pgrep -x gpu-screen-recorder>/dev/null&&echo 1||echo 0"]
        stdout: SplitParser { onRead: function(d){ root.rec=d.trim()==="1" } }
    }
    Timer { interval:2000; running:true; repeat:true; triggeredOnStart:true; onTriggered:proc.running=true }

    SequentialAnimation on opacity {
        running:root.rec; loops:Animation.Infinite
        NumberAnimation{to:0.3;duration:600} NumberAnimation{to:1.0;duration:600}
    }

    Row { anchors.centerIn:parent; spacing:4
        Rectangle { id:dot; width:8;height:8;radius:4; color:root.barTheme.critical; anchors.verticalCenter:parent.verticalCenter }
        Text { id:lbl; text:"REC"; color:root.barTheme.critical; font{family:root.barTheme.fontFamily;pixelSize:root.barTheme.fontSize;bold:true}; anchors.verticalCenter:parent.verticalCenter }
    }
}
