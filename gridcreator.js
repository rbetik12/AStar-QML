var component;
var sprite;
var width = 5000;
var height = 5000;
var cellSize = 40;

var forHeight = height
var forWidth = width

function createSpriteObjects() {
    component = Qt.createComponent("../node.qml");


    if (component.status == Component.Ready) {
        for (var y = 0; y < forHeight; y += cellSize) {
            for (var x = 0; x < forWidth; x += cellSize) {
                sprite = component.createObject(gridContainer, {
                                                    "x": x,
                                                    "y": y,
                                                    "id": x+y
                                                });
                if (sprite == null)
                    console.log("Error in creating sprite");
            }
        }
    }

}
