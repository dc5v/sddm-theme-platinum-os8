import QtQuick
import QtQuick.Controls

FocusScope 
{
  id: container
  width: 176; height: 26

  property color color: "#a3a3a3"
  property color borderColor: "#000000"
  property color focusColor: "#595959"
  property color hoverColor: "#c7c7c7"
  property color menuColor: "#ffffff"
  property color textColor: "#000000"

  property int borderWidth: 1
  property font font
  property alias model: listView.model
  property int index: 0
  property string arrowBoxImg: "assets/comboarrow.png"
  property string backgroundNormal:  "assets/cbox.png"
  property string backgroundHover: "assets/cboxhover.png"
  property string backgroundPressed: "assets/cbox.png"

  property Component rowDelegate: selectBox

  signal valueChanged(int id)

  Component 
  {
    id: selectBox
    Text 
    {
      anchors.fill: parent
      anchors.leftMargin: 6 + (LayoutMirroring.enabled ? arrow.width : 0)
      anchors.bottomMargin: 0
      verticalAlignment: Text.AlignVCenter
      color: container.textColor
      font: container.font
      text: parent.modelItem.name
    }
  }

  onFocusChanged: if (!container.activeFocus) { close(false) }

  Image 
  {
    id: main
    anchors.fill: parent
    fillMode: Image.Stretch
    source: backgroundNormal
    states: [
      State 
      {
        name: "hover"; when: mouseArea.containsMouse
        PropertyChanges { target: main; source: backgroundHover }
      },
      State 
      {
        name: "focus"; when: container.activeFocus && !mouseArea.containsMouse
        PropertyChanges { target: main; source: backgroundPressed }
      }
    ]
  }

  Loader 
  {
    id: topRow
    anchors.fill: parent
    focus: true
    clip: true
    sourceComponent: rowDelegate
    property variant modelItem
  }


    Image 
    {
      id: arrowBox
      source: arrowBoxImg
      anchors.right: parent.right
      width: container.height
      height: container.height
      smooth: true
      fillMode: Image.Stretch
    }

    property string toolTipText4: textConstants.session
    ToolTip.text: toolTipText4
    ToolTip.delay: 500
    ToolTip.visible: toolTipText4 ? mouseArea.containsMouse : false

  MouseArea 
  {
    id: mouseArea
    anchors.fill: container
    hoverEnabled: true
    onEntered: if (main.state == "") main.state = "hover";
    onExited: if (main.state == "hover") main.state = "";
    onClicked: { container.focus = true; toggle() }
    onWheel: 
    {
      if (wheel.angleDelta.y > 0)
      {
          listView.decrementCurrentIndex()
      }
      else
      {
          listView.incrementCurrentIndex()
      }
    }
  }

  Keys.onPressed: (event)=> 
  {
    if (event.key === Qt.Key_Up) 
    {
      listView.decrementCurrentIndex()
    } 
    else if (event.key === Qt.Key_Down) 
    {
      if (event.modifiers !== Qt.AltModifier)
      {
        listView.incrementCurrentIndex()
      }
      else
      {
        toggle()
      }
    } 
    else if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) 
    {
      close(true)
    } 
    else if (event.key === Qt.Key_Escape) 
    {
      close(false)
    }
  }

  Rectangle 
  {
    id: dropDown
    width: container.width; height: 0
    anchors.top: container.bottom
    anchors.topMargin: 0
    color: container.menuColor
    clip: true
    Behavior on height { NumberAnimation { duration: 100 } }

    Component 
    {
      id: myDelegate
      Rectangle 
      {
        width: dropDown.width - 3; height: container.height - 3
        color: "transparent"

        Loader 
        {
          id: loader
          anchors.fill: parent
          sourceComponent: rowDelegate
          property variant modelItem: model
        }
        property variant modelItem: model

        MouseArea 
        {
          id: delegateMouseArea
          anchors.fill: parent
          hoverEnabled: true
          onEntered: listView.currentIndex = index
          onClicked: close(true)
        }
      }
    }

    ListView 
    {
      id: listView
      width: container.width; height: (container.height - 2*container.borderWidth) * count + container.borderWidth
      delegate: myDelegate
      highlight: Rectangle 
      {
        anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined;
        color: container.hoverColor
      }
    }

    Rectangle 
    {
      anchors.fill: listView
      anchors.topMargin: -container.borderWidth
      color: "transparent"
      clip: false
      border.color: borderColor
      // border.width: 1
      border.width: main.border.width
    }

    states: [
      State 
      {
        name: "visible";
        PropertyChanges { target: dropDown; height: (container.height - 2*container.borderWidth) * listView.count + container.borderWidth}
      }
    ]
  }

  function toggle() 
  {
    if (dropDown.state === "visible")
    {
      close(false)
    }
    else
    {
      open()
    }
  }

  function open() 
  {
    dropDown.state = "visible"
    listView.currentIndex = container.index
  }

  function close(update) 
  {
    dropDown.state = ""

    if (update) 
    {
      container.index = listView.currentIndex
      topRow.modelItem = listView.currentItem.modelItem

      valueChanged(listView.currentIndex)
    }
  }

  Component.onCompleted: 
  {
    listView.currentIndex = container.index

    if (listView.currentItem)
    {
      topRow.modelItem = listView.currentItem.modelItem
    }
  }

  onIndexChanged: 
  {
    listView.currentIndex = container.index

    if (listView.currentItem)
    {
      topRow.modelItem = listView.currentItem.modelItem
    }
  }

  onModelChanged: 
  {
    listView.currentIndex = container.index

    if (listView.currentItem)
    {
      topRow.modelItem = listView.currentItem.modelItem
    }
  }
}
