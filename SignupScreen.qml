import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.3
Page {
    width: parent.width
    height:parent.height



    function signup() {
        console.log("========>>>>>>>>>>signup>>>>>>>>>>>>=======")
        var authReq = new XMLHttpRequest;
        authReq.open("POST", "http://127.0.0.1:9080/army/api/signup");
        authReq.setRequestHeader("Content-Type", "application/json");
        authReq.onreadystatechange = function() {
            if (authReq.readyState === XMLHttpRequest.DONE) {
                    console.log(authReq.responseText)
                    var jsonResponse = JSON.parse(authReq.responseText);
                    if (jsonResponse.errors !== undefined)
                        console.log("Authentication error: " + jsonResponse.errors[0].message)
                    else{
                        console.log(jsonResponse.err_code)
                    }
            }

        }
        var req={username:"idKey",pwd:"23232323",problem: "232323",answer:"2222"}
        console.log(JSON.stringify(req))
        authReq.send(JSON.stringify(req));
        return true
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
        anchors.top: parent.top
        anchors.topMargin: 60
        spacing: 15

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
               width: 48
               height: 48
               border.color: "red"
               radius: 5
               Image {
                   anchors.fill: parent
                   id: name
                   source: "image/user.png"
               }
            }
        }
        Row{
           anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: nickName
                placeholderText: qsTr("输入自己的昵称")
                background: Rectangle {
                    implicitWidth: 250
                    implicitHeight: 40
                    radius: 10
                    color: nickName.enabled ? "transparent" : "#353637"
                    border.color: nickName.enabled ? "#21be2b" : "transparent"
                }
            }
        }

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: signupPwd
                placeholderText: qsTr("登录密码")
                background: Rectangle {
                    implicitWidth: 250
                    implicitHeight: 40
                    radius: 10
                    color: signupPwd.enabled ? "transparent" : "#353637"
                    border.color: signupPwd.enabled ? "#21be2b" : "transparent"
                }
            }
        }

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: signupPwdok
                placeholderText: qsTr("确认密码")
                background: Rectangle {
                    implicitWidth: 250
                    implicitHeight: 40
                    radius: 10
                    color: signupPwdok.enabled ? "transparent" : "#353637"
                    border.color: signupPwdok.enabled ? "#21be2b" : "transparent"
                }
            }
        }

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
           ComboBox {
               id:resetPwdProblem
               currentIndex: 0
               model: ListModel {
                   id: cbItems
                   ListElement { text: "你的手机号码"; }
                   ListElement { text: "你的小学名称";  }
                   ListElement { text: "你的生日";  }
               }
               implicitWidth: 250
               implicitHeight: 40
               background: Rectangle{
                   radius: 10
                   color: resetPwdProblem.enabled ? "transparent" : "#353637"
                   border.color: resetPwdProblem.enabled ? "#21be2b" : "transparent"
               }
               onCurrentIndexChanged: console.debug(cbItems.get(currentIndex).text + ", " + cbItems.get(currentIndex).color)
           }
        }


        Row{
           anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: resetPwdAnswer
                placeholderText: qsTr("问题答案")
                background: Rectangle {
                    implicitWidth: 250
                    implicitHeight: 40
                    radius: 10
                    color: resetPwdAnswer.enabled ? "transparent" : "#353637"
                    border.color: resetPwdAnswer.enabled ? "#21be2b" : "transparent"
                }
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
                       text: qsTr("确定")
                   }
                   background: Rectangle {
                       implicitWidth: 250
                       implicitHeight: 40
                       color:  "green"
                       border.color: button.down ? "red" : "#f6f6f6"
                       border.width: 1
                       radius: 4
                   }
                   onClicked: {
                       signup()
                   }
               }
         }
      }

}
