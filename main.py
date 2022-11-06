import sys, os
import module.base
import module.position

from PySide6.QtCore import Qt, QUrl, QSize
from PySide6.QtGui import QIcon
from PySide6.QtQuick import QQuickView
from PySide6.QtWidgets import QApplication

def main():
    os.environ["QT_QUICK_CONTROLS_CONF"] = "config.ini"
    app = QApplication(sys.argv)

    view = QQuickView()
    view.setSource(QUrl("main.qml"))
    view.setTitle("Lagrange Points")
    view.setIcon(QIcon("assets/app_icon_small.png"))
    view.setWidth(1280)
    view.setHeight(720)
    view.setMinimumSize(QSize(1280, 720))
    view.setColor(Qt.transparent)
    view.setModality(Qt.WindowModal)
    view.setFlags(Qt.FramelessWindowHint | Qt.CustomizeWindowHint | Qt.Window | Qt.WindowStaysOnTopHint)
    view.engine().quit.connect(app.quit)
    view.show()

    sys.exit(app.exec())

if __name__ == "__main__": 
    main()