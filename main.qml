import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import "../js/gridcreator.js" as GridCreator

Window {
    id: root
    visible: true
    width: 1280
    height: 700
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
            scale: slider.value
            color: "grey"

            MouseArea {
                id: mouseArea
                focus: true
                anchors.fill: parent
                drag.target: gridContainer
                drag.axis: Drag.XAndYAxis
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                property Rectangle clickedTile
                property Rectangle startTile
                property Rectangle goalTile
                property bool isStartPlaced: false
                property bool isGoalPlaced: false
                property var wallsList: []
                onClicked: {
                    mouseArea.focus = true
                }

                onEntered: {
                    mouseArea.focus = true
                }

                Keys.onPressed: {
                    //Draw a wall
                    if (mouseArea.pressedButtons && Qt.LeftButton
                            && event.key == Qt.Key_W) {
                        mouseArea.drag.target = null
                        var position = mapToItem(gridContainer,
                                                 mouseArea.mouseX,
                                                 mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)
                        clickedTile.color = "black"
                        wallsList.push(clickedTile)
                        console.log(wallsList[0])
                    } //Draw a start
                    else if (isStartPlaced == false && mouseArea.pressedButtons
                             && Qt.LeftButton && event.key == Qt.Key_S) {
                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)
                        clickedTile.color = "red"
                        startTile = clickedTile
                        isStartPlaced = true
                    } //Draw a goal
                    else if (isGoalPlaced == false && mouseArea.pressedButtons
                             && Qt.LeftButton && event.key == Qt.Key_G) {
                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)
                        clickedTile.color = "blue"
                        goalTile = clickedTile
                        isGoalPlaced = true
                    } //Clear tile
                    else if (mouseArea.pressedButtons && Qt.RightButton
                             && event.key == Qt.Key_D) {
                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)

                        if (clickedTile.color == "#ff0000")
                            isStartPlaced = false
                        else if (clickedTile.color == "#0000ff")
                            isGoalPlaced = false
                        clickedTile.color = "gray"
                    }
                }

                Keys.onReleased: {
                    //Called when all buttons are released to make scrolling avaiable again
                    if (!(mouseArea.pressedButtons && Qt.LeftButton
                          && event.key == Qt.Key_W))
                        mouseArea.drag.target = gridContainer
                    else if (!(mouseArea.pressedButtons && Qt.RightButton
                               && event.key == Qt.Key_D))
                        mouseArea.drag.target = gridContainer
                }
            }
        }
    }

    Rectangle {
        id: menu
        height: 150
        width: 400
        opacity: 0.9
        color: "#606060"
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        Slider {
            id: slider
            value: 1
            from: 1
            to: 0.57
            anchors {
                bottom: parent.bottom
                right: parent.right
            }
            onValueChanged: {
                gridContainer.x = -root.width * (1 + slider.value)
                gridContainer.y = -root.height * (1 + slider.value)
                console.log(slider.value)
            }
        }
        Button {
            id: buttonStart
            height: 40
            width: 80
            text: "Start"
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 20
            }
        }
    }
}
