import QtQuick 2.1

Rectangle {
    width: 640;  height: 480
    color: "#222222"

    id: board

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
        delegate: ListItem { }
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
        delegate: ListItem { }
    }
}
