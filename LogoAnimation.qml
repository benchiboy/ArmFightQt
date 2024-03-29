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
    id: container //Positioned where the 48x48 S/G should be
    property alias running: mainAnim.running
    property ParticleSystem particleSystem
    property int dur: 500
    signal boomTime
    Image {
        id: s1
        source: "image/logo-s.png"
        y: 0
    }
    Image {
        id: g1
        source: "image/logo-g.png"
        y: -128
    }
    Column {
        Repeater {
            model: 2
            Item {
                width: 48
                height: 48
                BlockEmitter {
                    id: emitter
                    anchors.fill: parent
                    group: "red"
                    system: particleSystem
                    Connections {
                        target: container
                        onBoomTime: emitter.pulse(100);
                    }
                }
            }
        }
    }
    SequentialAnimation {
        id: mainAnim
        running: true
        loops: -1
        PropertyAction { target: g1; property: "y"; value: -128}
        PropertyAction { target: g1; property: "opacity"; value: 1}
        PropertyAction { target: s1; property: "y"; value: 0}
        PropertyAction { target: s1; property: "opacity"; value: 1}
        NumberAnimation { target: g1; property: "y"; from: -96; to: -48; duration: dur}
        ParallelAnimation {
            NumberAnimation { target: g1; property: "y"; from: -48; to: 0; duration: dur}
            NumberAnimation { target: s1; property: "y"; from: 0; to: 48; duration: dur }
        }
        PauseAnimation { duration: dur }
        ScriptAction { script: container.boomTime(); }
        ParallelAnimation {
            NumberAnimation { target: g1; property: "opacity"; to: 0; duration: dur }
            NumberAnimation { target: s1; property: "opacity"; to: 0; duration: dur }
        }
        PropertyAction { target: s1; property: "y"; value: -128}
        PropertyAction { target: s1; property: "opacity"; value: 1}
        NumberAnimation { target: s1; property: "y"; from: -96; to: 0; duration: dur * 2}
    }
}
