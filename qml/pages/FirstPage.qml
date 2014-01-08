/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

import Metronome.Components 1.0


Page {
    id: metronome

    width: parent.width
    height: parent.height

    property int currentBeat: 0
    property alias _beats: beats.value
    property int _bpm: tempo.value
    property alias _running: metronomeTimer.running

    SoundEffect{
        id: bip
        source: "qrc:/bip.wav"
    }

    SoundEffect {
        id: bop
        source: "qrc:/bop.wav"
    }

    Timer {
        id: metronomeTimer
        interval: 60000 / tempo.value
        repeat: true

        onTriggered: {
            currentBeat = (currentBeat + 1)%beats.value
            pie.selectSlice(currentBeat)
            if(currentBeat === 0) {
                bip.play()
                return
            }
            bop.play()
        }
    }

    Column {
        width: parent.width - (Theme.paddingLarge * 2)
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: Theme.paddingSmall

        PageHeader {
            title: "Metronome"
        }
        PieCircle {
            id: pie

            width: parent.width
            height: width

            color: Theme.primaryColor

            slices: beats.value

            MouseArea{
                anchors.fill: parent

                onClicked: {
                    metronomeTimer.running = !metronomeTimer.running
                }
            }
        }

        Slider {
            id: beats

            width: parent.width

            minimumValue: 2
            maximumValue: 6
            value: 2
            stepSize: 1

            valueText: qsTr("Meter %1").arg(value)
        }

        Slider{
            id: tempo

            width: parent.width

            minimumValue: 30
            maximumValue: 300
            value: 60
            stepSize: 10

            valueText: qsTr("Tempo %1 bpm").arg(value)
        }
    }
}


