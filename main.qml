import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import "../js/gridcreator.js" as GridCreator
import "../js/listmanager.js" as ListManager

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
                property bool isStartPlaced: false
                property bool isGoalPlaced: false
                property Rectangle goalTile;
                property Rectangle startTile;
                onClicked: {
                    mouseArea.focus = true
                }

                onEntered: {
                    mouseArea.focus = true
                }

                Keys.onPressed: {
                    //Draw a wall
                    if (mouseArea.pressedButtons && Qt.LeftButton
                            && event.key === Qt.Key_W) {
                        mouseArea.drag.target = null
                        var position = mapToItem(gridContainer,
                                                 mouseArea.mouseX,
                                                 mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)
                        clickedTile.color = "black"
                        if (ListManager.wallsList.indexOf(clickedTile) === -1)
                            ListManager.wallsList.push(clickedTile)
                    }

                    //Draw a start
                    else if (isStartPlaced == false
                    && mouseArea.pressedButtons && Qt.LeftButton
                            && event.key === Qt.Key_S) {
                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)
                        clickedTile.color = "red"
                        startTile = clickedTile
                        isStartPlaced = true
                    }

                    //Draw a goal
                    else if (isGoalPlaced == false
                    && mouseArea.pressedButtons && Qt.LeftButton
                            && event.key === Qt.Key_G) {

                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)

                        clickedTile.color = "blue"
                        goalTile = clickedTile
                        isGoalPlaced = true
                    }

                    //Clear tile
                    else if (mouseArea.pressedButtons
                    && Qt.RightButton && event.key === Qt.Key_D) {
                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)

                        if (clickedTile.color == "#ff0000"){
                            isStartPlaced = false
                            mouseArea.startTile = null
                        }
                        else if (clickedTile.color == "#0000ff"){
                            isGoalPlaced = false
                            mouseArea.goalTile = null
                        }

                        ListManager.remove(clickedTile)
                        clickedTile.color = "gray"
                    }
                }

                Keys.onReleased: {
                    //Called when all buttons are released to make scrolling avaiable again
                    if (!(mouseArea.pressedButtons && Qt.LeftButton
                          && event.key === Qt.Key_W))
                        mouseArea.drag.target = gridContainer
                    else if (!(mouseArea.pressedButtons && Qt.RightButton
                               && event.key === Qt.Key_D))
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
            onClicked:{
                findWay();
            }
        }
        Button {
            id: showWallsList
            height: 40
            width: 80
            text: "Show list"
            anchors {
                left: parent.left
                bottom: buttonStart.top
                margins: 20
            }
            onClicked: {
                console.log(ListManager.wallsList.length)
            }
        }
      }
    function findWay(){
        var unMarkedTiles = new Array();
        var markedTiles = new Array();

        mouseArea.startTile.gCost = 0;
        mouseArea.startTile.hCost = calcHCost(mouseArea.startTile);
        mouseArea.startTile.fCost = calcFCost(mouseArea.startTile);
        unMarkedTiles.push(mouseArea.startTile);

        while(unMarkedTiles.length != 0){
            var currentTile = lowestFCostTile(unMarkedTiles);

            if (mouseArea.childAt(currentTile.x, currentTile.y) === mouseArea.goalTile){
                return;
            }

            unMarkedTiles = unMarkedTiles.splice(unMarkedTiles.indexOf(currentTile), 1);
            currentTile.color = "#f74545";
            markedTiles.push(currentTile);
            break;
        }
    }

    function calcHCost(tile){
        return Math.round(Math.sqrt(Math.pow((mouseArea.goalTile.x - tile.x),2) + Math.pow((mouseArea.goalTile.y - tile.y),2)));
    }

    function calcFCost(tile){
        return tile.gCost + tile.hCost;
    }

    function lowestFCostTile(tilesList){
        var minFCostTile = tilesList[0];
        tilesList.forEach(function(item, i, arr){
            if (item.fCost < minFCostTile.fCost)
                minFCostTile = item;
        })
        return minFCostTile;
    }
}
