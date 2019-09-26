import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
    width: parent.width
    height:parent.height

    Rectangle {
        anchors.fill: parent
    }
    header: Label {
        BorderImage {
            border.bottom: 8
            source: "image/toolbar.png"
            width: parent.width
            height: 50
            Rectangle {
                id: backButton
                width: 40
                anchors.left: parent.left
                anchors.leftMargin: 1
                anchors.verticalCenter: parent.verticalCenter
                height: 40
                radius: 4
                color: backmouse.pressed ? "#222" : "transparent"
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "image/navigation_previous_item.png"
                }

                MouseArea {
                    id: backmouse
                    anchors.fill: parent
                    anchors.margins: -10
                    onClicked: {

                     }
                }
            }
        }
    }

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        Row{
           anchors.top: parent.top
           anchors.topMargin: 150
           anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: control
                placeholderText: qsTr("输入登录手机")
                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 40
                    color: control.enabled ? "transparent" : "#353637"
                    border.color: control.enabled ? "#21be2b" : "transparent"
                }
            }
        }


        Row{
           anchors.top: parent.top
           anchors.topMargin: 260
           anchors.horizontalCenter: parent.horizontalCenter
           Button {
                   id: button
                   anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenter: parent.verticalCenter
                   Text {
                       anchors.centerIn: parent
                       id: name
                       color: "white"
                       text: qsTr("下一步")
                   }
                   background: Rectangle {
                       implicitWidth: 200
                       implicitHeight: 40
                       color:  "green"
                       border.color: button.down ? "red" : "#f6f6f6"
                       border.width: 1
                       radius: 4
                   }
                   onClicked: {
                          meStackView.push("SignUpDo.qml")
                   }
               }
        }




      }



}
