#ifndef VEHICLECONTROLLER_H
#define VEHICLECONTROLLER_H

#include <QObject>

class VehicleController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool centralLock READ centralLock WRITE setCentralLock NOTIFY vehicleChanged)
    Q_PROPERTY(bool fuelTankLock READ fuelTankLock WRITE setFuelTankLock NOTIFY vehicleChanged)
    Q_PROPERTY(bool trunkOpen READ trunkOpen WRITE setTrunkOpen NOTIFY vehicleChanged)
    Q_PROPERTY(bool hybridMode READ hybridMode WRITE setHybridMode NOTIFY vehicleChanged)
    Q_PROPERTY(bool lightControl READ lightControl WRITE setLightControl NOTIFY vehicleChanged)
    Q_PROPERTY(bool specialRoad READ specialRoad WRITE setSpecialRoad NOTIFY vehicleChanged)
    Q_PROPERTY(int controlTab READ controlTab WRITE setControlTab NOTIFY vehicleChanged)
    Q_PROPERTY(qreal batteryLevel READ batteryLevel WRITE setBatteryLevel NOTIFY vehicleChanged)
    Q_PROPERTY(int rangeKm READ rangeKm NOTIFY vehicleChanged)
    Q_PROPERTY(qreal consumption READ consumption WRITE setConsumption NOTIFY vehicleChanged)
    Q_PROPERTY(qreal regen READ regen WRITE setRegen NOTIFY vehicleChanged)
    Q_PROPERTY(int batteryTemp READ batteryTemp WRITE setBatteryTemp NOTIFY vehicleChanged)
    Q_PROPERTY(bool charging READ charging WRITE setCharging NOTIFY vehicleChanged)
    Q_PROPERTY(bool parkedAllowed READ parkedAllowed NOTIFY vehicleChanged)
    Q_PROPERTY(bool vehicleMoving READ vehicleMoving WRITE setVehicleMoving NOTIFY vehicleChanged)
    Q_PROPERTY(bool windowsClosed READ windowsClosed WRITE setWindowsClosed NOTIFY vehicleChanged)
    Q_PROPERTY(int tirePressureWarning READ tirePressureWarning WRITE setTirePressureWarning NOTIFY vehicleChanged)

public:
    explicit VehicleController(QObject *parent = nullptr);

    bool centralLock() const;
    bool fuelTankLock() const;
    bool trunkOpen() const;
    bool hybridMode() const;
    bool lightControl() const;
    bool specialRoad() const;
    int controlTab() const;
    qreal batteryLevel() const;
    int rangeKm() const;
    qreal consumption() const;
    qreal regen() const;
    int batteryTemp() const;
    bool charging() const;
    bool parkedAllowed() const;
    bool vehicleMoving() const;
    bool windowsClosed() const;
    int tirePressureWarning() const;

    void setCentralLock(bool locked);
    void setFuelTankLock(bool locked);
    void setTrunkOpen(bool open);
    void setHybridMode(bool enabled);
    void setLightControl(bool enabled);
    void setSpecialRoad(bool enabled);
    void setControlTab(int tab);
    void setBatteryLevel(qreal level);
    void setConsumption(qreal consumption);
    void setRegen(qreal regen);
    void setBatteryTemp(int temp);
    void setCharging(bool charging);
    void setVehicleMoving(bool moving);
    void setWindowsClosed(bool closed);
    void setTirePressureWarning(int tireIndex);

    Q_INVOKABLE void toggleCentralLock();
    Q_INVOKABLE void toggleFuelTankLock();
    Q_INVOKABLE void toggleTrunk();
    Q_INVOKABLE void toggleHybridMode();
    Q_INVOKABLE void toggleLightControl();
    Q_INVOKABLE void toggleSpecialRoad();
    Q_INVOKABLE void toggleCharging();

signals:
    void vehicleChanged();

private:
    void updateRange();

    bool m_centralLock = true;
    bool m_fuelTankLock = false;
    bool m_trunkOpen = false;
    bool m_hybridMode = true;
    bool m_lightControl = false;
    bool m_specialRoad = false;
    int m_controlTab = 0;
    qreal m_batteryLevel = 0.78;
    int m_rangeKm = 412;
    qreal m_consumption = 16.2;
    qreal m_regen = 2.1;
    int m_batteryTemp = 24;
    bool m_charging = false;
    bool m_parkedAllowed = true;
    bool m_vehicleMoving = false;
    bool m_windowsClosed = true;
    int m_tirePressureWarning = -1;
};

#endif // VEHICLECONTROLLER_H
