import QtQuick
import QtQuick.Controls

Item {
    id: root

    property color bgColor: "#090a10"
    property color accentColor: "#bd93f9"
    property real time: 0

    ShaderEffect {
        id: shader
        anchors.fill: parent

        property real time: root.time
        property vector2d resolution: Qt.vector2d(width, height)
        property color bg: root.bgColor
        property color accent: root.accentColor
        property real qt_Opacity: parent.opacity

        vertexShader: "ltmnight.vert.qsb"
        fragmentShader: "ltmnight.frag.qsb"

        NumberAnimation on time {
            from: 0
            to: 1000
            duration: 1000000
            loops: Animation.Infinite
            running: true
        }
    }


}
