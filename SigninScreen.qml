/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.3
import QtQuick.LocalStorage 2.12 as Sql

Item {
        id: popup
        anchors.fill: parent
        property  string  userName:""
        ///////////////////////////////////
        StackView {
            id: meStackView
            anchors.fill: parent
            focus: true
            Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                 meStackView.pop()
                 event.accepted = true;
            }
            initialItem: Item {
            width: parent.width; height: parent.height
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50

                Image { source: "image/logo-g.png" }
                Image { source: "image/logo-a.png" }
                Image { source: "image/logo-m.png" }
                Image { source: "image/logo-e.png" }
            }
            Column{
                anchors.centerIn: parent
                spacing: 30
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    id: signresult
                    height:30
                    text: qsTr("")
                    color: "red"
                }
                Row{
                    TextField{
                        id:userId
                        focus: true
                        selectByMouse: true
                        maximumLength: 15
                        placeholderText: "输入登录账户"
                        background:Rectangle{
                            radius: 30
                            color:"white"
                            width: 190
                        }
                    }
                }

                Row{
                    TextField{
                        id:userPwd
                        focus: true
                        selectByMouse: true
                        maximumLength: 10
                        echoMode: TextInput.Password
                        placeholderText: "输入登录密码"
                        background:Rectangle{
                            radius: 30
                            color:"white"
                            width: 190
                        }
                       }
                }

                GButton {
                    id:signin
                    width: 100
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "登录"
                    count: 0
                    onClicked: {
                       console.log("SignInScreen.......")
                        //signInScreen.startSignin()
                        if (userId.text==""){
                            showMsgBox("登录账号不能为空！")
                            return
                        }
                        if (userPwd.text==""){
                            showMsgBox("登录密码不能为空！")
                            return
                        }
                        if (socket.active==false){
                            socket.active=true
                            nickName=userId.text
                            userPasswd=userPwd.text
                            storeData(nickName)
                        }
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: reguser
                        color:  regmouse.pressed?"red":"blue"
                        font.pixelSize: 15
                        font.underline: true
                        text: qsTr("注册用户")
                        MouseArea{
                            id:regmouse
                            anchors.fill:parent
                            onClicked: {
                                meStackView.push("SignupScreen.qml")
                            }
                        }
                    }
                    spacing: 60
                    Text {
                        id: forgetpwd
                        color: resetmouse.pressed?"red":"blue"
                        font.pixelSize: 15
                        font.underline: true
                        text: qsTr("忘记密码")
                        MouseArea{
                            id:resetmouse
                            anchors.fill:parent
                            onClicked: {
                                meStackView.push("ResetpwdScreen.qml")
                            }
                        }
                    }
                }

              }
         }
      }
      Component.onCompleted: {
         console.log("======>completed",userName)
         initDatabase()
         var loginUser=readData()
         if (loginUser!==""){
             userId.text=loginUser
         }
         if (userName!=""){
            userId.text=userName
         }
      }

      function initDatabase() {
           var db;
          db = Sql.LocalStorage.openDatabaseSync("ArmyFight", "1.0", "A box who remembers its position", 100000);
          db.transaction( function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS user(name TEXT, value TEXT)');
          });
      }

      function readData() {
          var db;
          var value
          db = Sql.LocalStorage.openDatabaseSync("ArmyFight", "1.0", "A box who remembers its position", 100000);
          db.transaction( function(tx) {
              var result = tx.executeSql('select * from user where name="loginUser"');
              if(result.rows.length >0) {
                  value = result.rows[0].value;
              }
          });
          return value
      }

      function storeData(userValue) {
          var db;
          db = Sql.LocalStorage.openDatabaseSync("ArmyFight", "1.0", "A box who remembers its position", 100000);
          db.transaction( function(tx) {
              var result = tx.executeSql('SELECT * from user where name ="loginUser"');
              // prepare object to be stored as JSON
              console.log(result.rows.length )
              if(result.rows.length >0) {// use update
                  result = tx.executeSql('UPDATE user set value=? where name="loginUser"', [userValue]);
              } else { // use insert
                  result = tx.executeSql('INSERT INTO user VALUES (?,?
                  )', ['loginUser', userValue]);
                 console.log(userValue,"=======",result)
              }
          });
      }
}

