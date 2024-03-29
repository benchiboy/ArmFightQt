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
    id: gameCanvas
    property bool gameOver: true
    property int score: 0
    property int highScore: 0
    property int moves: 0
    property string mode: ""
    property ParticleSystem ps: particleSystem
    //For easy theming
    property alias backgroundVisible: bg.visible

    property string background: "image/background.png"

   property int blockSize: 32
    property alias particlePack: auxLoader.source
    //For multiplayer
    property int score2: 0
    property int curTurn: 1
    property bool autoTurnChange: false
    signal swapPlayers
    property bool swapping: false
    //onSwapPlayers: if (autoTurnChange) Logic.turnChange();//Now implemented below
    //For puzzle
    property url level
    property bool puzzleWon: false
    signal puzzleLost //Since root is tracking the puzzle progress
    function showPuzzleEnd (won) {
        if (won) {
            smokeParticle.color = Qt.rgba(0,1,0,0);
            puzzleWin.play();
        } else {
            smokeParticle.color = Qt.rgba(1,0,0,0);
            puzzleFail.play();
            puzzleLost();
        }
    }
    function showPuzzleGoal (str) {
        puzzleTextBubble.opacity = 1;
        puzzleTextLabel.text = str;
    }
    Image {
        id: bg
        z: -1
        anchors.fill: parent
        source: background;
        fillMode: Image.PreserveAspectCrop
    }

    MouseArea {
        anchors.fill: parent; onClicked: {
            if (puzzleTextBubble.opacity == 1) {
                puzzleTextBubble.opacity = 0;
                Logic.finishLoadingMap();
            } else if (!swapping) {
                Logic.handleClick(mouse.x,mouse.y);
            }
        }
    }



    ParticleSystem{
        id: particleSystem;
        anchors.fill: parent
        z: 5
        ImageParticle {
            id: smokeParticle
            groups: ["smoke"]
            source: "image/particle-smoke.png"
            alpha: 0.1
            alphaVariation: 0.1
            color: "yellow"
        }
        Loader {
            id: auxLoader
            anchors.fill: parent
            source: "PrimaryPack.qml"
            onItemChanged: {
                if (item && "particleSystem" in item)
                    item.particleSystem = particleSystem
                if (item && "gameArea" in item)
                    item.gameArea = gameCanvas
            }
        }
    }
}

