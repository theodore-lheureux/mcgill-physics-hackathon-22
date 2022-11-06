import math

from PySide6.QtCore import QObject, Slot, QPointF, QPointFList
from PySide6.QtQml import QmlElement

QML_IMPORT_NAME = "com.hackathon.position"
QML_IMPORT_MAJOR_VERSION = 1

global velocity, calculateVelo
velocity = 0
calculateVelo = 0

@QmlElement
class Position(QObject): 
    # Run twice, first inverted for m1, thnon-inverted for m2
    @Slot(float, float, bool, result=QPointF)
    def pos_object(self, angle, bary_distance, inverted=False):
        x = bary_distance * math.cos(angle)
        y = bary_distance * math.sin(angle)
        return QPointF(x, y) if inverted else QPointF(-x, -y)

    @Slot(float, float, float, float, float, float, float, float, float, float, result=list)
    def pos_lagrange(self, d1, d2, d3, x1, y1, bary_distance, R, ang, m1, m2):
        L1x = d1*math.cos(ang) + x1
        L1y = d1*math.sin(ang) + y1
        L2x = d2*math.cos(ang) + x1
        L2y = d2*math.sin(ang) + y1
        L3x = -1 * d3*math.sin(ang) - x1
        L3y = -1 * d3*math.cos(ang) - y1
        L4x = R*math.cos(ang+math.pi/3)+x1
        L4y = R*math.sin(ang+math.pi/3)+y1
        L5x = R*math.cos(ang-math.pi/3)+x1
        L5y = R*math.sin(ang-math.pi/3)+y1
        if m1/m2 > 24:
            return [QPointF(L1x, L1y), QPointF(L2x, L2y), QPointF(L3x, L3y), QPointF(L4x, L4y), QPointF(L5x, L5y)]
        else:
            return [QPointF(L1x, L1y), QPointF(L2x, L2y), QPointF(L3x, L3y), QPointF(), QPointF()]


    @Slot(float, float, float, float, float, float, float, float, float, float, float, result=QPointF)
    def pos_object3(self, M1, M2, x1, y1, x2, y2, x3, y3, v, v_ang, T):
        vx = v * math.cos(v_ang)
        vy = v* math.sin(v_ang)
        # Assuming F = ma where m = 1
        # m = M1/100000
        G = 6.67*(10**-11)
        dist_m1 = math.sqrt((y3-y1)**2+(x3-x1)**2)
        dist_m2 = math.sqrt((y3-y2)**2+(x3-x2)**2)
        ang1 = math.atan((y1-y3)/(x1-x3))  
        ang2 = math.atan((y2-y3)/(x2-x3))
        Fm1 = (G*M1)/(dist_m1**2)
        Fm2 = (G*M2)/(dist_m2**2)
        Fm1x = abs((G*M1)/(dist_m1**2)) if x3-x1 < 0 else -abs((G*M1)/(dist_m1**2))
        Fm1y = abs((G*M1)/(dist_m1**2)) if y3-y1 < 0 else -abs((G*M1)/(dist_m1**2))
        Fm2x = abs((G*M2)/(dist_m2**2)) if x3-x2 < 0 else -abs((G*M2)/(dist_m2**2))
        Fm2y = abs((G*M2)/(dist_m2**2)) if y3-y2 < 0 else -abs((G*M2)/(dist_m2**2))
        # Fnetx = Fm1*math.cos(ang1) + Fm2*math.cos(ang2)
        # Fnety = Fm1*math.sin(ang1) + Fm2*math.sin(ang2)
        Fnetx = Fm1x + Fm2x
        Fnety = Fm1y + Fm2y
        t = 0.1/(2*math.pi)*T
        pos_x = vx*1.1 + 1/2*Fnetx*1.1**2*10**12 + x3
        pos_y = vy*1.1 + 1/2*Fnety*1.1**2*10**12 + y3
        if 1/2*Fnetx*1.1**2*10**12 > 3 or 1/2*Fnetx*1.1**2*10**12 < -3 or 1/2*Fnety*1.1**2*10**12 < -3 or 1/2*Fnety*1.1**2*10**12 > 3:
            return QPointF()
        return QPointF(pos_x, pos_y)
        
    
    