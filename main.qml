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
            color: "grey"
            property var currentTile
            MouseArea {
                id: mouseArea
                focus: true
                anchors.fill: parent
                drag.target: gridContainer
                drag.axis: Drag.XAndYAxis
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                property bool isStartPlaced: false
                property bool isGoalPlaced: false
                property Rectangle goalTile
                property Rectangle startTile
                drag.minimumX: root.width - gridContainer.width
                drag.maximumX: 0
                drag.minimumY: root.height - gridContainer.height
                drag.maximumY: 0
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
                        var clickedTile = gridContainer.childAt(position.x,
                                                                position.y)
                        clickedTile.color = "#000000"
                        if (ListManager.wallsList.indexOf(clickedTile) === -1)
                            ListManager.wallsList.push(clickedTile)
                    }
                    //Draw a start
                    else if (isStartPlaced == false && mouseArea.pressedButtons
                             && Qt.LeftButton && event.key === Qt.Key_S) {
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
                    else if (isGoalPlaced == false && mouseArea.pressedButtons
                             && Qt.LeftButton && event.key === Qt.Key_G) {

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
                    else if (mouseArea.pressedButtons && Qt.RightButton
                             && event.key === Qt.Key_D) {
                        mouseArea.drag.target = null
                        position = mapToItem(gridContainer, mouseArea.mouseX,
                                             mouseArea.mouseY)
                        clickedTile = gridContainer.childAt(position.x,
                                                            position.y)

                        if (clickedTile.color == "#ff0000") {
                            isStartPlaced = false
                            mouseArea.startTile = null
                        } else if (clickedTile.color == "#0000ff") {
                            isGoalPlaced = false
                            mouseArea.goalTile = null
                        }

                        ListManager.wallsList = arrayRemove(
                                    ListManager.wallsList, clickedTile)
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
        width: 300
        opacity: 0.9
        color: "#606060"
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        Button {
            id: buttonStart
            height: 50
            width: 80
            text: "Start"
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 20
                bottomMargin: 60
            }
            property bool isStartClicked: false
            property var startTime
            onClicked: {
                    if (mouseArea.goalTile == null){errorsText.text = "Goal tile\nmust be marked"}
                    else if (mouseArea.goalTile == null){errorsText.text = "Start tile\nmust be marked"}
                    else {
                        errorsText.text = ""
                        var foundWay = findWay()
                        isStartClicked = true
                        buttonStart.enabled = false
                        statusRect.visible = true
                        if (foundWay){
                           drawWay();
                           anim.start()
                           wayFound.visible = true
                        }
                        else if (!foundWay && isStartClicked){
                           anim.start()
                           wayNotFound.visible = true
                        }
                    }
            }
        }
        Text{
            id: errorsText
            font.pointSize: 16
            color: "white"
            anchors.left: buttonStart.right
            padding: 5
            anchors.leftMargin: 7
        }
    }

    Rectangle{
        id: statusRect
        opacity: 0.2
        height: root.height
        width: root.width
        color: "gray"
        visible: false
        SequentialAnimation on color {
            running: false
            id: anim
            loops: Animation.Infinite
            property int animDuration: 500
            ColorAnimation {
                from: "red"
                to: "yellow"
                duration: anim.animDuration
            }
            ColorAnimation {
                from: "yellow"
                to: "green"
                duration: anim.animDuration
            }
            ColorAnimation {
                from: "green"
                to: "blue"
                duration: anim.animDuration
            }
            ColorAnimation {
                from: "blue"
                to: "red"
                duration: anim.animDuration
            }

        }

    }
    Text{
        id: wayFound
        anchors.centerIn: parent
        font.pointSize: 36
        visible: false
        color: "white"
        text: 'Path was found!'
    }
    Text{
        id: wayNotFound
        anchors.centerIn: parent
        font.pointSize: 36
        opacity: 1
        color: "white"
        visible: false
        text: 'Path wasn\'t found! :('
    }

    function clearAll() {
        ListManager.wallsList.forEach(function (item, i, arr) {
            gridContainer.childAt(item.x, item.y).color = "gray"
        })

        ListManager.wallsList = new Array()

        gridContainer.childAt(mouseArea.goalTile.x,
                              mouseArea.goalTile.y).color = "gray"
        gridContainer.childAt(mouseArea.startTile.x,
                              mouseArea.startTile.y).color = "gray"
        mouseArea.goalTile = null
        mouseArea.startTile = null
        mouseArea.isStartPlaced = false
        mouseArea.isGoalPlaced = false
    }

    function calcHCost(tile) {
        return Math.round(Math.sqrt(Math.pow((mouseArea.goalTile.x - tile.x),
                                             2) + Math.pow(
                                        (mouseArea.goalTile.y - tile.y), 2)) * 10)
    }

    function calcFCost(tile) {
        return tile.gCost + tile.hCost
    }

    function lowestFCostTile(tilesList) {
        var minFCostTile = tilesList[0]
        tilesList.forEach(function (item, i, arr) {
            if (item.fCost < minFCostTile.fCost)
                minFCostTile = item
        })
        return minFCostTile
    }

    function calculateNeighboursCosts(current, parent) {
        return Math.round(Math.sqrt(Math.pow((parent.x - current.x),
                                             2) + Math.pow(
                                        (parent.y - current.y), 2)) * 10)
    }

    function compareTile(tile1, tile2) {
        return tile1.x == tile2.x && tile1.y == tile2.y
    }

    function arrayRemove(arr, value){

            return arr.filter(function(elem){
                return compareTile(value, elem);
            })
        }

    function sleep(ms) {
        ms += new Date().getTime()
        while (new Date() < ms) {

        }
    }

    function findWay() {

        var unMarkedTiles = new Array();
        var markedTiles = new Array();

        mouseArea.startTile.gCost = 0;
        mouseArea.startTile.hCost = calcHCost(mouseArea.startTile);
        mouseArea.startTile.fCost = calcFCost(mouseArea.startTile);
        unMarkedTiles.push(mouseArea.startTile);

        while (unMarkedTiles.length != 0) {


            var currentTile = lowestFCostTile(unMarkedTiles);

            if (compareTile(gridContainer.childAt(currentTile.x,
                                                  currentTile.y),
                            mouseArea.goalTile)) {
                return true;
            }


            var index = unMarkedTiles.indexOf(currentTile);
            unMarkedTiles.splice(index, 1);



            markedTiles.push(currentTile);

            for (var y = currentTile.y + GridCreator.cellSize; y > currentTile.y - GridCreator.cellSize * 2; y -= GridCreator.cellSize) {
                for (var x = currentTile.x - GridCreator.cellSize; x < currentTile.x + GridCreator.cellSize * 2; x += GridCreator.cellSize) {
                    var mapTile = gridContainer.childAt(x, y);

                    if ((x == currentTile.x && y == currentTile.y) || y >= GridCreator.height || x >= GridCreator.width || x < 0 || y < 0 || mapTile.color == "#000000")
                        continue;

                    var wayCost = mapTile.gCost + calculateNeighboursCosts(mapTile, currentTile);

                    if (markedTiles.indexOf(mapTile) != -1
                            || wayCost >= mapTile.gCost && mapTile.gCost != -1)
                        continue;

                    mapTile.parentX = currentTile.x;
                    mapTile.parentY = currentTile.y;
                    mapTile.gCost = wayCost;
                    mapTile.hCost = calcHCost(mapTile);
                    mapTile.fCost = calcFCost(mapTile);



                    if (!compareTile(mapTile, mouseArea.goalTile)) {
                        mapTile.mColor = 1;
                    }

                    if (unMarkedTiles.indexOf(mapTile) == -1){

                        unMarkedTiles.push(mapTile);
                    }

                }
            }
        }
        return false
    }

    function drawWay(){
        var currentTile = mouseArea.goalTile;
        var goalTile = mouseArea.goalTile;
        var startTile = mouseArea.startTile;

        while (!compareTile(currentTile, mouseArea.startTile)){
            if (!compareTile(currentTile, goalTile) && !compareTile(currentTile, startTile)){
                currentTile.mColor = 2;
            }
            else if (compareTile(currentTile, startTile)) return;
            currentTile = gridContainer.childAt(currentTile.parentX, currentTile.parentY);
        }
    }

}
