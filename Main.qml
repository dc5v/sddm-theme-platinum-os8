import QtQuick
import QtQuick.Controls
import QtCore
import SddmComponents 2.0
import "."

Rectangle 
{
  id: container
  LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
  LayoutMirroring.childrenInherit: true
  property int sessionIndex: session.index
  property date dateTime: new Date()

  TextConstants 
  {
    id: textConstants
  }

  Connections 
  {
    target: sddm
    function onLoginSucceeded() 
    {
      errorMessage.text = textConstants.loginSucceeded
    }

    function onLoginFailed() 
    {
      password.text = ""
      errorMessage.color = "#000000"
      errorMessage.text = textConstants.loginFailed
    }
  }

  Timer 
  {
    interval: 100; running: true; repeat: true;
    onTriggered: container.dateTime = new Date()
  }

  FontLoader 
  {
    id: fontChicago
    source: "./assets/pix-chicago.ttf"
  }

  Image 
  {
    id: behind
    anchors.fill: parent
     source: "assets/checker.png"
     fillMode: Image.Tile
     onStatusChanged: 
     {
       if (config.type === "color") 
       {
         source = config.defaultBackground
       }
     }
  }

  Image 
  {
    id: promptBox
    anchors.centerIn : parent
    source : "assets/box.png"
    width: 380
    height: 320

    Text 
    {
      id: greetingText
      wrapMode: wrap
      x: 173
      y: 100
      width: 160
      color: "#7a7a7a"
      horizontalAlignment: Text.AlignRight
      text: SystemInformation.prettyProductName
      font.family: fontChicago.name
      font.pointSize: 6
    }

    Text 
    {
      id: greetingText2
      anchors.left: greetingText.left
      anchors.top: greetingText.bottom
      wrapMode: wrap
      width: 160
      color: "#7a7a7a"
      horizontalAlignment: Text.AlignRight
      text: SystemInformation.kernelVersion
      font.family: fontChicago.name
      font.pointSize: 6
    }

    Image 
    {
      id: imageinput
      source: "assets/input.png"
      y: 185
      anchors.right: parent.right
      anchors.rightMargin: 16
      width: 260
      height: 28

      TextField 
      {
        id: nameinput
        focus: true
        font.family: fontChicago.name
        anchors.fill: parent
        text: userModel.lastUser
        font.pointSize: 6
        leftPadding: 8
        color: "#000000"
        selectByMouse: true
        selectionColor: "#c7c7c7"
        selectedTextColor: "#000000"

        background: Image 
        {
          id: textback
          source: "assets/inputhi.png"

          states: [
            State 
            {
              name: "yay"
              PropertyChanges {target: textback; opacity: 1}
            },
            State 
            {
              name: "nay"
              PropertyChanges {target: textback; opacity: 0}
            }
          ]

          transitions: [
            Transition 
            {
              to: "yay"
              NumberAnimation { target: textback; property: "opacity"; from: 0; to: 1; duration: 200; }
            },
            Transition 
            {
              to: "nay"
              NumberAnimation { target: textback; property: "opacity"; from: 1; to: 0; duration: 200; }
            }
          ]
        }

        KeyNavigation.tab: password
        KeyNavigation.backtab: password

        Keys.onPressed: (event)=> 
        {
          if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) 
          {
            password.focus = true
          }
        }

        onActiveFocusChanged: 
        {
          if (activeFocus) 
          {
            textback.state = "yay"
          } 
          else 
          {
            textback.state = "nay"
          }
        }
      }
    }

    Image 
    {
      id: imagepassword
      source: "assets/input.png"
      anchors.top: imageinput.bottom
      anchors.horizontalCenter: imageinput.horizontalCenter
      anchors.topMargin: 4
      width: 260
      height: 28

      TextField 
      {
        id: password
        font.family: fontChicago.name
        anchors.fill: parent
        font.pointSize: 6
        leftPadding: 8
        echoMode: TextInput.Password
        color: "#000000"
        selectionColor: "#c7c7c7"
        selectedTextColor: "#000000"

        background: Image 
        {
          id: textback1
          source: "assets/inputhi.png"

          states: [
            State 
            {
              name: "yay1"
              PropertyChanges {target: textback1; opacity: 1}
            },
            State 
            {
              name: "nay1"
              PropertyChanges {target: textback1; opacity: 0}
            }
          ]

          transitions: [
            Transition 
            {
              to: "yay1"
              NumberAnimation { target: textback1; property: "opacity"; from: 0; to: 1; duration: 200; }
            },
            Transition 
            {
              to: "nay1"
              NumberAnimation { target: textback1; property: "opacity"; from: 1; to: 0; duration: 200; }
            }
          ]
        }

        KeyNavigation.tab: nameinput
        KeyNavigation.backtab: nameinput

        Keys.onPressed: (event)=> 
        {
          if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) 
          {
            sddm.login(nameinput.text, password.text, sessionIndex)
            event.accepted = true
          }
        }

        onActiveFocusChanged: 
        {
          if (activeFocus) 
          {
            textback1.state = "yay1"
          } 
          else 
          {
            textback1.state = "nay1"
          }
        }
      }
    }

    Text 
    {
      id: userlabel
      anchors.left: promptBox.left
      anchors.verticalCenter: imageinput.verticalCenter
      anchors.leftMargin: 16
      font.family: fontChicago.name
      font.pointSize: 6
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      height: 28
      text: textConstants.userName + ":" 
      color: "#000000"
    }

    Text 
    {
      id: passwordlabel
      anchors.left: promptBox.left
      anchors.verticalCenter: imagepassword.verticalCenter
      anchors.leftMargin: 16
      font.family: fontChicago.name
      font.pointSize: 6
      horizontalAlignment: Text.AlignRight
      verticalAlignment: Text.AlignVCenter
      height: 28
      text: textConstants.password + ":"
      color: "#000000"
    }

    Text 
    {
      id: errorMessage
      anchors.left: imagepassword.left
      anchors.top: imagepassword.bottom
      anchors.topMargin: 9
      font.family: fontChicago.name
      font.pointSize: 6
      horizontalAlignment: Text.AlignRight
      width: 260
      text: "Welcome back"
      color: "#000000"
    }

    Image 
    {
      id : loginButton
      anchors.right: promptBox.right
      anchors.bottom: promptBox.bottom
      anchors.rightMargin: 16
      anchors.bottomMargin: 15
      width : 78
      height : 26
      source : "assets/buttonup.png"

      property string toolTipText3: textConstants.login
      ToolTip.text: toolTipText3
      ToolTip.delay: 500
      ToolTip.visible: toolTipText3 ? ma3.containsMouse : false

      MouseArea 
      {
        id: ma3
        anchors.fill: parent
        hoverEnabled: true

        onHoveredChanged: 
        {
          if (containsMouse) 
          {
            parent.source = "assets/buttonhover.png"
          }
          else 
          {
            parent.source = "assets/buttonup.png"
          }
        }

        onPressed: parent.source = "assets/buttondown.png"
        onReleased: sddm.login(nameinput.text, password.text, sessionIndex)
      }

      Text
      {
        anchors.centerIn: parent
        color: "#000000"
        font.family: fontChicago.name
        font.pointSize: 6
        text: textConstants.login
      }
    }

    SessionSelectBox 
    {
      id : session
      anchors.right: loginButton.left
      anchors.bottom: promptBox.bottom
      anchors.rightMargin: 5
      anchors.bottomMargin: 15
      width : 176
      height : 26
      font.pointSize: 6
      font.family : fontChicago.name
      model : sessionModel
      index : sessionModel.lastIndex
      KeyNavigation.backtab : password
      KeyNavigation.tab : nameinput
    }

    Image 
    {
      id : shutdownButton
      anchors.left: promptBox.left
      anchors.bottom: promptBox.bottom
      anchors.leftMargin: 16
      anchors.bottomMargin: 15
      width : 26
      height : 26
      source : "assets/powerup.png"

      property string toolTipText1: textConstants.shutdown
      ToolTip.text: toolTipText1
      ToolTip.delay: 500
      ToolTip.visible: toolTipText1 ? ma1.containsMouse : false

      MouseArea 
      {
        id: ma1
        anchors.fill : parent
        hoverEnabled : true
        onEntered : 
        {
          parent.source = "assets/powerhover.png"
        }
        onExited : 
        {
          parent.source = "assets/powerup.png"
        }
        onPressed : 
        {
          parent.source = "assets/powerdown.png"
        }
        onReleased : 
        {
          parent.source = "assets/powerup.png"
          sddm.powerOff()
        }
      }
    }

    Image 
    {
      id : rebootButton
      anchors.left: shutdownButton.right
      anchors.bottom: promptBox.bottom
      anchors.leftMargin: 5
      anchors.bottomMargin: 15
      width : 26
      height : 26
      source : "assets/rebootup.png"

      property string toolTipText2: textConstants.reboot
      ToolTip.text: toolTipText2
      ToolTip.delay: 500
      ToolTip.visible: toolTipText2 ? ma2.containsMouse : false

      MouseArea 
      {
        id: ma2
        anchors.fill : parent
        hoverEnabled : true
        onEntered : 
        {
          parent.source = "assets/reboothover.png"
        }
        onExited : 
        {
          parent.source = "assets/rebootup.png"
        }
        onPressed : 
        {
          parent.source = "assets/rebootdown.png"
        }
        onReleased : 
        {
          parent.source = "assets/rebootup.png"
          sddm.reboot()
        }
      }
    }
  } 

  Component.onCompleted : 
  {
    nameinput.focus = true
    textback1.state = "nay1" 
  }
}
