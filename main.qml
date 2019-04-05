import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import "../js/gridcreator.js" as GridCreator

Window {
    id: root
    visible: true
    width: 1280
    height: 700

    Flickable {

        boundsBehavior: Flickable.DragOverBounds
        id: flickArea
        focus: true
        contentWidth: Math.max(gridContainer.width * slider.value, width)
        contentHeight: Math.max(gridContainer.height * slider.value, height)
        contentX: contentWidth === width ? 0 : gridContainer.width * slider.value
                                           / 2 - flickArea.width / 2
        contentY: contentHeight === height ? 0 : gridContainer.height * slider.value
                                             / 2 - flickArea.height / 2

        Component.onCompleted: GridCreator.createSpriteObjects()
        Rectangle {
            id: gridContainer
            width: 5000//Don't forget to check that at gridcreator.js
            height: 5000 //Don't forget to check that at gridcreator.js
            color: "grey"
            scale: slider.value
            MouseArea {
                anchors.fill: parent
                drag.target: gridContainer
                drag.axis: Drag.XAndYAxis
            }
        }
    }

    Slider {
        id: slider
        value: 2
        orientation: Qt.Vertical
        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 50
        }
    }
}
