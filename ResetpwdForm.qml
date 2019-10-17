import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.3
Page {

    property  int  getIndex: 0
    property  string  userName:""
    property  string  problem:""
    property  string  problemAnswer:""

    function reset() {
        console.log("========>>>>>>>>>>reset>>>>>>>>>>>>=======")
        var authReq = new XMLHttpRequest;
        authReq.open("PUT", glServerUrl+"/army/api/resetpwd");
        authReq.setRequestHeader("Content-Type", "application/json");
        authReq.onreadystatechange = function() {
            if (authReq.readyState === XMLHttpRequest.DONE) {
                var jsonResponse = JSON.parse(authReq.responseText);
                if (jsonResponse.errors !== undefined){
                    console.log("Authentication error: " + jsonResponse.errors[0].message)

                }
                if (jsonResponse.retcode==="0000"){
                    meStackView.push("ResetpwdResult.qml",{userName:userName})
                 }
            }
        }
        var req={username:userName,newpwd:signupPwd.text,problem:problem,answer:problemAnswer}
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

    Item {
            width: parent.width
            height: parent.height
            Column{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            spacing: 25

            Row{
               anchors.horizontalCenter: parent.horizontalCenter
               Rectangle{
                   width: 48
                   height: 48
                   Image {
                       anchors.fill: parent
                       id: chengong
                       source: "image/chenggong.png"
                       anchors.verticalCenter:parent.verticalCenter
                   }
               }
            }

            Row{
               anchors.horizontalCenter: parent.horizontalCenter
               Text {
                    id: name111
                    font.bold: true
                    text: qsTr(userName+"回答问题正确，请设置新的登录密码")
               }
            }

            Row{
               anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id: signupPwd
                    placeholderText: qsTr("新的登录密码")
                    maximumLength: 10
                    echoMode: TextInput.Password
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
                    placeholderText: qsTr("确认新的密码")
                    maximumLength: 10
                    echoMode: TextInput.Password
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
                           text: qsTr("下一步")
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
                           if (signupPwd.text==""){
                                showMsgBox("新的登录密码不能空")
                                return
                           }
                           if (signupPwdok.text==""){
                                showMsgBox("确认新密码不能为空")
                                return
                           }

                           if (signupPwdok.text!=signupPwd.text){
                                showMsgBox("设置密码和确认密码不一致")
                                return
                           }
                           reset()
                       }
                   }
             }
          }
        }
    }

