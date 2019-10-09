import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtWebSockets 1.0
import QtQuick.Dialogs 1.1
import QtQuick.Window 2.13
import QtQuick.Particles 2.0
import QtMultimedia 5.13

ApplicationWindow {
    id: window
    visible: true
    width: 360
    height: 630
    title: qsTr("Stack")
    SystemPalette { id: activePalette }


    property bool gameOver: true
    property int score: 0
    property int highScore: 0
    property int moves: 0
    property string mode: ""
    //property ParticleSystem ps: particleSystem

    property  int  sign_in: 1000
    property  int  sign_in_resp: 2000
    property  int  play_card: 1001
    property  int  play_card_resp: 2001

    property  int  req_play_card: 1055
    property  int  req_play_card_resp: 2055

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
    property  int  req_giveup: 1007
    property  int  req_giveup_resp: 2007

    property  int  send_voice: 1034
    property  int  send_voice_resp: 2034

    property  int  init_data: 1030
    property  int  init_data_resp: 2030

    property  int  change_user: 1040
    property  int  change_user_resp: 2040

    property  int  offline_msg: 1050

    property  int  robot_type: 1
    property  int  human_type: 2

    property  int  start_game: 1035
    property  int  start_game_resp: 2035

    property  int  playtimeout: 5
    property  int  timecount: playtimeout

    property  bool    bplay_card: false
    property  bool    bgameOver: false
    property  bool    isGameWinner: false

    property  string  currUser:""
    property  string  otherUser:""
    property  int     otherUserType:0
    property  string  currCard:""
    property  string  winnerType:""
    property  string  currRole:""
    property  int     goldcoins: 0
    property  int     decorations: 0

    property  string  gameWinner:""
    property  string  gameLoster:""




    property  string  messageGreat:"你真棒👍!"
    property  string  messageCommon:"赶快走棋!"
    property  var       voiceFight: {"waveName":"image/voice_fight.mp3","waveText":"有本事，放马过来..."}
    property  var       voiceBomb:  {"waveName":"image/voice_bomb.mp3","waveText":"小心地雷炸弹！"}
    property  var       voiceTooSlow:  {"waveName":"image/voice_tooslow.mp3","waveText":"你太慢了，赶快出棋"}
    property  string    playVoiceFile:""
    property  var   command: { "type": 0, "userid": "" }


    function playCard(fromId,toId,message,score){
        console.log("=====>playCard====>")
        if (!bplay_card){
            console.log("Wait a another player...")
            return
        }
        bplay_card=false
        command.type=play_card
        command.fromid=fromId
        command.message=message
        command.toid=toId
        command.score=score
        socket.sendTextMessage(JSON.stringify(command))
    }

    function queryResult(fromId,toId){
        console.log("=====>queryResult====>")
        command.type=query_result
        command.fromid=fromId
        command.message="query result..."
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function sendMessage(fromId,toId,msg){
        console.log("=====>sendMessage====>")
        command.type=send_msg
        command.fromid=fromId
        command.message=msg
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function sendVoice(fromId,toId,msg){
        console.log("=====>sendVoice====>")
        command.type=send_voice
        command.fromid=fromId
        command.message=msg
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function signIn(id){
        console.log("=====>signIn====>")
        currUser=id
        command.type=sign_in
        command.userid=Math.random(100)
        command.nickname=id
        command.fromid=id
        command.messge="signin"
        socket.sendTextMessage(JSON.stringify(command))
    }

    function initData(id){
        console.log("=====>initData====>")
        currUser=id
        command.type=init_data
        command.userid=Math.random(100)
        command.nickname=id
        command.messge="init data..."
        socket.sendTextMessage(JSON.stringify(command))
    }

    function initDataResp(initMsg){
       console.log("=====>initDataResp====>")
       console.log("----->",initMsg)
       gameMain.visible=true
       newGame.visible=false
       gameOver.visible=false
       bgameOver=false
       var  initObj=JSON.parse(initMsg)
       card_gongbing.count=initObj.gongbing
       card_paizhang.count=initObj.paizhang
       card_lianzhang.count=initObj.lianzhang
       card_yingzhang.count=initObj.yingzhang
       card_tuanzhang.count=initObj.tuanzhang
       card_lvzhang.count=initObj.lvzhang
       card_shizhang.count=initObj.shizhang
       card_junzhang.count=initObj.junzhang
       card_siling.count=initObj.siling
       card_dilei.count=initObj.dilei
       card_zhadan.count=initObj.zhadan
       card_junqi.count=initObj.junqi
       card_dilei.count=initObj.dilei

        if (otherUserType==robot_type){
             reqPlayCard(currUser,otherUser,"RRR",0)
        }

    }

    function getUsers(){
        console.log("=====>getUsers====>")
        command.type=get_users
        socket.sendTextMessage(JSON.stringify(command))
    }

    function getUsersResult(message){
        console.log("=====>getUsersResult====>")
        playerModel.clear()
        var  msgObj=JSON.parse(message)
        console.log(msgObj)
        for(var key in msgObj) {
            console.log(key, msgObj[key].status);
            console.log("玩家的类型", msgObj[key].playertype);
            playerModel.append( {"userId":msgObj[key].userid,
                                 "nickName":msgObj[key].nickname,
                                 "decoration":msgObj[key].decoration,
                                 "playerType":msgObj[key].playertype
                               });
        }
    }

    function reqPlay(fromId,toId){
        console.log("=====>reqPlay====>")
        command.type=req_play
        command.fromid=fromId
        command.messge="request play a game"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function reqPlayYes(fromId,toId){
        console.log("=====>reqPlayYes====>")
        command.type=req_playyes
        command.fromid=fromId
        command.messge="好的，一起玩吧"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function reqPlayNo(fromId,toId){
        console.log("=====>reqPlayNo====>")
        command.type=req_playno
        command.fromid=fromId
        command.messge="他拒绝了你的请求"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function showMsgBox(msg){
        console.log("=====>showMsgBox====>")
        msgbox.visible=true
        msgcontext.text=msg
        msgboxTimer.running=true
    }

    function sendGiveup(fromId,toId){
        console.log("=====>sendGiveup====>")
        command.type=req_giveup
        command.fromid=fromId
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function startGame(fromId,toId){
        console.log("=====>startGame====>")


        command.type=start_game
        command.fromid=fromId
        command.messge="start play a game"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }

    function showGameOver(){
        console.log("=====>showGameOver====>")
        gameMain.visible=false
        gameOver.visible=true
    }

    function showGameMain(){
        console.log("=====>showGameMain====>")
        gameMain.visible=true
        newGame.visible=false
    }

    function showNewGame(){
        console.log("=====>showNewGame====>")
        singIn.visible=false
        newGame.visible=true
    }

    function playVoice(){
        console.log("=====>playVoice====>")
        spawnSound.play()
    }

    function showCoinLauch(){
        console.log("=====>showCoinLauch====>")
        coinLaunch.start()
        goldcoins++
        spawnSound.source="image/currency.wav"
        spawnSound.play()
    }

    function changeUser(fromId,toId){
        console.log("=====>changeUser====>")
        command.type=change_user
        command.fromid=fromId
        command.messge="改变用户请求"
        command.toid=toId
        socket.sendTextMessage(JSON.stringify(command))
    }


    function reqPlayCard(fromId,toId,message,score){
        console.log("=====>playCard====>")
        if (!bplay_card){
            console.log("Wait a another player...")
            return
        }
        bplay_card=false
        command.type=req_play_card
        command.fromid=fromId
        command.message=message
        command.toid=toId
        command.score=score
        socket.sendTextMessage(JSON.stringify(command))
    }


//    BusyIndicator {
//        id: busyIndicator
//        running: true
//        z:900
//        anchors.centerIn: parent

//    }

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
               BusyIndicator.running=true
                reqPlayYes(currUser,otherUser)
               }
        onNo: {
                console.log("didn't copy")
                 reqPlayNo(currUser,otherUser)
             }
    }

    WebSocket {
       id: socket
       url: "ws://127.0.0.1:8080/echo"
       onTextMessageReceived: {
           //console.log("textMessageRev",message)
           var recvMsg=JSON.parse(message)
           switch (recvMsg.type){
                case start_game_resp:
                    console.log("Recv start_game_resp===>")
                    showGameMain()
                    initData(currUser);
                    break;
                case start_game:
                    console.log("Recv start_game===>")
                    showGameMain()
                    initData(currUser);
                    break;
                case get_users_resp:
                    console.log("Recv get_users_resp===>")
                    getUsersResult(recvMsg.message);
                    break;
                case sign_in_resp:
                    console.log("Recv sign_in_resp===>")
                     if (recvMsg.success){
                         currUser=recvMsg.fromid
                         showNewGame()
                      }else{
                        signresult.text=recvMsg.message
                     }
                    break;
                case init_data_resp:
                    console.log("Recv init_data_resp===>")
                    initDataResp(recvMsg.message);
                    break;
                case send_msg:
                    console.log("Recv send_msg===>")
                    showMsgBox(recvMsg.message)
                    break;
                case send_msg_resp:
                    console.log("Recv send_msg_resp===>")
                    break;
                case send_voice:
                    console.log("Recv send_voice===>")
                    playVoiceFile=recvMsg.message
                    voiceTimer.running=true
                    break;
                case send_voice_resp:
                    console.log("Recv send_voice_resp===>")
                    break;
                case req_play:
                    console.log("Recv req_play===>")
                    otherUser=recvMsg.fromid
                    playconfirm.visible=true
                    break;
                case req_play_resp:
                    console.log("Recv req_play_resp===>")
                    break;
                case req_playyes:
                    console.log("Recv req_playyes===>")
                    otherUser=recvMsg.fromid
                    //发起方先出
                    showMsgBox("对方已经同意,开始游戏吧!")

                     if (otherUserType==human_type){
                        play_curruser_area.border.color="red"
                     }else{
                         play_otheruser_area.border.color="red"

                     }

                    bplay_card=true
                    break;
                case req_playyes_resp:
                    console.log("Recv req_playyes_resp===>")
                    //主先出牌
                    if (otherUserType==human_type){
                         play_otheruser_area.border.color="red"
                    }else{
                        play_curruser_area.border.color="red"
                    }

                    break;
                case req_playno:
                    console.log("Recv req_playno===>")
                    otherUser=recvMsg.fromid
                case req_playno_resp:
                    console.log("Recv req_playno_resp===>")
                    otherUser=recvMsg.fromid
                    break;
                case play_card:
                    console.log("Recv play_card===>")
                    otherUser=recvMsg.fromid
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
                     console.log("Recv play_card_resp===>")
                     //显示下一步谁出牌
                     play_curruser_area.border.color="transparent"
                     play_otheruser_area.border.color="red"

                    if ( recvMsg.role=="M"){
                        play_curruser.opacity=1
                        play_curruser.text=recvMsg.message
                        if (otherUserType==robot_type){
                            resultTimer.running=true
                        }
                    }else{
                        play_curruser.opacity=1
                        play_curruser.text=recvMsg.message
                        //开始触发从服务器查询大小
                        resultTimer.running=true
                    }
                    break;

                case query_result_resp:
                    console.log("Recv query_result_resp===>")
                    console.log(recvMsg.status)
                    if (recvMsg.status=="E"){
                        console.log("game over...")
                        bgameOver=true
                    }
                    play_otheruser.text=recvMsg.anothermsg
                    currCard=recvMsg.message
                    currRole=recvMsg.role
                    winnerType=recvMsg.winner
                    clearTimer.running=true

                    if (currRole!=winnerType){
                        gameLoster=currUser
                        gameWinner=otherUser
                    }else{
                        gameLoster=otherUser
                        gameWinner=currUser
                    }
                    break;
                case req_giveup:
                    console.log("Recv req_giveup===>")
                    gameWinner=currUser
                    gameLoster=otherUser
                    showGameOver()

                    isGameWinner=true
                    break;
                case req_giveup_resp:
                    console.log("Recv req_giveup_resp===>")
                    gameWinner=otherUser
                    gameLoster=currUser
                    showGameOver()
                    isGameWinner=false
                    break

                case change_user:
                    console.log("Recv change_user===>")
                    otherUser=""
                    showMsgBox("CHANGE_USER")
                    console.log("======>"+otherUser+"===========>")
                    break;
                case change_user_resp:
                    console.log("Recv change_user_resp===>")
                    break
                case offline_msg:
                    console.log("Recv offline_msg===>")
                    showMsgBox("对方下线了")
                    otherUser=""
                    break
                case req_play_card_resp:
                    console.log("Recv req_play_card_resp===>")
                    break
                default:
                    console.log("Recv error command===>")
           }

       }

       onStatusChanged: if (socket.status == WebSocket.Error) {
                            console.log("Error: " + socket.errorString)
                        } else if (socket.status == WebSocket.Open) {
                            console.log("socket connected successful!")
                            signIn(singIn.userText)

                        } else if (socket.status == WebSocket.Closed) {
                            socket.active=false
                            console.log("socket closed")
                           // messageBox.text += "\nSocket closed"
                        }
       active: false
     }



    Image {
        source:"/image/background1.png"
        width: 360
    }


    Rectangle{
        id:msgbox
        anchors.centerIn: parent;
        z:200
        visible: false
        width: msgcontext.width+10
        height: msgcontext.height+10
        color: "black"
        radius:10
        Text {
            id: msgcontext
            anchors.centerIn: parent
            text: qsTr("ssss")
            color: "red"
        }
    }

    Timer{
      id: msgboxTimer
      interval: 1500; running: false; repeat: true
      onTriggered:{
          msgbox.visible=false
          msgboxTimer.running=false
      }
    }



   SmokeText {
        id: p1Text; source: "image/icon-fail.png";
        //system:    gameCanvas.ps
    }

    GameArea {
        id: gameCanvas
        z: 3
        y:1
        width: parent.width
        height: 1
   }

   SigninScreen{
        id:singIn
        visible: true
   }

   SignupScreen{
        id:singUp
        visible: false
   }

   Timer{
      id: resultTimer
      interval: 1500; running: false; repeat: true
      onTriggered:{
          console.log("Timer===>"+currUser+"===>query play result...")
          queryResult(currUser,otherUser)
          resultTimer.running=false
      }
    }

   Timer{
      id: playcardTimer
      interval: 1500; running: false; repeat: true
      onTriggered:{
          playcardTimer.running=false
          if (otherUserType==robot_type){
              bplay_card=true
              reqPlayCard(currUser,otherUser,"工兵",1)
          }
      }
    }


    Timer{
      id: clearTimer
      interval: 1000; running: false; repeat: true
      onTriggered:{
           console.log("Timer===>"+currUser+"===>clear result...")
           if (winnerType=="B"){
               showCoinLauch()
           }

          if (winnerType!=currRole){
                if (currCard=="工兵"){
                    card_gongbing.count--
                     p1Text.play()
                    if (card_gongbing.count==0){
                        card_gongbing.border.color="red"
                        card_gongbing.enabled=false
                    }
                }
                if (currCard=="排长"){
                    card_paizhang.count--
                       p1Text.play()
                    if (card_paizhang.count==0){
                        card_paizhang.border.color="red"
                        card_paizhang.enabled=false
                    }
                }
                if (currCard=="连长"){
                    card_lianzhang.count--
                       p1Text.play()
                    if (card_lianzhang.count==0){
                        card_lianzhang.border.color="red"
                        card_lianzhang.enabled=false
                    }
                }
                if (currCard=="营长"){
                    card_yingzhang.count--
                       p1Text.play()
                    if (card_yingzhang.count==0){
                        card_yingzhang.border.color="red"
                        card_yingzhang.enabled=false
                    }
                }
                if (currCard=="团长"){
                    card_tuanzhang.count--
                       p1Text.play()
                    if (card_tuanzhang.count==0){
                        card_tuanzhang.border.color="red"
                        card_tuanzhang.enabled=false
                    }
                }
                if (currCard=="旅长"){
                    card_lvzhang.count--
                       p1Text.play()
                    if (card_lvzhang.count==0){
                        card_lvzhang.border.color="red"
                        card_lvzhang.enabled=false
                    }
                }
                if (currCard=="师长"){
                    card_shizhang.count--
                       p1Text.play()
                    if (card_shizhang.count==0){
                        card_shizhang.border.color="red"
                        card_shizhang.enabled=false
                    }
                }
                if (currCard=="军长"){
                    card_junzhang.count--
                       p1Text.play()
                    if (card_junzhang.count==0){
                        card_junzhang.border.color="red"
                        card_junzhang.enabled=false
                    }
                }
                if (currCard=="军旗"){
                    card_junqi.count--
                       p1Text.play()
                    if (card_junqi.count==0){
                        card_junqi.border.color="red"
                        card_junqi.enabled=false
                    }
                }
                if (currCard=="司令"){
                    card_siling.count--
                       p1Text.play()
                    if (card_siling.count==0){
                        card_siling.border.color="red"
                        card_siling.enabled=false
                    }
                }
                if (currCard=="炸弹"){
                    card_zhadan.count--
                       p1Text.play()
                    if (card_zhadan.count==0){
                        card_zhadan.border.color="red"
                        card_zhadan.enabled=false
                    }
                }
                if (currCard=="地雷"){
                    card_dilei.count--
                       p1Text.play()
                    if (card_dilei.count==0){
                        card_dilei.border.color="red"
                        card_dilei.enabled=false
                    }
                }
          }else{
              showCoinLauch()
          }

          console.log(winnerType,currRole)
          play_curruser.opacity=0
          play_otheruser.opacity=0
          clearTimer.running=false
          //如果是机器人，请求机器人先出牌
          playcardTimer.running=true

          if (bgameOver){
              if (winnerType!=currRole){
                 isGameWinner=false
              }else{
                 isGameWinner=true
              }
              showGameOver()
          }
      }
    }




//        PropertyAnimation {
//            id:animFadeIn
//            target: playa
//            duration: root.duration
//            easing.type: root.easingType
//            property: 'opacity';
//            from: 0;
//            to: root.innerOpacity
//        }
//        PropertyAnimation {
//            id: animFadeOut
//            target: playa
//            duration: root.duration
//            easing.type: root.easingType
//            property: 'opacity';
//            from: root.innerOpacity;
//            to: 1
//        }
//        property int countdown: 0
//        Timer {
//            id: countdownTimer
//            interval: 1000
//            running: window.countdown < 5
//            repeat: true
//            onTriggered: {
//                window.countdown++
//            }
//        }
//        Repeater {
//            model: ["image/background.png", "image/text-3.png", "image/text-2.png", "image/text-1.png", "image/text-go.png"]
//            delegate: Image {
//                visible: window.countdown <= index
//                opacity: window.countdown == index ? 0.5 : 0.1
//                scale: window.countdown >= index ? 1.0 : 0.0
//                source: modelData
//                z:2000
//                Behavior on opacity { NumberAnimation {} }
//                Behavior on scale { NumberAnimation {} }
//            }
//        }
//        SpriteSequence {
//            id: fishSprite
//            width: 64
//            height: 64
//            interpolate: false
//            goalSprite: ""

//            Sprite {
//                name: "left"
//                source: "image/catch-action.png"
//                frameWidth: 64
//                frameHeight: 64
//                frameCount: 2
//                frameDuration: 200
//                frameDurationVariation: 100
//                to: { "front" : 1 }
//            }
//            NumberAnimation on x {
//                id: fishSwim
//                running: false
//                property bool goingLeft: fishSprite.currentSprite == "right"
//                to: goingLeft ? -360 : 360
//                duration: 300
//            }
      // }
//    SpringAnimation{
//            id: springX
//            target: playa
//            property: "scale"
//            spring: 1
//            damping: 0.1
//            epsilon: 0.2
//    }


//    SpringAnimation{
//            id: springX
//            target: playa
//            property: "scale"
//            spring: 1
//            damping: 0.1
//            epsilon: 0.2
//    }

  GameOverScreen{
    id:gameOver
    anchors.fill: parent
    visible: false
    onOverButtonClicked: {
        console.log("Event===>Start Game...")
         startGame(currUser,otherUser)
    }
  }


  NewGameScreen{
    id:newGame
    anchors.fill: parent
    visible: true
    onStartButtonClicked: {
        console.log("Event===>Start Game...")
        if (otherUser==""){
            showMsgBox("选择你的对手")
            return
        }
        startGame(currUser,otherUser)
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
      color: "white"
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
                       if (otherUser!=""){
                          var  tmpNick=playerModel.get(index).nickName
                           if (otherUser!=tmpNick){
                               console.log("changer user.....old user===>",otherUser,"new user===>",tmpNick)
                               changeUser(currUser,otherUser)
                           }
                       }
                       otherUser=playerModel.get(index).nickName
                       otherUserType=playerModel.get(index).playerType

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

  MediaPlayer {
    id: spawnSound
    source: "image/bomb-action.wav"
  }

  Timer{
    id: voiceTimer
    interval: 100; running: false; repeat: true
    onTriggered:{
       voiceTimer.running=false
       spawnSound.source=playVoiceFile
       spawnSound.play()
    }
  }


  Item{
   id:gameMain
   anchors.fill: parent

   InfoBar{
     id:infobar
     anchors.fill: parent
   }

   Image {
       id: coin
       property var target: { "x" : gameMain.width-60, "y" :0 }
       source: "image/jinbi-small.png"
       visible: false
       z:2000
   }

   SequentialAnimation {
       id: coinLaunch
       PropertyAction { target: coin; property: "visible"; value: true }
       ParallelAnimation {
           NumberAnimation { target: coin; property: "x"; from: killarea.width/2; to: coin.target.x }
           NumberAnimation { target: coin; property: "y"; from: killarea.height/2+60; to: coin.target.y }
       }
       PropertyAction { target: coin; property: "visible"; value: false }
   }

   Rectangle{
       id:killarea
       width: parent.width*0.9
       height: parent.height*0.2
       anchors.top: parent.top
       radius: 10
       anchors.topMargin: 60
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
       //出牌区域
       RowLayout{
           anchors.verticalCenter: parent.verticalCenter
           anchors.horizontalCenter: parent.horizontalCenter
           anchors.verticalCenterOffset: 10

           spacing: 80
           GButton {
              id: play_curruser
              opacity: 0
              text: "玩家A"
              Behavior on opacity { PropertyAnimation{ duration: 500 } }
           }
           GButton {
               id:play_otheruser
               opacity: 0
               text: "玩家B"
               Behavior on opacity { PropertyAnimation{ duration: 500 } }
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
            spacing: 30

            GButton {
                id:sendmsg
                text: "发消息"
                count: 0
                onClicked: {
                    onClicked: menu.open()
                }
            }

            Menu {
                   id: menu
                   anchors.centerIn: parent
                   MenuItem {
                       Row{
                           anchors.verticalCenter: parent.verticalCenter
                           spacing: 10
                           Text {
                              id: name11
                                text: qsTr(" ")
                           }
                           Image {
                               anchors.verticalCenter: parent.verticalCenter
                               id: name12
                               source: "image/xiaoxi.png"
                               width: 24
                               height: 24
                           }
                           Text {
                              id: name13
                              anchors.verticalCenter: parent.verticalCenter
                              text: qsTr(messageCommon)
                           }
                       }
                       onClicked: {
                            sendMessage(currUser,otherUser,messageCommon)
                       }
                   }

                   MenuItem {
                       Row{
                           anchors.verticalCenter: parent.verticalCenter
                           spacing: 10
                           Text {
                              id: name21
                                text: qsTr(" ")
                           }
                           Image {
                               anchors.verticalCenter: parent.verticalCenter
                              id: name22
                               source: "image/xiaoxi.png"
                               width: 24
                               height: 24
                           }
                           Text {
                              id: name23
                              anchors.verticalCenter: parent.verticalCenter
                              text: qsTr(messageGreat)
                           }
                       }
                       onClicked: {
                            sendMessage(currUser,otherUser,messageGreat)
                       }
                   }

                   MenuItem {
                       Row{
                           anchors.verticalCenter: parent.verticalCenter
                           spacing: 10
                           Text {
                              id: name31
                                text: qsTr(" ")
                           }
                           Image {
                               anchors.verticalCenter: parent.verticalCenter
                              id: name32
                               source: "image/shengyin.png"
                               width: 24
                               height: 24
                           }
                           Text {
                              id: name33
                              anchors.verticalCenter: parent.verticalCenter
                              text: qsTr(voiceFight.waveText)
                           }
                       }
                       onClicked: {
                            sendVoice(currUser,otherUser,voiceFight.waveName)
                       }
                   }

                   MenuItem {
                       Row{
                           anchors.verticalCenter: parent.verticalCenter
                           spacing: 10
                           Text {
                              id: name41
                                text: qsTr(" ")
                           }
                           Image {
                               anchors.verticalCenter: parent.verticalCenter
                              id: name42
                               source: "image/shengyin.png"
                               width: 24
                               height: 24
                           }
                           Text {
                              id: name43
                              anchors.verticalCenter: parent.verticalCenter
                              text: qsTr(voiceBomb.waveText)
                           }
                       }
                       onClicked: {
                            sendVoice(currUser,otherUser,voiceBomb.waveName)
                       }
                   }

                   MenuItem {
                       Row{
                           anchors.verticalCenter: parent.verticalCenter
                           spacing: 10
                           Text {
                              id: name51
                                text: qsTr(" ")
                           }
                           Image {
                               anchors.verticalCenter: parent.verticalCenter
                              id: name52
                               source: "image/shengyin.png"
                               width: 24
                               height: 24
                           }
                           Text {
                              id: name53
                              anchors.verticalCenter: parent.verticalCenter
                              text: qsTr(voiceTooSlow.waveText)
                           }
                       }
                       onClicked: {
                            sendVoice(currUser,otherUser,voiceTooSlow.waveName)
                       }
                   }
               }

            GButton {
                id:wetie
                text: "求平局"
                count: 0
                onClicked: {
                 //playm_area.border.color="red"
                  // sendGiveup(currUser,otherUser)
                   // voiceTimer.running=true
                    coinLaunch.start()
                }
            }

            GButton {
                id:ifailed
                text: "我认输"
                count: 0
                onClicked: {
                 //playm_area.border.color="red"
                   sendGiveup(currUser,otherUser)
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
            id:gridcontainer
            anchors.fill: parent
            anchors.centerIn: parent
            columns: 4
            rows: 4
            columnSpacing: 10
            rowSpacing: 1

            GButton {
                id:card_gongbing
                text: "工兵"
                count: 3
                onClicked: {
                    playCard(currUser,otherUser,"工兵",1)
                }
            }
            GButton {
                id:card_paizhang
                text: "排长"
                count: 2
                onClicked: {
                     playCard(currUser,otherUser,"排长",2)
                }
            }
            GButton {
                id:card_lianzhang
                text: "连长"
                count: 2
                onClicked: {
                     playCard(currUser,otherUser,"连长",3)
                }
            }
            GButton {
                id:card_yingzhang
                text: "营长"
                count: 2
                onClicked: {
                     playCard(currUser,otherUser,"营长",4)
                }
            }
            GButton {
                id:card_tuanzhang
                text: "团长"
                count: 2
                onClicked: {
                      playCard(currUser,otherUser,"团长",5)
                }
            }
            GButton {
                id:card_lvzhang
                count: 2
                text: "旅长"
                onClicked: {
                    playCard(currUser,otherUser,"旅长",6)
                }
            }
            GButton {
                id:card_shizhang
                count: 2
                text: "师长"
                onClicked: {
                    playCard(currUser,otherUser,"师长",7)
                }
            }
            GButton {
                id:card_junzhang
                count: 1
                text: "军长"
                onClicked: {
                    playCard(currUser,otherUser,"军长",8)
                }
            }
            GButton {
                id:card_siling
                count: 1
                text: "司令"
                onClicked: {
                     playCard(currUser,otherUser,"司令",9)
                }
            }
            GButton {
                id:card_zhadan
                count: 2
                text: "炸弹"
                onClicked: {
                     playCard(currUser,otherUser,"炸弹",101)
                }
            }
            GButton {
                id:card_dilei
                count: 3
                text: "地雷"
                onClicked: {
                      playCard(currUser,otherUser,"地雷",100)
                }
            }
            GButton {
                id:card_junqi
                count: 1
                text: "军旗"
                onClicked: {
                    playCard(currUser,otherUser,"军旗",0)
                }
            }
         }
    }

    Component.onCompleted: {
        gameMain.visible=false
        singIn.visible=true
        newGame.visible=false
        gameOver.visible=false
    }
  }


}
