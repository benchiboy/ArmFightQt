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

    property  int  sign_in: 1
    property  int  play_card: 2
    property  int  send_msg: 3
    property  int  get_users: 4
    property  int  req_play: 5
    property  int  req_playok: 6

    property  int  playtimeout: 5
    property  int  timecount: playtimeout
    property var   command: { "type": 0, "userid": "" }

    function playCard(cardName,score){
        console.log("play card ===>",score)
        timecount=playtimeout
        if (role=="A"){
            playa.opacity=1
        }else{
            playb.opacity=1
        }

        command.type=play_card
        command.id="tim"
        command.messge=cardName
        command.score=score
        socket.sendTextMessage(JSON.stringify(command))

        lockTip.text=playtimeout
        cardtimer.start()
    }

    function shuffleCard(){
        console.log("shuffleCard ===>")
        playa.opacity=0
        playb.opacity=0
    }


    function signIn(id){
        console.log("User Signin....")
        command.type=sign_in
        command.userid=id
        command.nickname=id
        command.messge="signin"
        socket.sendTextMessage(JSON.stringify(command))
    }

    function sendMessage(messge,toid){
        console.log("User playCard....")
        command.type=send_msg
        command.id="tim"
        command.messge=cardName
        command.toid=toid
        socket.sendTextMessage(JSON.stringify(command))
    }

    function getUsers(){
        console.log("getUsers....")
        command.type=get_users
        socket.sendTextMessage(JSON.stringify(command))
    }

    function getUsersResult(message){
        console.log("getUsersResult....",message)
        console.log("playerModel=====",)
      //  playerModel.clear()
        var  msgObj=JSON.parse(message)
        for(var key in msgObj) {
            console.log(key, msgObj[key].id);
            playerModel.append( {"userId":msgObj[key].userid,"nickName":msgObj[key].nickname});
        }
    }

    function reqPlay(){
        console.log("reqPlay....")
        command.type=req_play
        command.id="tim"
        command.messge=cardName
        command.toid=toid
        socket.sendTextMessage(JSON.stringify(command))
    }

    function reqPlayOK(){
        console.log("reqPlayOK....")
        command.type=req_playok
        command.id="tim"
        command.messge=cardName
        command.toid=toid
        socket.sendTextMessage(JSON.stringify(command))
    }



    WebSocket {
       id: socket
       url: "ws://127.0.01:8080/echo"
       onTextMessageReceived: {
           console.log("textMessageRev",message)
           clockTip.text=message
           var recvMsg=JSON.parse(message)
           switch (recvMsg.type){
                case get_users:
                    getUsersResult(recvMsg.message);
                    break;
                case req_play:
                    break;
           }
           console.log("======>",recvMsg.type)
       }

       onStatusChanged: if (socket.status == WebSocket.Error) {
                            console.log("Error: " + socket.errorString)
                        } else if (socket.status == WebSocket.Open) {
                            console.log("socket connect")
                            signIn(userId.text)
                        } else if (socket.status == WebSocket.Closed) {
                            socket.active=false
                            console.log("socket closed")
                           // messageBox.text += "\nSocket closed"
                        }
       active: false
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

    TextField{
        id:userId
        y:20

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


   Item{
       id:userlist_id
       width: parent.width
       visible: false
       height: parent.height
       anchors.centerIn: parent
       z:2000
       Rectangle{
       anchors.centerIn: parent
       width: parent.width*0.9
       height: parent.height*0.8
           ListView {
               id: listView
               width: parent.width
               highlightRangeMode: ListView.StrictlyEnforceRange
               height:parent.height
               delegate: PlayerDelegate {
                   id: delegate
                   width: listView.width

                   MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            console.log("list view index===",listView.currentIndex)
                            userlist_id.visible=false

                          }
                   }
               }
               model: PlayerModel {
                   id: playerModel
               }
               ScrollBar.vertical: ScrollBar { }

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
               text: "找玩家"
               onClicked: {
                   userlist_id.visible=true
                   getUsers()

               }
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
                playCard("工兵","1")
            }
        }

        GButton {
            text: "排长"
            onClicked: {
                playCard("排长","2")
            }
        }

        GButton {
            text: "登录"
            onClicked: {
                console.log("hello")
                console.log("socket active====>",socket.active)
                if (socket.active==true){

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
