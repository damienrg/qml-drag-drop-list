.pragma library

var holder = null;

function handlePress(mouse, board, hidden, currentItem)
{
    var boardPosition = currentItem.mapToItem(board, mouse.x,mouse.y);
    var currentList = board.childAt(boardPosition.x, boardPosition.y);
    if (currentList !== null)
    {
        var listPosition = currentItem.mapToItem(currentList, mouse.x, mouse.y);
        var currentListPosition = currentItem.mapToItem(currentList, mouse.x, mouse.y);
        var indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
        var item = currentList.itemAt(currentListPosition.x, currentListPosition.y);
        if (item !== null)
        {
            var currentItemPosition = currentItem.mapToItem(item, mouse.x, mouse.y);
            var modelItem = currentList.model.get(indexItem);
            holder = {
                initialList: currentList,
                list: currentList,
                index: indexItem,
                modelItem: modelItem,
                clickInItemPosition: currentItemPosition
            };
            currentList.currentIndex = indexItem;
            hidden.width = item.width;
            hidden.height = item.height;
            hidden.model = modelItem;
            hidden.visible = true;
            hidden.x = boardPosition.x - currentItemPosition.x;
            hidden.y = boardPosition.y - currentItemPosition.y;
        }
    }
}

function positionChanged(mouse, board, hidden, currentItem)
{
    if (holder !== null)
    {
        var boardPosition = currentItem.mapToItem(board, mouse.x, mouse.y);
        hidden.x = boardPosition.x - holder.clickInItemPosition.x;
        hidden.y = boardPosition.y - holder.clickInItemPosition.y;
        var newList = board.childAt(boardPosition.x, boardPosition.y);

        if (newList !== null)
        {
            var currentListPosition = currentItem.mapToItem(newList, mouse.x, mouse.y);
            var indexItem = newList.indexAt(currentListPosition.x, currentListPosition.y);
            var item = newList.itemAt(currentListPosition.x, currentListPosition.y);
            if (indexItem !== -1)
            {
                if (holder.list === newList)
                {
                    console.log("same list");
                    if (holder.index !== indexItem)
                    {
                        newList.model.move(holder.index, indexItem, 1);
                        newList.currentIndex = indexItem;
                        holder.index = indexItem;
                    }
                }
                else if (newList === holder.initialList)
                {
                    console.log("newList equals initialList");
                    print("name currentIndex = " + newList.model.get(newList.currentIndex).name);
                    print("name initialList = " + holder.initialList.model.get(holder.initialList.currentIndex).name);
                    newList.currentItem.collapsed = false;
                    newList.model.move(holder.initialList.currentIndex, indexItem, 1);
                    newList.currentIndex = indexItem;
                    holder.list.currentIndex = -1;
                    holder.list.model.remove(holder.index, 1);
                    holder.index = indexItem;
                    holder.list = newList;
                    var modelItem = newList.model.get(indexItem);
                    holder.modelItem = modelItem;
                }
                else
                {
                    if (holder.list === holder.initialList)
                    {
                        console.log("previousList equals initialList");
                        console.log(holder.list.model.get(holder.list.currentIndex).name);
                        holder.list.currentItem.collapsed = true;
                        holder.initialList.currentIndex = holder.list.currentIndex;
                        newList.model.insert(indexItem, holder.modelItem);
                        newList.currentIndex = indexItem;
                        holder.index = indexItem;
                        holder.list = newList;
                    }
                    else
                    {
                        console.log("other cases");
                        newList.model.insert(indexItem, holder.modelItem);
                        holder.list.currentIndex = -1;
                        holder.list.model.remove(holder.index, 1);
                        newList.currentIndex = indexItem;
                        holder.index = indexItem;
                        holder.list = newList;
                    }
                }
            }
            else
            {
                if (newList.count === 0)
                {
                    newList.model.insert(0, holder.modelItem);
                    // TODO collapsed or remove
//                    holder.list.currentIndex = -1;
//                    holder.list.model.remove(holder.index, 1);
                    holder.index = 0;
                    holder.list = newList;
                    holder.list.currentIndex = 0;
                }
            }
        }
    }
}

function released(hidden)
{
    if (holder !== null)
    {
        if (holder.list !== holder.initialList)
        {
            print("collapsed = " + holder.initialList.currentItem.collapsed);
            holder.initialList.model.remove(holder.initialList.currentIndex);
            holder.initialList.currentIndex = -1;
        }
        holder.list.currentIndex = -1;
        holder = null;
        hidden.visible = false;
    }
}
