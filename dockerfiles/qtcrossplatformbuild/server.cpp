// server.cpp
#include <QCoreApplication>
#include <QWebSocketServer>
#include <QWebSocket>
#include <QDebug>

class WebSocketServer : public QObject {
    Q_OBJECT

public:
    WebSocketServer(quint16 port, QObject *parent = nullptr)
        : QObject(parent), m_pWebSocketServer(new QWebSocketServer(QStringLiteral("Echo Server"),
                                                                    QWebSocketServer::NonSecureMode, this))
    {
        if (m_pWebSocketServer->listen(QHostAddress::Any, port)) {
            qDebug() << "WebSocket server listening on port" << port;
            connect(m_pWebSocketServer, &QWebSocketServer::newConnection,
                    this, &WebSocketServer::onNewConnection);
        }
    }

private slots:
    void onNewConnection() {
        QWebSocket *pSocket = m_pWebSocketServer->nextPendingConnection();

        connect(pSocket, &QWebSocket::textMessageReceived, this, [this, pSocket](const QString &message) {
            qDebug() << "Message received:" << message;
            pSocket->sendTextMessage(QStringLiteral("WebSocket Received your message: %1").arg(message));
        });

        connect(pSocket, &QWebSocket::disconnected, pSocket, &QWebSocket::deleteLater);
    }

private:
    QWebSocketServer *m_pWebSocketServer;
};

int main(int argc, char *argv[]) {
    QCoreApplication a(argc, argv);

    WebSocketServer server(12345);

    return a.exec();
}

#include "server.moc"

