import QtQuick 2.1

Rectangle {
    width: 640;  height: 480

    id: main

    Rectangle {
        anchors.fill: parent
        id: board
        color: "#222222"

        ListView {
            interactive: false
            x: 20
            y: 20
            width: 40
            height: Math.max(childrenRect.height, 40)
            model: ListModel {
                ListElement { colorCode: "red"; name: "1" }
                ListElement { colorCode: "blue"; name: "2" }
                ListElement { colorCode: "green"; name: "3" }
            }
            delegate: ListItem {
                property int listIndex: 1
            }
        }

        ListView {
            interactive: false
            x: 200
            y: 20
            width: 40
            height: Math.max(childrenRect.height, 40)
            model: ListModel {
                ListElement { colorCode: "red"; name: "4" }
                ListElement { colorCode: "blue"; name: "5" }
                ListElement { colorCode: "green"; name: "6" }
            }
            delegate: ListItem {
                property int listIndex: 2
            }
        }

        MouseArea {
            id: moveArea

            property var clickPosition: { x: 0; y: 0 }
            property var itemPosition: { x: 0; y: 0 }

            property int listIndex: -1
            property int itemIndex: -1

            property var holder: null
            parent: main
            anchors.fill: board
            onPressed: {
                clickPosition = { x: mouseX, y: mouseY };
                var boardPosition = mapToItem(board, mouseX, mouseY);
                var currentList = board.childAt(boardPosition.x, boardPosition.y);
                if (currentList !== null)
                {
                    var listPosition = mapToItem(currentList, mouseX, mouseY);
                    var currentListPosition = mapToItem(currentList, mouseX, mouseY);
                    var indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
                    var item = currentList.itemAt(currentListPosition.x, currentListPosition.y);
                    if (item !== null)
                    {
                        var currentItemPosition = mapToItem(item, mouseX, mouseY);
                        var modelItem = currentList.model.get(indexItem);
                        holder = {
                            list: currentList,
                            index: indexItem,
                            modelItem: modelItem,
                            clickInItemPosition: currentItemPosition
                        };
                        itemIndex = indexItem;
                        listIndex = item.listIndex;
                        hidden.width = item.width;
                        hidden.height = item.height;
                        hidden.color = modelItem.colorCode;
                        hidden.name = modelItem.name;
                        hidden.visible = true;
                        hidden.x = boardPosition.x - currentItemPosition.x;
                        hidden.y = boardPosition.y - currentItemPosition.y;
                    }
                }
            }

            onPositionChanged: {
                if (holder !== null)
                {
                    var boardPosition = mapToItem(board, mouseX, mouseY);
                    hidden.x = boardPosition.x - holder.clickInItemPosition.x;
                    hidden.y = boardPosition.y - holder.clickInItemPosition.y;
                    var currentList = board.childAt(boardPosition.x, boardPosition.y);

                    if (currentList !== null)
                    {
                        var currentListPosition = mapToItem(currentList, mouseX, mouseY);
                        var indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
                        var item = currentList.itemAt(currentListPosition.x, currentListPosition.y);
                        if (indexItem !== -1)
                        {
                            if (holder.list === currentList)
                            {
                                if (holder.index !== indexItem)
                                {
                                    currentList.model.move(holder.index, indexItem, 1);
                                    holder.index = indexItem;
                                    itemIndex = indexItem;
                                }
                            }
                            else
                            {
                                currentList.model.insert(indexItem, holder.modelItem);
                                var modelItem = currentList.model.get(indexItem);
                                holder.modelItem = modelItem;
                                holder.list.model.remove(holder.index, 1);
                                indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
                                item = currentList.itemAt(currentListPosition.x, currentListPosition.y);


                                holder.index = indexItem;
                                holder.list = currentList;
                                itemIndex = indexItem;
                                listIndex = item.listIndex;
                            }
                        }
                        else
                        {
                            if (currentList.count === 0)
                            {
                                holder.list.model.remove(holder.index, 1);
                                currentList.model.insert(0, holder.modelItem);
                                holder.modelItem = currentList.model.get(0);
                                holder.index = 0;
                                holder.list = currentList;
                                itemIndex = 0;
                                listIndex = currentList.itemAt(currentListPosition.x, currentListPosition.y).listIndex;
                            }
                        }
                    }
                }
            }

            onReleased: {
                holder = null;
                hidden.visible = false;
                itemIndex = -1;
                listIndex = -1;
            }
        }
    }

    Rectangle {
        id: hidden
        visible: false
        rotation: 10

        property string name: ""

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: hidden.name
        }
    }
}
