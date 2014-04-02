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
        var currentList = board.childAt(boardPosition.x, boardPosition.y);

        if (currentList !== null)
        {
            var currentListPosition = currentItem.mapToItem(currentList, mouse.x, mouse.y);
            var indexItem = currentList.indexAt(currentListPosition.x, currentListPosition.y);
            var item = currentList.itemAt(currentListPosition.x, currentListPosition.y);
            if (indexItem !== -1)
            {
                if (holder.list === currentList)
                {
                    console.log("same list");
                    if (holder.index !== indexItem)
                    {
                        currentList.model.move(holder.index, indexItem, 1);
                        currentList.currentIndex = indexItem;
                        holder.index = indexItem;
                    }
                }
                else if (currentList === holder.initialList)
                {
                    console.log("newList equals initialList");
                    currentList.currentItem.collapsed = false;
                    holder.list.model.remove(holder.index, 1);
                    holder.list.currentIndex = -1;
                    currentList.model.move(holder.initialList.currentIndexItem, indexItem, 1);
                    currentList.currentIndex = indexItem;
                    holder.index = indexItem;
                    holder.list = currentList;
//                    var modelItem = currentList.model.get(indexItem);
//                    holder.modelItem = modelItem;
                }
                else
                {
                    if (holder.list === holder.initialList)
                    {
                        console.log("previousList equals initialList");
                        holder.list.currentItem.collapsed = true;
                        currentList.model.insert(indexItem, holder.modelItem);
                        currentList.currentIndex = indexItem;
                        holder.index = indexItem;
                        holder.list = currentList;
                    }
                    else
                    {
                        console.log("other cases");
                        currentList.model.insert(indexItem, holder.modelItem);
                        holder.list.model.remove(holder.index, 1);
                        holder.list.currentIndex = -1;
                        currentList.currentIndex = indexItem;
                        holder.index = indexItem;
                        holder.list = currentList;
                    }
                }
            }
            else
            {
                if (currentList.count === 0)
                {
                    currentList.model.insert(0, holder.modelItem);
                    holder.list.model.remove(holder.index, 1);
                    holder.list.currentIndex = -1;
                    holder.index = 0;
                    holder.list = currentList;
                    currentList.currentIndex = 0;
                }
            }
        }
    }
}

function released(hidden)
{
    if (holder !== null)
    {
        holder.list.currentIndex = -1;
        holder = null;
        hidden.visible = false;
    }
}
