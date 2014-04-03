import QtQuick 2.1

import "../js/logic.js" as Logic

Rectangle {
    width: 640;  height: 480

    id: main

    Rectangle {
        anchors.fill: parent
        id: board
        color: "#222222"

        ListView {
            id: view1
            interactive: false
            x: 20
            y: 20
            width: 40
            height: Math.max(itemWidth * count, 40)

            property int itemWidth: 40

            currentIndex: -1

            model: ListModel {
                ListElement { colorCode: "red"; name: "1" }
                ListElement { colorCode: "blue"; name: "2" }
                ListElement { colorCode: "green"; name: "3" }
            }
            delegate: ListItem {
                width: view2.itemWidth
                height: 40
            }
        }

        ListView {
            id : view2
            interactive: false
            x: 200
            y: 20
            width: 40
            height: Math.max(itemWidth * count, 40)

            property int itemWidth: 40

            Rectangle {
                color: "white"
                anchors.fill: parent
                z: -1
            }

            currentIndex: -1

            model: ListModel {
                ListElement { colorCode: "red"; name: "4" }
                ListElement { colorCode: "blue"; name: "5" }
                ListElement { colorCode: "green"; name: "6" }
            }
            delegate: ListItem {
                width: view2.itemWidth
                height: 40
            }

        }

        MouseArea {
            id: moveArea

            property var holder: null
            parent: main
            anchors.fill: board
            onPressed: {
                Logic.handlePress(mouse, board, hidden, moveArea);
            }

            onPositionChanged: {
                Logic.positionChanged(mouse, board, hidden, moveArea);
            }

            onReleased: {
                Logic.released(hidden);
            }
        }
    }

    ListItem {
        id: hidden
        visible: false
        rotation: 10

        property var model
    }
}
