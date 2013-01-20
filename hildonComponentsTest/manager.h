#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>
#include <QApplication>

class manager : public QObject
{
    Q_OBJECT
public:
    explicit manager(QObject *parent = 0);
    manager(QApplication*);
    Q_INVOKABLE void minimize();


signals:
    
public slots:
    
};

#endif // MANAGER_H
