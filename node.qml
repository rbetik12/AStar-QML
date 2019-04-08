import QtQuick 2.0

Rectangle {
    id: tile
    width: 40
    height: 40
    color: "grey"
    border.color: "black"
    border.width: 2
    property bool isWall: false
    property int fCost: 0
    property int hCost: 0
    property int gCost: -1
    property int parentX: -1
    property int parentY: -1
}
