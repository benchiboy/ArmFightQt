import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtWebSockets 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 320
    height: 600
    title: qsTr("Stack")
    SystemPalette { id: activePalette }

    property  int  playtimeout: 5
    property  int  timecount: playtimeout
    property var   command: { "type": 1, "id": "00001","message":"hello","score":0 }

    function playCard(role,scoreVal){
        console.log("play card ===>",scoreVal)
        timecount=playtimeout
        if (role=="A"){
            playa.opacity=1
        }else{
            playb.opacity=1
        }
        clockTip.text=playtimeout
        cardtimer.start()
    }

    function shuffleCard(){
        console.log("shuffleCard ===>")
        playa.opacity=0
        playb.opacity=0
    }


    WebSocket {
       id: socket
       url: "ws://127.0.01:8080/echo"
       onTextMessageReceived: {
           console.log("textMessageRev")
       }

       onStatusChanged: if (socket.status == WebSocket.Error) {
                            console.log("Error: " + socket.errorString)
                        } else if (socket.status == WebSocket.Open) {
                            console.log("send message")

                            socket.sendTextMessage(JSON.stringify(command))
                            console.log(JSON.stringify(command))
                        } else if (socket.status == WebSocket.Closed) {
                            socket.active=false
                            messageBox.text += "\nSocket closed"
                        }
       active: false
     }

    function signIn(){



    }


    Image {
        source:"/image/background.png"
    }

    Text {
        id: clockTip
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 25
        font.bold: true
        color: "red"
        text:""
    }

    Timer{
      id:cardtimer
      interval: 1000; running: false; repeat: true
      onTriggered:{
          console.log(timecount)
          if (timecount>0){
               timecount=timecount-1
               clockTip.text=timecount
          }else{
            //超时情况
               cardtimer.stop()
               shuffleCard()
          }
      }
    }


    Rectangle{
        width: parent.width*0.9
        height: parent.height*0.2
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        color: "grey"
        RowLayout{
            anchors.centerIn:  parent
            spacing: 50
            GButton {
               id:playa
               opacity: 0
               text: "玩家A"
            }
            GButton {
                id:playb
                opacity: 0
                text: "玩家B"
            }
        }
    }


   Rectangle{
        width: parent.width*0.9
        height: parent.height*0.1
        color: "transparent"
        anchors.top: parent.top
        anchors.topMargin: 200
        anchors.horizontalCenter: parent.horizontalCenter
        RowLayout{
            anchors.centerIn:  parent
            spacing: 50
            GButton {
               id:todoplay
               text: "我求战"
            }
            GButton {
                id:ifailed
                text: "我认输"
            }
        }
    }





    Rectangle{
        width: parent.width*0.8
        height: parent.height*0.3
        anchors.top: parent.top
        anchors.topMargin: 350
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        GridLayout{
        anchors.fill: parent
        anchors.centerIn: parent
        columns: 4
        rows: 4
        columnSpacing: 10
        rowSpacing: 1

        GButton {
           text: "工兵"
            onClicked: {
                console.log("hello111111")
                playCard("A","1")
            }
        }

        GButton {
            text: "排长"
            onClicked: {
                playCard("B","1")
            }
        }

        GButton {
            text: "连长"
            onClicked: {
                console.log("hello")
                console.log("socket active====>",socket.active)
                if (socket.active==true){
                   socket.sendTextMessage(JSON.stringify(command))
                }else{
                    socket.active=true
                }
            }
        }

        GButton {
            text: "营长"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "团长"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "旅长"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "师长"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "军长"
            onClicked: {
                console.log("hello")
            }
        }
        GButton {
            text: "司令"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "炸弹"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "地雷"
            onClicked: {
                console.log("hello")
            }
        }

        GButton {
            text: "军旗"
            onClicked: {
                console.log("hello")
            }
        }
    }
    }


}
