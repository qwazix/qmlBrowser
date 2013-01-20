// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0
import org.hildon.components 1.0
//import com.nokia.meego 1.0

Rectangle{
    id: webBrowser

     property string urlString : "http://communities-dominate.blogs.com" //"http://localhost/"

     width: 800; height: 480
     color: "#343434"

     Rectangle {
         height: 4; color: "#63b1ed"
         anchors.top: parent.top
         z: 4
         width: (parent.width - 20) * webView.progress
         opacity: webView.progress == 1.0 ? 0.0 : 1.0
     }

     FlickableWebView {
         id: webView
         url: webBrowser.urlString
         anchors { top: parent.top; left: parent.left; right: parent.right; bottom: parent.bottom }
     }

}

//Rectangle{
//    width: 800
//    height: 380
//    TextField{
//        width: parent.width
//    }
//}
