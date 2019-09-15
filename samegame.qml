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


Rectangle {
    id: root
    width: 400; height:600

    function loadPuzzle() {
        if (gameCanvas.mode != "")
            Logic.cleanUp();
        Logic.startNewGame(gameCanvas,"puzzle","levels/level"+acc+".qml")
    }
    function nextPuzzle() {
        acc = (acc + 1) % 10;
        loadPuzzle();
    }
    Timer {
        id: gameOverTimer
        interval: 1500
        running : gameCanvas.gameOver && gameCanvas.mode == "puzzle" //mode will be reset by cleanUp();
        repeat  : false
        onTriggered: {
            Logic.cleanUp();
            nextPuzzle();
        }
    }

    Image {
        source: "image/background.png"
        anchors.fill: parent
    }

    GameArea {
        id: gameCanvas
        z: 3
        y: Settings.headerHeight

        width: parent.width
        height: parent.height - Settings.headerHeight - Settings.footerHeight

//        backgroundVisible: root.state == "in-game"
//        onModeChanged: if (gameCanvas.mode != "puzzle") puzzleWon = false; //UI has stricter constraints on this variable than the game does
//        Age {
//            groups: ["redspots", "greenspots", "bluespots", "yellowspots"]
//            enabled: root.state == ""
//            system: gameCanvas.ps
//        }


       // onPuzzleLost: acc--;//So that nextPuzzle() reloads the current one

    }

    Item {
        id: menu
        z: 2
        width: parent.width;
        anchors.top: parent.top
        anchors.bottom: bottomBar.top



        LogoAnimation {
            x: 64
            y: Settings.headerHeight
            particleSystem: gameCanvas.ps
            running: root.state == ""
        }


//        SmokeText {
//            id: p1Text; source: "image/text-p1-go.png";
//            system:    gameCanvas.ps

//        }

//        Component.onCompleted: {
//            p1Text.play()
//        }
    }



}
