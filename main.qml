import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import "../js/gridcreator.js" as GridCreator

Window {
    id: root
    visible: true
    width: 800
    height: 600
    title: "AStar Visualization"

    Flickable {
        id: flickArea
        contentWidth: gridContainer.width
        contentHeight: gridContainer.height
        Component.onCompleted: GridCreator.createSpriteObjects()

        Rectangle {
            id: gridContainer
            width: 5000
            height: 5000
            color: "grey"

            MouseArea {
                id: mouseArea
                focus: true
                anchors.fill: parent
                drag.target: gridContainer
                drag.axis: Drag.XAndYAxis
                acceptedButtons: Qt.LeftButton
                property Rectangle clickedTile


                Keys.onPressed: {
                    //Draw a wall
                    if (mouseArea.pressedButtons && Qt.LeftButton && event.key == Qt.Key_W) {
                        mouseArea.drag.target = null
                        var position = mapToItem(gridContainer, mouseArea.mouseX, mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x, position.y)
                        clickedTile.color = "black"
                    }
                }

                Keys.onReleased: {
                    if (!(mouseArea.pressedButtons && Qt.LeftButton && event.key == Qt.Key_W))
                        mouseArea.drag.target = gridContainer
                }
            }
        }
    }
}
