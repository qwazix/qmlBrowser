// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import QtWebKit 1.0

 Flickable {
     property alias title: webView.title
     property alias icon: webView.icon
     property alias progress: webView.progress
     property alias url: webView.url
     property alias back: webView.back
     property alias stop: webView.stop
     property alias reload: webView.reload
     property alias forward: webView.forward

     property bool swipeFromTopEdge : false
     property int startMousePos: 0

     id: flickable
     width: parent.width
     contentWidth: Math.max(parent.width,webView.width)
     contentHeight: Math.max(parent.height,webView.height+ header.height)
     anchors.bottom: parent.top
     anchors.left: parent.left
     anchors.right: parent.right
     pressDelay: 200


     onMovementStarted: {
//         console.log(mouseArea.mouseY - flickable.contentY)
         if (mouseArea.mouseY - flickable.contentY < 20) flickable.swipeFromTopEdge = true;
         else flickable.swipeFromTopEdge = false;
         flickable.startMousePos = mouseArea.mouseY

//         if (mouseArea.mouseX < 100) enabled= false; else enabled = true;
         console.log('flickStarted')
//         console.log(mouseArea.mouseX,mouseArea.mouseY)
     }


     MouseArea{
         id: mouseArea
         z: 8
         anchors.fill: parent;
         preventStealing : true
         onPressed: {
             console.log("pressed")
             mouse.accepted = false
//             if (mouseArea.mouseY - flickable.contentY < 20) flickable.swipeFromTopEdge = true;
//             else flickable.swipeFromTopEdge = false;
//             flickable.startMousePos = mouseArea.mouseY
         }
         hoverEnabled: true
     }

     onWidthChanged : {
         // Expand (but not above 1:1) if otherwise would be smaller that available width.
         if (width > webView.width*webView.contentsScale && webView.contentsScale < 1.0)
             webView.contentsScale = width / webView.width * webView.contentsScale;
     }

     onContentXChanged: header.x = contentX
     onContentYChanged:{
         if (flickable.swipeFromTopEdge)
             if (flickable.startMousePos - header.height <= contentY)
                header.y = flickable.startMousePos - header.height
             else header.y = contentY
         else header.y = 0;
//         console.log(contentY)
     }

     onProgressChanged: header.urlChangedFlag = false

     UrlBar{
         id: header
         property bool urlChangedFlag: false
         width: Math.min(parent.width,parent.parent.width);
         z: 4
         onUrlEntered: {
             var u;
             if (url.match(/^http:\/\//)) u = url
             else u = "http://" + url
//             webView.url = url
                              webBrowser.urlString = u
                              webBrowser.focus = true
                              header.urlChangedFlag = false
                          }
     }

     WebView {
         id: webView
         transformOrigin: Item.TopLeft
         y: header.height


         function fixUrl(url)
         {
             if (url == "") return url
             if (url[0] == "/") return "file://"+url
             if (url.indexOf(":")<0) {
                 if (url.indexOf(".")<0 || url.indexOf(" ")>=0) {
                     // Fall back to a search engine; hard-code Wikipedia
                     return "http://en.wikipedia.org/w/index.php?search="+url
                 } else {
                     return "http://"+url
                 }
             }
             return url
         }

         url: fixUrl(webBrowser.urlString)
         smooth: false // We don't want smooth scaling, since we only scale during (fast) transitions
         focus: true

         onAlert: console.log(message)

         function doZoom(zoom,centerX,centerY)
         {
             if (centerX) {
                 var sc = zoom*contentsScale;
                 scaleAnim.to = sc;
                 flickVX.from = flickable.contentX
                 flickVX.to = Math.max(0,Math.min(centerX-flickable.width/2,webView.width*sc-flickable.width))
                 finalX.value = flickVX.to
                 flickVY.from = flickable.contentY
                 flickVY.to = Math.max(0,Math.min(centerY-flickable.height/2,webView.height*sc-flickable.height))
                 finalY.value = flickVY.to
                 quickZoom.start()
             }
         }

         Keys.onLeftPressed: webView.contentsScale -= 0.1
         Keys.onRightPressed: webView.contentsScale += 0.1

         preferredWidth: flickable.width
         preferredHeight: flickable.height
         contentsScale: 1
         onContentsSizeChanged: {
             // zoom out
             contentsScale = Math.min(1,flickable.width / contentsSize.width)
         }
         onUrlChanged: {
             // got to topleft
             flickable.contentX = 0
             flickable.contentY = 0
             if (url != null) { header.url = url.toString(); }
         }
         onDoubleClick: {
                         if (!heuristicZoom(clickX,clickY,2.5)) {
                             var zf = flickable.width / contentsSize.width
                             if (zf >= contentsScale)
                                 zf = 2.0*contentsScale // zoom in (else zooming out)
                             doZoom(zf,clickX*zf,clickY*zf)
                          }
                        }

         SequentialAnimation {
             id: quickZoom

             PropertyAction {
                 target: webView
                 property: "renderingEnabled"
                 value: false
             }
             ParallelAnimation {
                 NumberAnimation {
                     id: scaleAnim
                     target: webView
                     property: "contentsScale"
                     // the to property is set before calling
                     easing.type: Easing.Linear
                     duration: 200
                 }
                 NumberAnimation {
                     id: flickVX
                     target: flickable
                     property: "contentX"
                     easing.type: Easing.Linear
                     duration: 200
                     from: 0 // set before calling
                     to: 0 // set before calling
                 }
                 NumberAnimation {
                     id: flickVY
                     target: flickable
                     property: "contentY"
                     easing.type: Easing.Linear
                     duration: 200
                     from: 0 // set before calling
                     to: 0 // set before calling
                 }
             }
             // Have to set the contentXY, since the above 2
             // size changes may have started a correction if
             // contentsScale < 1.0.
             PropertyAction {
                 id: finalX
                 target: flickable
                 property: "contentX"
                 value: 0 // set before calling
             }
             PropertyAction {
                 id: finalY
                 target: flickable
                 property: "contentY"
                 value: 0 // set before calling
             }
             PropertyAction {
                 target: webView
                 property: "renderingEnabled"
                 value: true
             }
         }
         onZoomTo: doZoom(zoom,centerX,centerY)
     }
 }