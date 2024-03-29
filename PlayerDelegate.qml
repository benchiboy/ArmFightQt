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

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

ItemDelegate {
    id: root
    width: parent.width
    height: 40
    signal clicked

    Rectangle {
            height: parent.height-1
            width: parent.width
            color: mouse.pressed ? "grey" : "#ddd"
            MouseArea {
                id: mouse
                anchors.fill: parent
                onClicked: root.clicked()
            }

            Row{
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                Image {
                    id: headurl
                    anchors.verticalCenter: parent.verticalCenter
                    width: 26
                    height: 26
                    source: userHeadImage
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "black"
                    width: parent.width*0.3
                    id: name
                    font.pixelSize: 14
                    text: nickName
                }

                Text {
                    color: userStatus=="1"?"green":(userStatus=="2"?"red":"black")
                    anchors.verticalCenter: parent.verticalCenter
                    id: playerstatus
                    width: parent.width*0.2
                    font.pixelSize: 14
                    text:  userStatus=="1"?"空闲":(userStatus=="2"?"战斗中":"不在线")
                }

                Rectangle{
                    height: 40
                    width: parent.width*0.2
                    color: "transparent"
                    Row{
                        anchors.fill: parent
                        anchors.verticalCenter: parent.verticalCenter
                        Image {
                            id: xunzhang
                            anchors.verticalCenter: parent.verticalCenter
                            width: 24
                            height: 24
                            source: "image/xunzhang.png"
                        }
                        Label{
                            anchors.verticalCenter: parent.verticalCenter
                            text: "0"
                        }
                    }

                }

         }

      }

}
