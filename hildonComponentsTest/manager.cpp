#include "manager.h"
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusMessage>

manager::manager(QObject *parent) :
    QObject(parent)
{

}

void manager::minimize(){
#ifdef Q_WS_MAEMO_5
    QDBusConnection c = QDBusConnection::sessionBus();
    QDBusMessage m = QDBusMessage::createSignal("/", "com.nokia.hildon_desktop", "exit_app_view");
    c.send(m);
#endif
}
