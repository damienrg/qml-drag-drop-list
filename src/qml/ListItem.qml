import QtQuick 2.1

Item {
    id: item

    width: parent.width
    height: 40

    state: {
        return (moveArea.itemIndex === index && moveArea.listIndex === listIndex) ? "selected" : "";
    }

    Rectangle {
        id: container
        width: 40
        height: 40

        color: colorCode ? colorCode : "white"

        Text {
            id: text
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: name ? name : ""
        }
    }

    states: [
        State {
            name: "selected";
            PropertyChanges {
                target: container
                color: "gray"
            }
            PropertyChanges {
                target: text
                text: ""
            }
        }
    ]
}
