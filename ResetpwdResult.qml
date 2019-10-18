import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.3
Page {
    width: parent.width
    height:parent.height

    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100
        spacing: 25

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
              Image {
                   id: succimage
                   width: 48
                   height: 48
                   source: "image/chenggong.png"
                   anchors.verticalCenter: parent.verticalCenter
               }

        }

        Row{
           anchors.horizontalCenter: parent.horizontalCenter

               Text {
                   id: successful
                   text: qsTr("修改密码成功了！")
                   font.pixelSize: 16
                   anchors.verticalCenter: parent.verticalCenter
               }
        }

        Row{
           anchors.top: parent.top
           anchors.topMargin: 400
           anchors.horizontalCenter: parent.horizontalCenter
           Button {
                   id: button
                   anchors.horizontalCenter: parent.horizontalCenter
                   anchors.verticalCenter: parent.verticalCenter
                   Text {
                       anchors.centerIn: parent
                       id: next
                       color: "white"
                       text: qsTr("去登录")
                   }
                   background: Rectangle {
                       implicitWidth: 250
                       implicitHeight: 50
                       color:  "green"
                       border.color: button.down ? "red" : "#f6f6f6"
                       border.width: 1
                       radius: 4
                   }
                   onClicked: {
                       meStackView.push("SigninScreen.qml")
                   }
               }
         }
    }

}
