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
import QtQuick.Particles 2.0


Item {
    id: gameOverScreen

    signal overButtonClicked

    Image {
        id: img
        source: "image/text-gameover.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 15
    }

    Text {
        id:playresult
        text: "本次大战"
        anchors.top: img.bottom
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        font.bold: true
        color: "black"
        font.pixelSize: 18
        opacity: 0.9
    }

        Row{
            anchors.topMargin: 15
            anchors.top: playresult.bottom
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                width: parent.width*0.2
                height: 80
                color: "red"
                Column{
                    anchors.fill: parent
                    spacing: 5
                    Text {
                        id: name
                        text: qsTr(currUser)
                        font.bold: true
                        color: "white"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 16
                    }

                    Image {
                        id: winner
                        source: isGameWinner?"image/xiaolian.png":"image/kulian.png"
                          anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: info
                        text: qsTr("此战获得"+goldcoins+"个金币")
                        font.bold: true
                        color: "blue"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: 14
                    }
                }
            }
        }


        Row{
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 30
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Column{
                Image {
                    id:curruser_image
                    width: 50
                    height: 50
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "image/user.png"
                }
                Text {
                    id: name11
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr(currUser)
                    font.pixelSize: 18
                }
            }

            Image {
                id:arrow
                anchors.verticalCenter: parent.verticalCenter
                width: 32
                height: 32
                source: "image/arrow.png"
            }

            Column{
                Image {
                    width: 50
                    height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        id:to_user
                        source: "image/toUser.png"
                        MouseArea{
                            id:touser_mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                userlist_id.visible=true
                                getUsers()
                            }
                            onEntered: {
                                to_user.source="image/user.png"
                            }
                            onExited:  {
                                to_user.source="image/toUser.png"
                            }
                        }
                     }

                Text {
                    id: other
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: otherUser=="" ? "select":qsTr(otherUser)
                    font.pixelSize: 18
                }
            }
        }

    Image {
        source: "image/button-play.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        MouseArea {
            anchors.fill: parent
            onClicked:{
                //gameOverScreen.overButtonClicked()
                //Qt.quit()
                startGame(currUser,otherUser)
            }
        }
    }
}
