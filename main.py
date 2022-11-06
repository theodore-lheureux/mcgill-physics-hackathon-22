import sys, os
import module.base
import module.position

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQuick import QQuickView

def main():
    os.environ["QT_QUICK_CONTROLS_CONF"] = "config.ini"
    app = QGuiApplication(sys.argv)

    view = QQuickView()
    view.setSource(QUrl("main.qml"))
    view.setTitle("Lagrange Points")
    view.setIcon(QIcon("assets/appicon.png"))
    view.setWidth(1280)
    view.setHeight(720)
    view.show()

    sys.exit(app.exec())

if __name__ == "__main__": 
    main()