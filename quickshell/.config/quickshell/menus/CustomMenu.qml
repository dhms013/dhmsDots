import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: cm; visible:false; color:"transparent"
    anchors{top:true;bottom:true;left:true;right:true}
    WlrLayershell.layer:WlrLayer.Overlay; WlrLayershell.keyboardFocus:WlrKeyboardFocus.Exclusive; WlrLayershell.namespace:"quickshell:custommenu"

    function toggle(){visible=!visible;if(visible){sel=0;card.forceActiveFocus()}}

    property color cBase:"transparent";property color cBorder:"transparent";property color cText:"transparent";property color cFg:"transparent";property color cSel:"transparent";property bool ready:false;property string css:""
    Process{id:tr;command:["sh","-c","cat $HOME/.config/themes/current/theme/launcher.css 2>/dev/null||true"];stdout:SplitParser{onRead:function(l){cm.css+=l+"\n"}};onRunningChanged:{if(!running){cm.applyTheme(cm.css);cm.css="";cm.ready=true}}}
    function applyTheme(c){function g(k){var m=new RegExp("@define-color\\s+"+k+"\\s+([^;\\n]+)").exec(c);return m?m[1].trim():null};var v;v=g("base");if(v)cBase=v;v=g("border");if(v)cBorder=v;v=g("text");if(v)cText=v;v=g("foreground");if(v)cFg=v;v=g("selected-text");if(v)cSel=v}
    Component.onCompleted:tr.running=true

    readonly property var items:[{label:"Update",icon:"\uf021",exec:"custom-menu update"},{label:"Setup",icon:"\uf013",exec:"custom-menu setup"},{label:"System",icon:"\uf011",exec:"custom-menu system"}]
    property int sel:0

    Rectangle{anchors.fill:parent;color:"#000000";opacity:cm.ready?0.45:0;Behavior on opacity{NumberAnimation{duration:150}};MouseArea{anchors.fill:parent;onClicked:cm.visible=false}}

    Rectangle {
        id:card; width:240; height:36+cm.items.length*48+20; anchors.centerIn:parent
        color:cm.cBase; border.color:cm.cBorder; border.width:1; radius:10
        opacity:cm.ready?1:0; Behavior on opacity{NumberAnimation{duration:150}}
        MouseArea{anchors.fill:parent}
        Keys.onEscapePressed:cm.visible=false; Keys.onReturnPressed:go(cm.sel); Keys.onEnterPressed:go(cm.sel)
        Keys.onPressed:function(e){if(e.key===Qt.Key_Down||(e.modifiers&Qt.ControlModifier&&e.key===Qt.Key_J))cm.sel=(cm.sel>=cm.items.length-1)?0:cm.sel+1;if(e.key===Qt.Key_Up||(e.modifiers&Qt.ControlModifier&&e.key===Qt.Key_K))cm.sel=(cm.sel<=0)?cm.items.length-1:cm.sel-1}
        function go(i){var it=cm.items[i];cm.visible=false;Qt.callLater(function(){ep.command=["sh","-c",it.exec];ep.running=true})}
        Process{id:ep}

        Column{anchors{fill:parent;margins:12};spacing:0
            Item{width:parent.width;height:36;Row{anchors.verticalCenter:parent.verticalCenter;spacing:8
                Text{text:"𐤃𐤄𐤌𐤑";color:cm.cText;font{pixelSize:14;bold:true}}
                Text{text:"Menu";color:cm.cText;font{family:"JetBrainsMono Nerd Font";pixelSize:12}}}}
            Rectangle{width:parent.width;height:1;color:cm.cBorder;opacity:0.5}
            Repeater{model:cm.items;delegate:Item{
                required property var modelData;required property int index
                width:card.width-24;height:48
                Rectangle{anchors.fill:parent;radius:6;color:cm.sel===index?cm.cSel+"20":"transparent";Behavior on color{ColorAnimation{duration:80}}}
                Row{anchors{left:parent.left;leftMargin:14;verticalCenter:parent.verticalCenter};spacing:10
                    Text{text:modelData.icon;color:cm.sel===index?cm.cSel:cm.cFg;font{family:"JetBrainsMono Nerd Font";pixelSize:13};Behavior on color{ColorAnimation{duration:80}}}
                    Text{text:modelData.label;color:cm.sel===index?cm.cSel:cm.cFg;font{family:"JetBrainsMono Nerd Font";pixelSize:13};Behavior on color{ColorAnimation{duration:80}}}}
                MouseArea{anchors.fill:parent;hoverEnabled:true;cursorShape:Qt.PointingHandCursor;onEntered:cm.sel=index;onClicked:card.go(index)}
            }}
        }
    }
}
