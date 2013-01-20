// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
import org.hildon.components 1.0
//import com.nokia.meego 1.0

Rectangle{
    id: webBrowser

     property string urlString : "http://talk.maemo.org"

     width: 800; height: 480
     color: "#343434"

     FlickableWebView {
         id: webView
         url: webBrowser.urlString
         anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom }
     }

     ToolButton{
         id: cursorMode
         iconSource: "cursorMode.svg"
         visible: webView.cursorMode
         x: 0
         y: parent.height*0.7
         onClicked: webView.cursorMode = false
     }

}

//Rectangle{
//    width: 800
//    height: 380
//    TextField{
//        width: parent.width
//    }
//}
