from PySide6.QtCore import QObject, Slot, QPointF
from PySide6.QtQml import QmlElement
from PySide6.QtGui import QIcon
from PySide6.QtWidgets import QWidget, QMessageBox

QML_IMPORT_NAME = "com.hackathon.base"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
class Base(QObject):
    @Slot()
    def about(self):
        parent = QWidget()
        parent.setWindowIcon(QIcon("assets/app_icon.png"))
        QMessageBox.about(parent, "Lagrange Point Visualizer", "This is a visualizer for Lagrange points.\n\nLagrange points are points where the gravitational forces of two orbiting bodies cancel each other out.\n\nThis visualizer was created by the League of Protogens team for the 2022 McGill Physics Hackathon. Thanks to Kenneth for the cute name.\n\nAUTHORS\n- Eric Deng: Equation solving, backend programming\n- Theodore l'Heureux: Logic solving, backend and frontend programming\n- Maxime Gagnon: Frontend programming, backend porting, QA\n- Kenneth Chen: Frontend programming, QA\n- David Vo: Moral support, QA\n\nBuilt with Python and Qt Quick (QML), using Pyside6 bindings.")

    @Slot()
    def aboutQt(self):
        QMessageBox.aboutQt(None)

    @Slot(float, float, float, result=list)
    def lagrange_dist(self, M1, M2, R):
        try:
            # Distance from M1 to Lagrange points
            d1 = R-R*(1-(M2/(3*M1))**(1/3))
            d2 = R-R*(1+(M2/(3*M1))**(1/3))
            d3 = R- R*(1-(7*M2/(12*M1)))
        except ZeroDivisionError:
            # Will add something here
            a = 0
        return [d1, d2, d3]

    @Slot(float, float, float, result=QPointF)
    def barycenter(self, M1, M2, R):
        try:
            d_bary_M1 = R*(M2/(M1+M2))
            d_bary_M2 = R - d_bary_M1
        except ZeroDivisionError:
            # Will fill later
            a = 0
        return QPointF(d_bary_M1, d_bary_M2)

    @Slot(float, float, float, float, result=float)
    def rotation_period(self, M1, M2, d_bary_M1, d_bary_M2):
        L = d_bary_M1 + d_bary_M2
        G = 6.67*(10**-11)
        try:
            T = 2*3.1416*L*(L/(G*(M1 + M2)))
        except ZeroDivisionError:
            a = 0
        return T

    

# print(Lagrange_dist(10, 1, 2))
# print(barycenter(10, 1, 1))
# print*(rotation_period(1, 1, 1, 1, 1))