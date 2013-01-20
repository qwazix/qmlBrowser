// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.hildon.components 1.0

Item {
    id: container

    property alias url: urlText.text

    signal urlEntered(string url)
    signal urlChanged

    width: parent.width; height: childrenRect.height

    CustomTitleBar{
        id: titleBar
    }

    Rectangle{
        height: childrenRect.height
        color: theme.defaultBackgroundColor
        Row{
            height: childrenRect.height
            width: back.width
            id: buttons
            anchors.left: parent.left
            anchors.right: urlText.left
            ToolButton{
                id: back
                iconSource: "back.svg"
                onClicked: webView.back.trigger()
            }
        }

        TextField {
            id: urlText
    //        horizontalAlignment: TextEdit.AlignLeft
    //        font.pixelSize: 14;

            onTextChanged: container.urlChanged()

            Keys.onEscapePressed: {
                urlText.text = webView.url
                webView.focus = true
  ke          }

            Keys.onEnterPressed: {
                container.urlEntered(urlText.text)
                webView.focus = true
            }

            Keys.onReturnPressed: {
                container.urlEntered(urlText.text)
                webView.focus = true
            }
            anchors.right: parent.right
            anchors.left: buttons.right
        }

        anchors {
            left: parent.left; right: parent.right;
            top: titleBar.bottom
//            verticalCenter: parent.verticalCenter
        }
    }
}
