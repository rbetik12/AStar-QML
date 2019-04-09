import QtQuick 2.12
import QtQuick.Window 2.12


Rectangle {
    width: 40
    height: 40
    color: "grey"
    border.color: "black"
    border.width: 2
    property int fCost: 0
    property int hCost: 0
    property int gCost: -1
    property int parentX: -1
    property int parentY: -1
    property int mColor: 0 // not green - 0; green - 1
    onMColorChanged:{
        if (mColor == 1){

            anim.start()
//            console.log(anim.)
            update()
        }
    }

    ColorAnimation on color{
        running: false
        id: anim
        to: "green"
        duration: 100
    }
    function sleep(ms) {
        ms += new Date().getTime();
        while (new Date() < ms){}
    }

}
