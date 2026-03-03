import QtQuick
import QtQuick.Layouts

Rectangle {
    id: cal
    required property QtObject barTheme
    signal closeRequested()
    implicitWidth:240; implicitHeight:col.implicitHeight+24
    color:barTheme.background; border.color:barTheme.accent; border.width:1; radius:8

    property var now:new Date(); property int yr:now.getFullYear(); property int mo:now.getMonth()
    readonly property var mnames:["January","February","March","April","May","June","July","August","September","October","November","December"]
    function dim(y,m){return new Date(y,m+1,0).getDate()} function fd(y,m){return new Date(y,m,1).getDay()}

    Column { id:col; anchors{top:parent.top;left:parent.left;right:parent.right;margins:12}; spacing:6
        RowLayout { width:parent.width
            Text{text:"<";color:cal.barTheme.accent;font{family:cal.barTheme.fontFamily;pixelSize:cal.barTheme.fontSize+2;bold:true}
                MouseArea{anchors.fill:parent;onClicked:{cal.mo--;if(cal.mo<0){cal.mo=11;cal.yr--}}}}
            Text{Layout.fillWidth:true;horizontalAlignment:Text.AlignHCenter;text:cal.mnames[cal.mo]+" "+cal.yr;color:cal.barTheme.foreground;font{family:cal.barTheme.fontFamily;pixelSize:cal.barTheme.fontSize;bold:true}}
            Text{text:">";color:cal.barTheme.accent;font{family:cal.barTheme.fontFamily;pixelSize:cal.barTheme.fontSize+2;bold:true}
                MouseArea{anchors.fill:parent;onClicked:{cal.mo++;if(cal.mo>11){cal.mo=0;cal.yr++}}}}
        }
        Grid{columns:7;width:parent.width
            Repeater{model:["Su","Mo","Tu","We","Th","Fr","Sa"]
                delegate:Text{required property string modelData;width:(cal.width-24)/7;horizontalAlignment:Text.AlignHCenter;text:modelData;color:cal.barTheme.foreground;opacity:0.6;font{family:cal.barTheme.fontFamily;pixelSize:cal.barTheme.fontSize-1}}}
        }
        Grid{columns:7;width:parent.width
            property int f:cal.fd(cal.yr,cal.mo); property int n:cal.dim(cal.yr,cal.mo); property int rows:Math.ceil((f+n)/7)
            Repeater{model:parent.rows*7
                delegate:Item{required property int index;width:(cal.width-24)/7;height:22
                    property int dn:index-cal.fd(cal.yr,cal.mo)+1
                    property bool valid:dn>=1&&dn<=cal.dim(cal.yr,cal.mo)
                    property bool isToday:valid&&dn===cal.now.getDate()&&cal.mo===cal.now.getMonth()&&cal.yr===cal.now.getFullYear()
                    Rectangle{anchors.centerIn:parent;width:18;height:18;radius:9;color:isToday?cal.barTheme.accent+"40":"transparent";border.color:isToday?cal.barTheme.accent:"transparent";border.width:1}
                    Text{anchors.centerIn:parent;text:valid?String(dn):"";color:isToday?cal.barTheme.accent:cal.barTheme.foreground;font{family:cal.barTheme.fontFamily;pixelSize:cal.barTheme.fontSize-1;bold:isToday}}
                }
            }
        }
    }
}
