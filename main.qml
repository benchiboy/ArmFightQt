import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtWebSockets 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.13
import QtQuick.Particles 2.0


ApplicationWindow {
    id: window
    visible: true
    width: 320
    height: 600
    title: qsTr("Stack")
    SystemPalette { id: activePalette }


    property bool gameOver: true
    property int score: 0
    property int highScore: 0
    property int moves: 0
    property string mode: ""
    //property ParticleSystem ps: particleSystem

    property  int  sign_in: 1
    property  int  play_card: 1001
    property  int  play_card_resp: 2001
    property  int  query_result: 1012
    property  int  query_result_resp: 2012
    property  int  send_msg: 1003
    property  int  send_msg_resp: 2003
    property  int  get_users: 1004
    property  int  get_users_resp: 2004
    property  int  req_play: 1005
    property  int  req_play_resp: 2005
    property  int  req_playyes: 1006
    property  int  req_playyes_resp: 2006
    property  int  req_playno: 1010
    property  int  req_playno_resp: 2010
    property  int  playtimeout: 5
    property  int  timecount: playtimeout

    property  bool  bplay_card: false

    property  string  currUser:""
    property  string  otherUser:""
    property var   command: { "type": 0, "userid": "" }

    function playCard(fromId,toId,message,score){
        console.log("========>play card ===>",score)

        if (!bplay_card){
            console.log("wait a another paly....")
            return
        }

        command.type=play_card
        command.fromid=fromId
        command.message=message
        command.toid=toId
        command.score=score
        console.log("send========>playcard======>",JSON.stringify(command))
        socket.sendTextMessage(JSON.stringify(command))
    }


    function queryResult(fromId,toId){
        console.log("========>queryResult ===>")
        command.type=query_result
        command.fromid=fromId
        command.message="query result..."
        command.toid=toId
        console.log("send========>queryResult======>",JSON.stringify(command))
        socket.sendTextMessage(JSON.stringify(command))
    }


    function shuffleCard(){
        console.log("shuffleCard ===>")
        playa.opacity=0
        playb.opacity=0
    }


    function signIn(id){
        console.log("User Signin....")
        currUser=id
        command.type=sign_in
        command.userid=Math.random(100)
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
        playerModel.clear()
        var  msgObj=JSON.parse(message)
        console.log(msgObj)
        for(var key in msgObj) {
            console.log(key, msgObj[key].status);
            playerModel.append( {"userId":msgObj[key].userid,
                                 "nickName":msgObj[key].nickname,
                                 "decoration":msgObj[key].decoration
                               });
        }
    }

    function reqPlay(fromId,toId){
        console.log("reqPlay....")
        command.type=req_play
        command.fromid=fromId
        command.messge="request play a game"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function reqPlayYes(fromId,toId){
        console.log("reqPlayOK....")
        command.type=req_playyes
        command.fromid=fromId
        command.messge="好的，一起玩吧"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function reqPlayNo(fromId,toId){
        console.log("reqPlayNo....")
        command.type=req_playno
        command.fromid=fromId
        command.messge="他拒绝了你的请求"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    MessageDialog {
        id: playconfirm
        title: "提示?"
        icon: StandardIcon.Question
        text: otherUser+"请求和你杀一局?"
        standardButtons: StandardButton.Yes |
            StandardButton.No
        Component.onCompleted: visible = false
        onYes: {
                console.log("copied")
                reqPlayYes(currUser,otherUser)
               }
        onNo: {
                console.log("didn't copy")
                 reqPlayNo(currUser,otherUser)
             }
    }

    WebSocket {
       id: socket
       url: "ws://127.0.01:8080/echo"
       onTextMessageReceived: {
           console.log("textMessageRev",message)
           var recvMsg=JSON.parse(message)
           clockTip.text=recvMsg.message
           switch (recvMsg.type){
                case get_users_resp:
                    console.log("Recv get_users_resp=======........")
                    getUsersResult(recvMsg.message);
                    break;
                case req_play:
                    otherUser=recvMsg.fromid
                    console.log("Recv req play........")
                    playconfirm.visible=true
                    break;
                case req_play_resp:
                    console.log("Recv req_play_resp........")
                    break;
                case req_playyes:
                    otherUser=recvMsg.fromid
                    //发起方先出
                    play_curruser_area.border.color="red"

                     bplay_card=true

                    console.log("===========>recv play req_playyes")
                    break;

                case req_playyes_resp:
                    console.log("===========>recv play req_playyes_respreq_playyes_resp")
                    //主先出牌
                    play_otheruser_area.border.color="red"

                    break;
                case req_playno:
                    otherUser=recvMsg.fromid
                    console.log("recv play req_playno")
                case req_playno_resp:
                    otherUser=recvMsg.fromid
                    console.log("recv play req_playno_resp")
                    break;
                case play_card:
                    otherUser=recvMsg.fromid
                    console.log("recv play_card ",)

                    if (recvMsg.role=="M"){
                        play_otheruser.opacity=1
                        play_otheruser.text="未知"
                    }else{
                        //另一玩家收到牌
                        play_otheruser.opacity=1
                        play_otheruser.text="未知"
                    }
                     //显示下一步谁出牌
                     play_otheruser_area.border.color="transparent"
                     play_curruser_area.border.color="red"

                     bplay_card=true

                    break;
                case play_card_resp:
                    console.log("recv play_card_resp ",recvMsg.role)
                     //显示下一步谁出牌
                     play_curruser_area.border.color="transparent"
                     play_otheruser_area.border.color="red"

                    bplay_card=false

                    if ( recvMsg.role=="M"){
                        play_curruser.opacity=1
                        play_curruser.text=recvMsg.message
                    }else{
                        play_curruser.opacity=1
                        play_curruser.text=recvMsg.message
                        //开始触发从服务器查询大小
                        resultTimer.running=true
                    }
                    break;

                case query_result_resp:
                    console.log("query_result_resp ",recvMsg.message)
                    if (recvMsg.status=="E"){
                        console.log("GAME OVER........")
                    }
                    play_otheruser.text=recvMsg.message
                    clearTimer.running=true
                    break;
                default:
                    console.log("================>")
           }

       }

       onStatusChanged: if (socket.status == WebSocket.Error) {
                            console.log("Error: " + socket.errorString)
                        } else if (socket.status == WebSocket.Open) {
                            console.log("socket connected successful!")
                            signIn(userId.text)
                        } else if (socket.status == WebSocket.Closed) {
                            socket.active=false
                            console.log("socket closed")
                           // messageBox.text += "\nSocket closed"
                        }
       active: false
     }



    Image {
        source:"/image/background1.png"
    }

    Text {
        id: clockTip
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 25
        font.bold: true
        color: "red"
        text:""
    }


     Popup {
            id: popup
            anchors.centerIn: parent
            width: parent.width; height: parent.height
            z: 101
            opacity: 0.9
            visible: true;
            Image {
                source: "image/background.png"
                anchors.fill: parent
            }
            LogoAnimation {
                x: 30
                y: 20
            }
            Row {
                x: 80
                y: 20
                Image { source: "image/logo-a.png" }
                Image { source: "image/logo-m.png" }
                Image { source: "image/logo-e.png" }
            }
            Column{
                anchors.centerIn: parent
                spacing: 30
                TextField{
                    id:userId
                    focus: true
                    placeholderText: "输入你的名称"
                }
                GButton {
                    id:signin
                    width: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "登录"
                    onClicked: {
                        if (socket.active==false){
                            socket.active=true
                            signIn(userId.text)
                            popup.close()
                        }else{

                        }
                    }
                }

            }
         }

    Timer{
      id: resultTimer
      interval: 800; running: false; repeat: true
      onTriggered:{
          console.log(currUser+"==========>query card result........")
          queryResult(currUser,otherUser)
          resultTimer.running=false
      }
    }

    Timer{
      id: clearTimer
      interval: 1000; running: false; repeat: true
      onTriggered:{
          console.log(currUser+"==========>clearTimer result........")
          play_curruser.opacity=0
          play_otheruser.opacity=0
          clearTimer.running=false
      }
    }



    Rectangle{
        width: parent.width*0.9
        height: parent.height*0.2
        anchors.top: parent.top
        radius: 10
        anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ddd"
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
            spacing: 100

            Rectangle{
                id:play_curruser_area

                color: "transparent"
                width: 80
                height: 30
                Row{
                    anchors.centerIn: parent
                    spacing: 5
                    Image {
                        id:curruser_image
                        anchors.verticalCenter: parent.verticalCenter
                        width: 16
                        height: 16
                        source: "image/user.png"
                    }

                  Text {
                      anchors.verticalCenter: parent.verticalCenter
                      id: play_curruser_text
                      font.pixelSize: 16
                      text: qsTr(currUser)
                  }
                }
            }



            Rectangle{
                id:play_otheruser_area
                color: "transparent"
                width: 80
                height: 30
                Row{
                    spacing: 5
                    anchors.centerIn: parent
                    Image {
                        id:otheruser_image
                         anchors.verticalCenter: parent.verticalCenter
                        width: 16
                        height: 16
                        source: "image/user.png"
                    }
                    Text {
                      font.pixelSize: 16
                      anchors.verticalCenter: parent.verticalCenter
                      id: play_otheruser_text
                      text: qsTr(otherUser)
                    }
                }
            }
        }

        RowLayout{
            anchors.centerIn:  parent
            spacing: 50
            GButton {
               id: play_curruser
               opacity: 0
               text: "玩家A"
            }
            GButton {
                id:play_otheruser
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
       radius: 5
       color: "black"
       anchors.centerIn: parent
       width: parent.width*0.9
       height: parent.height*0.9
           ListView {
               id: listView
               anchors.top: parent.top
               anchors.topMargin: 15
               width: parent.width
               highlightRangeMode: ListView.StrictlyEnforceRange
               height:parent.height
               delegate: PlayerDelegate {
                   id: delegate
                    width: listView.width
                    onClicked: {
                        console.log("list view index===", index,playerModel.get(index).nickName)
                        userlist_id.visible=false
                        console.log(userId.text,"=======>",playerModel.get(index).nickName)
                        otherUser=playerModel.get(index).nickName

                        reqPlay(currUser,playerModel.get(index).nickName)

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
                onClicked: {
                 playm_area.border.color="red"
                }
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
                playCard(currUser,otherUser,"工兵",1)
            }
        }

        GButton {
            text: "排长"
            onClicked: {
                 playCard(currUser,otherUser,"排长",2)
            }
        }

        GButton {
            text: "连长"
            onClicked: {
                 playCard(currUser,otherUser,"连长",3)
            }
        }

        GButton {
            text: "营长"
            onClicked: {
                 playCard(currUser,otherUser,"营长",4)
            }
        }

        GButton {
            text: "团长"
            onClicked: {
                  playCard(currUser,otherUser,"团长",5)
            }
        }

        GButton {
            text: "旅长"
            onClicked: {
                playCard(currUser,otherUser,"旅长",6)
            }
        }

        GButton {
            text: "师长"
            onClicked: {
                playCard(currUser,otherUser,"师长",7)
            }
        }

        GButton {
            text: "军长"
            onClicked: {
                playCard(currUser,otherUser,"军长",8)
            }
        }
        GButton {
            text: "司令"
            onClicked: {
                 playCard(currUser,otherUser,"司令",9)
            }
        }

        GButton {
            text: "炸弹"
            onClicked: {
                 playCard(currUser,otherUser,"炸弹",101)
            }
        }

        GButton {
            text: "地雷"
            onClicked: {
                  playCard(currUser,otherUser,"地雷",100)
            }
        }

        GButton {
            text: "军旗"
            onClicked: {
                playCard(currUser,otherUser,"军旗",0)
            }
        }
    }
    }




}
