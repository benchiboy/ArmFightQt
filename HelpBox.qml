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

Popup {
    id: helpBox
    anchors.centerIn: parent
    width: parent.width*0.9
    height: parent.height*0.7
    Rectangle{
       anchors.fill: parent
       Column{
           anchors.fill: parent
           spacing: 20
           Text {
               id: name0
               font.bold: true
               anchors.horizontalCenter: parent.horizontalCenter
               font.pixelSize: 16
               text: qsTr("游戏规则")
           }


           Text {
               id: name01
               font.pixelSize: 16
               width: parent.width-10
               text: qsTr("游戏支持双人对战和机器人对战模式，遵循公平公正与趣味协同的原则：")
               wrapMode: Text.WrapAnywhere
           }

           Text {
               id: name
               font.pixelSize: 16
               width: parent.width-10
               text: qsTr("1、司令>军长>师长>旅长>团长>营长>连长>排长>工兵")
               wrapMode: Text.WrapAnywhere
           }

           Text {
               id: name2
               font.pixelSize: 16
               width: parent.width-10
               text: qsTr("2、工兵吃地雷,炸弹地雷与任何棋子对战都是同归于尽")
               wrapMode: Text.WrapAnywhere
           }

           Text {
               id: name1
               font.pixelSize: 16
               width: parent.width-10
               text: qsTr("3、军旗吃炸弹和地雷")
               wrapMode: Text.WrapAnywhere
           }

           Text {
               id: name4
               font.pixelSize: 16
               width: parent.width-10
               text: qsTr("4、对战胜利一次奖励一个金币,金币大于100后，系统自动兑换一个军章")
               wrapMode: Text.WrapAnywhere
           }
       }

    }
}
