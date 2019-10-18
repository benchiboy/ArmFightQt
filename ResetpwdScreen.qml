import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.3
Page {

    property  int     getIndex: 0
    property  string  problemAnswer: ""
    property  string  problem: ""

    function getUser() {
        console.log("========>>>>>>>>>>getUser>>>>>>>>>>>>=======")
        var authReq = new XMLHttpRequest;
        authReq.open("PUT", glServerUrl+"/army/api/getuser");
        authReq.setRequestHeader("Content-Type", "text/plain; charset=utf-8");
        authReq.setRequestHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        authReq.onreadystatechange = function() {
            if (authReq.readyState === XMLHttpRequest.DONE) {
                console.log(authReq.responseText)
                var jsonResponse = JSON.parse(authReq.responseText);
                if (jsonResponse.retcode != undefined){
                    console.log("Authentication error: " + jsonResponse.retcode)
                    console.log(jsonResponse.retcode)
                    if (jsonResponse.retcode!="0000"){
                         showMsgBox(nickName.text+"账户不存在")
                         return
                    }
                    resetPwdProblem.currentIndex=resetPwdProblem.find(jsonResponse.problem)
                    problemAnswer=jsonResponse.answer
                    problem=jsonResponse.problem
                    resetNextButton.visible=true
                    resetPwdProblem.visible=true
                    resetPwdAnswer.visible=true
                }
            }
        }
        var req={username:nickName.text}
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
                TextField {
                    id: nickName
                    placeholderText: qsTr("输入自己登录账号")
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
               Button {
                       id: button
                       Text {
                           anchors.centerIn: parent
                           id: next
                           color: "white"
                           text: qsTr("找回预留问题")
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
                          if (nickName.text==""){
                              showMsgBox("登录账号不能为空")
                             return
                          }
                          getUser()
                       }
                   }
            }
            Row{
               anchors.horizontalCenter: parent.horizontalCenter
               ComboBox {
                   id:resetPwdProblem
                   visible: false
                   currentIndex: 0
                   model: ListModel {
                       id: cbItems
                       ListElement { text: ""; }
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
            Row{
               anchors.horizontalCenter: parent.horizontalCenter
                TextField {
                    id: resetPwdAnswer
                    visible: false
                    placeholderText: qsTr("预留的答案")
                    background: Rectangle {
                        implicitWidth: 250
                        implicitHeight: 50
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
                       id: resetNextButton
                        visible: false
                       anchors.horizontalCenter: parent.horizontalCenter
                       anchors.verticalCenter: parent.verticalCenter
                       Text {
                           anchors.centerIn: parent
                           id: next1
                           color: "white"
                           text: qsTr("下一步")
                       }
                       background: Rectangle {
                           implicitWidth: 250
                           implicitHeight: 50
                           color:  "green"
                           border.color: resetNextButton.down ? "red" : "#f6f6f6"
                           border.width: 1
                           radius: 4
                       }
                       onClicked: {
                          if (nickName.text==""){
                             showMsgBox("登录账号不能为空")
                              return
                          }
                          if (resetPwdAnswer.text==""){
                              showMsgBox("预留的答案不能为空")
                              return
                          }
                          if (resetPwdProblem.textAt(resetPwdProblem.currentIndex)!==problem){
                              showMsgBox("预留的问题不对")
                              return
                          }
                          if (resetPwdAnswer.text!=problemAnswer){
                              showMsgBox("预留答案不正确")
                              return
                          }
                          meStackView.push("ResetpwdForm.qml",{userName:nickName.text,problem:problem,problemAnswer:resetPwdAnswer.text})
                       }
                   }
             }
          }
        }
