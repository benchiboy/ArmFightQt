import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.3
Page {

    property  int  getIndex: 0
    property  string  userName:""
    property  string  userPwd:""
    property  string  userImage:""

    function signup() {
        console.log("========>>>>>>>>>>signup>>>>>>>>>>>>=======")
        var authReq = new XMLHttpRequest;
        authReq.open("PUT", glServerUrl+"/army/api/signup");
        authReq.setRequestHeader("Content-Type", "application/json");
        authReq.onreadystatechange = function() {
            if (authReq.readyState === XMLHttpRequest.DONE) {
                    console.log(authReq.responseText)
                    var jsonResponse = JSON.parse(authReq.responseText);
                    if (jsonResponse.retcode != undefined){
                        console.log("Authentication error: " + jsonResponse.retcode)
                        console.log(jsonResponse.retcode)
                        if (jsonResponse.retcode=="0000"){
                            console.log("==============>")
                            meStackView.push("SignupResult.qml",{userImage:userImage,userName:userName})
                        }
                    }
            }
        }
        var req={username:userName,pwd:userPwd,problem:cbItems.get(getIndex).text,answer:resetPwdAnswer.text,headimage:userImage}
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
                          meStackView.pop()
                     }
                }
            }
        }
    }


    Column{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100
        spacing: 25

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                width: 60
                height: 60
                border.color: "grey"
                radius: 50
                Image {
                   anchors.fill: parent
                   anchors.margins: 10
                   id: name
                   source: userImage
               }
            }
        }

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
           Column{
               Text {
                   id: cbItemsTip
                   font.bold: true
                   text: qsTr("设置一个问题,用于找回密码！")
               }
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
                   onCurrentIndexChanged: {
                       getIndex=currentIndex
                   }
               }
           }
        }


        Row{
           anchors.horizontalCenter: parent.horizontalCenter
           Column{
               Text {
                   id: resetPwdAnswerTip
                   font.bold: true
                   text: qsTr("设置问题的答案!")
               }
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
                       if (resetPwdAnswer.text==""){
                            showMsgBox("问题答案不能为空")
                            return
                       }
                       signup()
                   }
               }
         }
      }

}
