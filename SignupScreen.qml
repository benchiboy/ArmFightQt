import QtQuick 2.13
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.3
Page {
    width: parent.width
    height:parent.height

    function checkUser() {
        console.log("========>>>>>>>>>>checkUser>>>>>>>>>>>>=======")
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
                        if (jsonResponse.retcode=="0000"){
                             showMsgBox(nickName.text+" 已经被注册，起个新的昵称吧!")
                        }else{
                            meStackView.push("SignupForm.qml",{userName:nickName.text,userPwd:signupPwdok.text,userImage:userHeadImage.source})
                        }
                    }
            }
        }
        var req={username:nickName.text}
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

    Popup{
        id: headImageSel
        width: parent.width*0.8
        height: parent.height*0.4
        anchors.centerIn: parent
        Row{
            spacing: 30
            anchors.centerIn: parent
            Grid{
                rows: 3
                columns: 4
                spacing: 20

                HeadButton{
                    imageSource: "image/laoshu.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }
                HeadButton{
                    imageSource: "image/niu.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }


                HeadButton{
                    imageSource: "image/hu.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/tuzi.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/long.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/she.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }


                HeadButton{
                    imageSource: "image/ma.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/yang.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/houzi.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/ji.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }


                HeadButton{
                    imageSource: "image/gou.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
                     }
                }

                HeadButton{
                    imageSource: "image/zhu.png"
                    onClicked: {
                        headImageSel.close()
                        userHeadImage.source=imageSource
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
            Column{
                Rectangle{
                   width: 60
                   height: 60
                   border.color: "grey"
                   radius: 50
                   anchors.horizontalCenter: parent.horizontalCenter
                   Image {
                       anchors.fill: parent
                       anchors.margins: 10
                       id: userHeadImage
                       source: "image/user.png"
                       MouseArea{
                         anchors.fill: parent
                         onClicked: {
                            headImageSel.open()
                         }
                       }
                   }
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: userTip
                    text: qsTr("点击选择头像")
                    font.bold: true
                }
            }
        }

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
            TextField {
                id: nickName
                placeholderText: qsTr("起个昵称:如陈小明")
                maximumLength: 15
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
                placeholderText: qsTr("设置你的密码")
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
                placeholderText: qsTr("确认你的密码")
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
                       implicitHeight: 50
                       color:  "green"
                       border.color: button.down ? "red" : "#f6f6f6"
                       border.width: 1
                       radius: 4
                   }
                   onClicked: {

                       if (nickName.text==""){
                            showMsgBox("用户昵称不能为空")
                            return
                       }
                       if (signupPwd.text==""){
                            showMsgBox("必须设置登录密码")
                            return
                       }
                       if (signupPwdok.text==""){
                            showMsgBox("确认密码不能为空")
                            return
                       }

                       if (signupPwdok.text!=signupPwd.text){
                            showMsgBox("设置密码和确认密码不一致")
                            return
                       }

                       checkUser()

                   }
               }
         }
      }

}
