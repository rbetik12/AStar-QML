var wallsList = new Array();

function pushInWallsList(wallRect){
    wallsList.push(wallRect);
}

function printWallsList(){
    wallsList.forEach(function(item, i, arr){console.log(item.x + " " + item.y)});
}

function deleteInWallsList(wallRect){
    wallsList.delete(wallRect);
}

function remove(wallRect){
    var indexOfTile = wallsList.indexOf(wallRect)
    wallsList = wallsList.splice(indexOfTile, 1)
}
