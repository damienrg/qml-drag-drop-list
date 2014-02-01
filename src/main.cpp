#include <QtGui/QGuiApplication>
#include <QQuickView>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView viewer;
    viewer.setSource(QUrl::fromLocalFile("qml/main.qml"));
    viewer.show();

    return app.exec();
}
