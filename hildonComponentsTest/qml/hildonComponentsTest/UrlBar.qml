// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.hildon.components 1.0

Item {
    id: container

    property alias url: urlText.text

    signal urlEntered(string url)
    signal urlChanged

    width: parent.width; height: childrenRect.height

    TextField {
        id: urlText
//        horizontalAlignment: TextEdit.AlignLeft
//        font.pixelSize: 14;

        onTextChanged: container.urlChanged()

        Keys.onEscapePressed: {
            urlText.text = webView.url
            webView.focus = true
        }

        Keys.onEnterPressed: {
            container.urlEntered(urlText.text)
            webView.focus = true
        }

        Keys.onReturnPressed: {
            container.urlEntered(urlText.text)
            webView.focus = true
        }

        anchors {
            left: parent.left; right: parent.right;
//            verticalCenter: parent.verticalCenter
        }
    }
}
