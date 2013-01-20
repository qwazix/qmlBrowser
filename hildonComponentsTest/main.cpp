#include <QtGui/QApplication>
#include "qmlapplicationviewer.h"
#include <QDeclarativeContext>
#include "manager.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    manager mn;

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);

    app->setStartDragDistance(20);

    viewer.rootContext()->setContextProperty("mn", &mn);
    viewer.setMainQmlFile(QLatin1String("qml/hildonComponentsTest/main.qml"));
    viewer.showFullScreen();

    return app->exec();
}
