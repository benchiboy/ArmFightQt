import QtQuick 2.13
import QtQuick.Controls 2.13

Dialog {
    id: dialog
    function createContact() {
        dialog.open();
    }

    width:parent.width
    height:parent.height*0.6
    anchors.centerIn:parent


    focus: true
    modal: true
    contentItem: Rectangle {
        width: parent.width
        height: parent.height

        ListView {
            id: listView

            width: parent.width
            height:parent.height
            delegate: PlayerDelegate {
                id: delegate
                width: listView.width
            }
            model: PlayerModel {
                id: playerModel
            }
            ScrollBar.vertical: ScrollBar { }
        }


    }

}
