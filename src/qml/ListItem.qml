import QtQuick 2.1

Item {
    id: item

    width: parent.width

    property bool collapsed: false

    Rectangle {
        id: container
        anchors.fill: parent

        color: model ? model.colorCode : ""

        Text {
            id: text
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: model ? model.name : ""
        }
    }

    states: [
        State {
            name: "collapsed"
            when: item.collapsed
            PropertyChanges {
                target: item
                height: 0
            }
            PropertyChanges {
                target: container
                height: 0
            }
            PropertyChanges {
                target: text
                text: ""
            }
        },
        State {
            name: "selected";
            when: item.ListView.isCurrentItem
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
