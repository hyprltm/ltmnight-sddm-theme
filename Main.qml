// Copyright (C) 2026 Djalel Oukid
// Distributed under the AGPL-3.0 License https://www.gnu.org/licenses/agpl-3.0.html

import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtMultimedia

import "Components"

Pane {
    id: root

    height: config.ScreenHeight || Window.height
    width: config.ScreenWidth || Window.width
    padding: config.ScreenPadding

    LayoutMirroring.enabled: config.RightToLeftLayout === "true" || Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor

    font.family: config.Font
    font.pointSize: config.FontSize || parseInt(Math.min(width, height) / fontSizeRatio) || defaultFontSize
    
    focus: true
    
    readonly property int zBackground: 0
    readonly property int zTint: 1
    readonly property int zForm: 1
    readonly property int zTopBar: 2
    readonly property int zKeyboard: 10

    readonly property real formWidthRatio: 2.5
    readonly property int minFormWidth: 300
    readonly property int defaultFontSize: 13
    readonly property real fontSizeRatio: 80

    readonly property bool isPortrait: height > width
    readonly property bool haveFormBackground: config.HaveFormBackground === "true"
    readonly property bool partialBlur: config.PartialBlur === "true"
    readonly property bool fullBlur: config.FullBlur === "true"
    readonly property bool hideVirtualKeyboard: config.HideVirtualKeyboard === "true"
    readonly property bool virtualKeyboardAutoShow: config.VirtualKeyboardAutoShow === "true"
    readonly property bool cropBackground: config.CropBackground === "true"
    readonly property bool pauseBackground: config.PauseBackground === "true"

    readonly property bool isVideoBackground: {
        const filename = config.Background
        if (!filename || config.Background === "ltmnight") return false
        const ext = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase()
        const videoFileTypes = ["avi", "mp4", "mov", "mkv", "m4v", "webm"]
        return videoFileTypes.includes(ext)
    }

    readonly property bool shouldOffsetBackground: haveFormBackground && !partialBlur && config.FormPosition !== "center"
    readonly property bool backgroundOnRight: shouldOffsetBackground && formPosition === "left"
    readonly property bool backgroundOnLeft: shouldOffsetBackground && formPosition === "right"

    readonly property real backgroundWidth: {
        if (shouldOffsetBackground) {
            return sizeHelper.width - formBackground.width
        }
        return sizeHelper.width
    }

    readonly property real blurWidth: {
        if (fullBlur) {
            if (shouldOffsetBackground) {
                return sizeHelper.width - formBackground.width
            }
            return sizeHelper.width
        }
        return form.width
    }

    readonly property string formPosition: config.FormPosition || "center"
    readonly property string virtualKeyboardPosition: config.VirtualKeyboardPosition || "center"

    Item {
        id: sizeHelper
        anchors.fill: parent
        
        Rectangle {
            id: tintLayer
            anchors.fill: parent
            z: zTint
            color: config.DimBackgroundColor
            opacity: config.DimBackground
        }

        Rectangle {
            id: formBackground
            anchors.fill: form
            anchors.centerIn: form
            z: zForm

            color: config.FormBackgroundColor
            visible: haveFormBackground
            opacity: partialBlur ? 0.5 : 1
            
            radius: config.RoundCorners || 10
        }

        LoginForm {
            id: form
            anchors.left: formPosition === "left" ? parent.left : undefined
            anchors.horizontalCenter: formPosition === "center" ? parent.horizontalCenter : undefined
            anchors.right: formPosition === "right" ? parent.right : undefined
            z: zForm

            height: parent.height
            width: isPortrait ? Math.max(parent.width * 0.85, minFormWidth) : Math.max(parent.width / formWidthRatio, minFormWidth)

            Accessible.role: Accessible.Form
            Accessible.name: qsTr("Login Form")
        }

        TopBar {
            id: topBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: root.font.pointSize * 1.5
            z: zTopBar
        }

        Loader {
            id: virtualKeyboard
            source: "Components/VirtualKeyboard.qml"
            active: !hideVirtualKeyboard

            width: parent.width * (config.KeyboardSize || 0.4)
            anchors.bottom: parent.bottom
            anchors.bottomMargin: root.font.pointSize * 1.5
            anchors.left: virtualKeyboardPosition === "left" ? parent.left : undefined
            anchors.horizontalCenter: virtualKeyboardPosition === "center" ? parent.horizontalCenter : undefined
            anchors.right: virtualKeyboardPosition === "right" ? parent.right : undefined
            z: zKeyboard

            onStatusChanged: {
                if (status === Loader.Error) {
                    console.error("Failed to load virtual keyboard")
                }
            }
        }
        
        Loader {
            id: proceduralBackground
            anchors.fill: parent
            source: "Components/LTMNightBackground.qml"
            active: config.Background === "ltmnight"
            visible: active
            asynchronous: true
            z: zBackground
            onLoaded: {
                item.bgColor = config.BackgroundColor
                item.accentColor = config.HighlightBackgroundColor
            }
            onStatusChanged: {
                if (status === Loader.Error) {
                    console.error("Failed to load procedural background")
                }
            }
        }

        Image {
            id: backgroundPlaceholderImage
            z: zBackground
            source: config.BackgroundPlaceholder || ""
            visible: isVideoBackground && player.playbackState !== MediaPlayer.PlayingState
        }

        Item {
            id: backgroundImage
            visible: config.Background !== "ltmnight"
            width: backgroundWidth
            height: parent.height
            z: zBackground
            
            anchors.left: backgroundOnRight ? formBackground.right : undefined
            anchors.right: backgroundOnLeft ? formBackground.left : undefined

            MediaPlayer {
                id: player
                videoOutput: videoOutput
                autoPlay: true
                playbackRate: config.BackgroundSpeed || 1.0
                loops: -1
                source: isVideoBackground ? Qt.resolvedUrl(config.Background) : ""
                onErrorOccurred: function(error, errorString) {
                    console.error("Video playback error:", errorString)
                }
            }

            VideoOutput {
                id: videoOutput
                fillMode: cropBackground ? VideoOutput.PreserveAspectCrop : VideoOutput.PreserveAspectFit
                anchors.fill: parent
                visible: player.source != ""
            }

            AnimatedImage {
                id: backgroundActualImage
                anchors.fill: parent
                fillMode: cropBackground ? Image.PreserveAspectCrop : Image.PreserveAspectFit
                asynchronous: true
                cache: true
                clip: true
                mipmap: true
                playing: !pauseBackground
                visible: !isVideoBackground
                source: (config.Background !== "ltmnight" && !isVideoBackground) ? config.Background : ""

                horizontalAlignment: {
                    switch(config.BackgroundHorizontalAlignment) {
                        case "left": return Image.AlignLeft
                        case "right": return Image.AlignRight
                        default: return Image.AlignHCenter
                    }
                }

                verticalAlignment: {
                    switch(config.BackgroundVerticalAlignment) {
                        case "top": return Image.AlignTop
                        case "bottom": return Image.AlignBottom
                        default: return Image.AlignVCenter
                    }
                }

                onStatusChanged: {
                    if (status === Image.Error) {
                        console.error("Failed to load background image")
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: backgroundImage
            onClicked: parent.forceActiveFocus()
        }

        ShaderEffectSource {
            id: blurMask
            anchors.centerIn: form
            width: form.width
            height: parent.height
            sourceItem: backgroundImage
            sourceRect: Qt.rect(x,y,width,height)
            visible: fullBlur || partialBlur
        }

        MultiEffect {
            id: blur
            height: parent.height
            width: blurWidth
            anchors.centerIn: fullBlur ? backgroundImage : form
            source: fullBlur ? backgroundImage : blurMask
            blurEnabled: true
            autoPaddingEnabled: false
            blur: config.Blur || 2.0
            blurMax: config.BlurMax || 48
            visible: fullBlur || partialBlur
        }
    }
}
