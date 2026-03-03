import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: launcher
    visible: false; color: "transparent"
    anchors { top:true;bottom:true;left:true;right:true }
    WlrLayershell.layer:         WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace:     "quickshell:launcher"

    function toggle() {
        visible=!visible
        if(visible){ searchField.forceActiveFocus(); searchField.text="" }
    }

    // Theme from launcher.css
    property color colBase:"transparent"; property color colBorder:"transparent"
    property color colText:"transparent"; property color colFg:"transparent"
    property color colSel:"transparent";  property bool  ready:false
    property string css:""

    Process {
        id:tr; command:["sh","-c","cat $HOME/.config/themes/current/theme/launcher.css 2>/dev/null||true"]
        stdout:SplitParser{onRead:function(l){launcher.css+=l+"\n"}}
        onRunningChanged:{ if(!running){launcher.applyTheme(launcher.css);launcher.css="";launcher.ready=true} }
    }
    function applyTheme(c){
        function g(k){var m=new RegExp("@define-color\\s+"+k+"\\s+([^;\\n]+)").exec(c);return m?m[1].trim():null}
        var v; v=g("base");if(v)colBase=v; v=g("border");if(v)colBorder=v
        v=g("text");if(v)colText=v; v=g("foreground");if(v)colFg=v; v=g("selected-text");if(v)colSel=v
    }
    Component.onCompleted: tr.running=true

    property var  apps:[]
    property string q:""
    property bool loaded:false

    onVisibleChanged:{
        if(!visible) searchField.text=""
        else if(!loaded){loaded=true;scan.running=true}
    }
    Process {
        id:scan
        command:["sh","-c","for f in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop;do [ -f \"$f\" ]||continue;name=$(grep -m1 '^Name=' \"$f\"|cut -d= -f2-);nd=$(grep -m1 '^NoDisplay=' \"$f\"|cut -d= -f2-);icon=$(grep -m1 '^Icon=' \"$f\"|cut -d= -f2-);id=$(basename \"$f\" .desktop);[ -z \"$name\" ]&&continue;[ \"$nd\" = 'true' ]&&continue;printf '%s\\t%s\\t%s\\n' \"$name\" \"$icon\" \"$id\";done|sort -u"]
        stdout:SplitParser{onRead:function(l){var p=l.split("\t");if(p.length>=3){var a=launcher.apps.slice();a.push({name:p[0].trim(),icon:p[1].trim(),desktopId:p[2].trim()});launcher.apps=a}}}
    }

    property var model: {
        var r=[],i; for(i=0;i<apps.length;i++){var a=apps[i];if(!q||a.name.toLowerCase().indexOf(q.toLowerCase())!==-1)r.push(a)}
        if(q){r.sort(function(a,b){var ai=a.name.toLowerCase().indexOf(q.toLowerCase()),bi=b.name.toLowerCase().indexOf(q.toLowerCase());if(ai!==bi)return(ai<0?999:ai)-(bi<0?999:bi);return a.name.localeCompare(b.name)})}
        return r
    }

    Rectangle {
        anchors.fill:parent; color:"#000000"
        opacity:launcher.ready?0.45:0; Behavior on opacity{NumberAnimation{duration:150}}
        MouseArea{anchors.fill:parent;onClicked:launcher.visible=false}
    }
    Rectangle {
        id:card; width:420;height:520; anchors.centerIn:parent
        color:launcher.colBase; border.color:launcher.colBorder; border.width:1; radius:12
        opacity:launcher.ready?1:0; Behavior on opacity{NumberAnimation{duration:150}}
        MouseArea{anchors.fill:parent}

        ColumnLayout { anchors{fill:parent;margins:12}; spacing:8
            Rectangle {
                Layout.fillWidth:true; height:40; color:"transparent"
                border.color:launcher.colBorder; border.width:1; radius:8
                Row { anchors{verticalCenter:parent.verticalCenter;left:parent.left;leftMargin:12}; spacing:8
                    Text{text:"\uf002";color:launcher.colText;font{family:"JetBrainsMono Nerd Font";pixelSize:13};anchors.verticalCenter:parent.verticalCenter}
                    Item { width:card.width-80;height:22;anchors.verticalCenter:parent.verticalCenter
                        Text{anchors.fill:parent;text:"Search apps...";opacity:0.5;color:launcher.colText;font{family:"JetBrainsMono Nerd Font";pixelSize:13};verticalAlignment:Text.AlignVCenter;visible:searchField.text.length===0}
                        TextInput {
                            id:searchField; anchors.fill:parent; color:launcher.colFg
                            font{family:"JetBrainsMono Nerd Font";pixelSize:13}
                            verticalAlignment:TextInput.AlignVCenter; cursorVisible:activeFocus; selectionColor:launcher.colBorder; selectByMouse:true
                            onTextChanged:{ launcher.q=text; lv.currentIndex=0 }
                            Keys.onEscapePressed: launcher.visible=false
                            Keys.onUpPressed:     lv.stepUp()
                            Keys.onDownPressed:   lv.stepDown()
                            Keys.onReturnPressed: lv.go()
                            Keys.onEnterPressed:  lv.go()
                            Keys.onPressed: function(e){
                                if(e.modifiers&Qt.ControlModifier){
                                    if(e.key===Qt.Key_K) lv.stepUp()
                                    if(e.key===Qt.Key_J) lv.stepDown()
                                    if(e.key===Qt.Key_U) lv.currentIndex=Math.max(lv.currentIndex-5,0)
                                    if(e.key===Qt.Key_D) lv.currentIndex=Math.min(lv.currentIndex+5,lv.count-1)
                                }
                            }
                        }
                    }
                }
            }

            ListView {
                id:lv; Layout.fillWidth:true; Layout.fillHeight:true
                clip:true; spacing:2; currentIndex:0; model:launcher.model
                // FIX: disable animation so rotary wrap to top/bottom is instant
                highlightMoveDuration: 0

                function stepUp() {
                    var n=(currentIndex<=0)?count-1:currentIndex-1
                    currentIndex=n; positionViewAtIndex(n,ListView.Contain)
                }
                function stepDown() {
                    var n=(currentIndex>=count-1)?0:currentIndex+1
                    currentIndex=n; positionViewAtIndex(n,ListView.Contain)
                }
                function go() {
                    if(currentIndex<0||currentIndex>=count) return
                    var e=model[currentIndex]; launcher.visible=false
                    Qt.callLater(function(){lp.command=["gtk-launch",e.desktopId];lp.running=true})
                }

                delegate: LauncherItem {
                    required property var modelData
                    required property int index
                    width:lv.width; appName:modelData.name; appIcon:modelData.icon; desktopId:modelData.desktopId
                    isHighlighted:lv.currentIndex===index; searchQuery:launcher.q
                    textColor:launcher.colText; accentColor:launcher.colSel
                    onActivated:{launcher.visible=false;lp.command=["gtk-launch",desktopId];lp.running=true}
                }
                Process{id:lp}
            }
        }
    }
}
