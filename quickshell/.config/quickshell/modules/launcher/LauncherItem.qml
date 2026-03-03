import QtQuick
import QtQuick.Layouts

Item {
    id: item; implicitHeight:46
    required property string appName; required property string appIcon
    required property string desktopId; required property bool isHighlighted
    required property color textColor; required property color accentColor
    property string searchQuery:""
    signal activated()

    Rectangle {
        anchors{fill:parent;leftMargin:2;rightMargin:2}; radius:6
        color:isHighlighted?accentColor+"20":hov.containsMouse?accentColor+"10":"transparent"
        Behavior on color{ColorAnimation{duration:80}}

        RowLayout { anchors{fill:parent;leftMargin:10;rightMargin:10}; spacing:10
            Item { Layout.preferredWidth:28; Layout.preferredHeight:28
                Image{id:img;anchors.fill:parent;source:!appIcon?"":(appIcon.startsWith("/")||appIcon.startsWith("file://"))?appIcon:"image://theme/"+appIcon;fillMode:Image.PreserveAspectFit;visible:status===Image.Ready;smooth:true}
                Rectangle{anchors.fill:parent;radius:4;color:accentColor+"30";visible:img.status!==Image.Ready
                    Text{anchors.centerIn:parent;text:appName.length>0?appName.charAt(0).toUpperCase():"?";color:accentColor;font{pixelSize:13;bold:true}}}
            }
            Text {
                Layout.fillWidth:true
                text:{var q=searchQuery.toLowerCase();if(!q||!appName.toLowerCase().includes(q))return appName;var lo=appName.toLowerCase(),i=lo.indexOf(q);return appName.slice(0,i)+"<b><font color='"+accentColor+"'>"+appName.slice(i,i+q.length)+"</font></b>"+appName.slice(i+q.length)}
                textFormat:Text.RichText; color:isHighlighted?accentColor:textColor
                font{family:"JetBrainsMono Nerd Font";pixelSize:13}; elide:Text.ElideRight
                Behavior on color{ColorAnimation{duration:80}}
            }
        }
    }
    MouseArea{id:hov;anchors.fill:parent;hoverEnabled:true;cursorShape:Qt.PointingHandCursor;onClicked:item.activated()}
}
