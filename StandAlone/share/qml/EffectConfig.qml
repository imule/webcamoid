/* Webcamoid, webcam capture application.
 * Copyright (C) 2011-2016  Gonzalo Exequiel Pedone
 *
 * Webcamoid is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Webcamoid is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
 *
 * Web-Site: http://webcamoid.github.io/
 */

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1

ColumnLayout {
    id: recEffectConfig

    property string curEffect: ""
    property bool inUse: false
    property bool advancedMode: VideoEffects.advancedMode

    signal effectAdded(string effectId)

    Connections {
        target: Webcamoid

        onInterfaceLoaded: {
            var currentEffects = VideoEffects.effects

            if (currentEffects.length > 0) {
                VideoEffects.removeInterface("itmEffectControls")
                VideoEffects.embedControls("itmEffectControls", 0)
            }
        }
    }

    onCurEffectChanged: {
        VideoEffects.removeInterface("itmEffectControls")
        var effectIndex = VideoEffects.effects.indexOf(curEffect)

        if (effectIndex < 0)
            effectIndex = VideoEffects.effects.length

        VideoEffects.embedControls("itmEffectControls", effectIndex)
    }

    Label {
        id: lblDescription
        text: qsTr("Description")
        font.bold: true
        Layout.fillWidth: true
    }
    TextField {
        id: txtDescription
        text: VideoEffects.effectDescription(recEffectConfig.curEffect)
        placeholderText: qsTr("Plugin description")
        readOnly: true
        Layout.fillWidth: true
    }
    Label {
        id: lblEffect
        text: qsTr("Plugin id")
        font.bold: true
        Layout.fillWidth: true
    }
    TextField {
        id: txtEffect
        text: recEffectConfig.curEffect
        placeholderText: qsTr("Plugin id")
        readOnly: true
        Layout.fillWidth: true
    }

    RowLayout {
        id: rowControls
        Layout.fillWidth: true
        visible: advancedMode? true: false

        Label {
            Layout.fillWidth: true
        }

        Button {
            id: btnAddRemove
            text: inUse? qsTr("Remove"): qsTr("Add")
            iconName: inUse? "remove": "add"
            iconSource: inUse? "image://icons/remove":
                               "image://icons/add"
            enabled: recEffectConfig.curEffect == ""? false: true

            onClicked: {
                var effectIndex = VideoEffects.effects.indexOf(recEffectConfig.curEffect)

                if (effectIndex < 0)
                    effectIndex = VideoEffects.effects.length

                if (inUse) {
                    VideoEffects.removeEffect(effectIndex)

                    if (VideoEffects.effects.length < 1)
                        recEffectConfig.curEffect = ""
                } else {
                    VideoEffects.setAsPreview(effectIndex, false)
                    recEffectConfig.effectAdded(recEffectConfig.curEffect)
                }
            }
        }
    }

    ScrollView {
        id: scrollControls
        Layout.fillWidth: true
        Layout.fillHeight: true

        contentItem: RowLayout {
            id: itmEffectControls
            objectName: "itmEffectControls"
            width: scrollControls.viewport.width
        }
    }
}
