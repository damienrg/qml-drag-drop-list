import QtQuick 2.1

Item {
    id: item

    width: 40
    height: 40
    Rectangle {
        id: container
        width: 40
        height: 40

        color: colorCode

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: name
        }
    }

    MouseArea {
        id: moveArea

        property var clickPosition: { x: 0; y: 0 }
        property var itemPosition: { x: 0; y: 0 }

        property var holder: null
        anchors.fill: parent
        onPressed: {
            item.state = "selected";
            clickPosition = { x: mouseX, y: mouseY };
            var boardPosition = mapToItem(board, mouseX, mouseY);
            var currentList = board.childAt(boardPosition.x, boardPosition.y);
            var currentListPosition = mapToItem(currentList, mouseX, mouseY);
            var indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
            var temporary_element = { colorCode: "gray", name: "tmp" };
            holder = { list: currentList,
                element: currentList.model.get(indexItem),
                temporary_element: temporary_element,
                index: indexItem,
                initialList: currentList,
                initialIndex: indexItem
            };
            currentList.model.insert(indexItem, temporary_element);
        }

        onPositionChanged: {
            var boardPosition = mapToItem(board, mouseX, mouseY);
            var currentList = board.childAt(boardPosition.x, boardPosition.y);
            if (currentList !== null)
            {
                if (currentList.model !== null)
                {
                    var currentListPosition = mapToItem(currentList, mouseX, mouseY);
                    var indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
                    if (indexItem !== -1)
                    {
                        if (holder.list === currentList)
                        {
                            if (holder.index !== indexItem)
                            {
                                currentList.model.move(holder.index, indexItem, 1);
                                holder.index = indexItem;
                            }
                        }
                        else
                        {
                            holder.list.model.remove(holder.index, 1);
                            currentList.model.insert(indexItem, holder.temporary_element);
                            holder.index = indexItem;
                            holder.list = currentList;
                        }
                    }
                    else
                    {
                        if (currentList.count === 0)
                        {
                            holder.list.model.remove(holder.index, 1);
                            currentList.model.insert(0, holder.temporary_element);
                            holder.index = 0;
                            holder.list = currentList;
                        }
                    }
                }
            }
        }

        onReleased: {
            item.state = "";
            if (holder.list !== holder.initialList)
            {
                holder.list.model.set(holder.index, holder.element);
                holder.initialList.model.remove(holder.initialIndex, 1);
            }
            else
            {
                holder.initialList.model.set(holder.index, holder.element);
                if (holder.initialIndex > holder.index)
                    holder.initialList.model.remove(holder.initialIndex + 1, 1);
                else
                    holder.initialList.model.remove(holder.initialIndex, 1);
            }

            holder = null;
        }
    }

    states: State {
        name: "selected";
        PropertyChanges {
            target: container
            x: moveArea.mouseX - container.width / 2;
            y: moveArea.mouseY - container.height / 2;
            rotation: 10
        }
    }

}
