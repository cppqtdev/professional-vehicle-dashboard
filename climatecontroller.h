#ifndef CLIMATECONTROLLER_H
#define CLIMATECONTROLLER_H

#include <QObject>

class ClimateController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(qreal driverTemp READ driverTemp WRITE setDriverTemp NOTIFY climateChanged)
    Q_PROPERTY(qreal passengerTemp READ passengerTemp WRITE setPassengerTemp NOTIFY climateChanged)
    Q_PROPERTY(qreal fanSpeed READ fanSpeed WRITE setFanSpeed NOTIFY climateChanged)
    Q_PROPERTY(bool autoMode READ autoMode WRITE setAutoMode NOTIFY climateChanged)
    Q_PROPERTY(bool acOn READ acOn WRITE setAcOn NOTIFY climateChanged)
    Q_PROPERTY(bool defrostOn READ defrostOn WRITE setDefrostOn NOTIFY climateChanged)
    Q_PROPERTY(bool seatHeatOn READ seatHeatOn WRITE setSeatHeatOn NOTIFY climateChanged)

public:
    explicit ClimateController(QObject *parent = nullptr);

    qreal driverTemp() const;
    qreal passengerTemp() const;
    qreal fanSpeed() const;
    bool autoMode() const;
    bool acOn() const;
    bool defrostOn() const;
    bool seatHeatOn() const;

    void setDriverTemp(qreal temp);
    void setPassengerTemp(qreal temp);
    void setFanSpeed(qreal speed);
    void setAutoMode(bool enabled);
    void setAcOn(bool enabled);
    void setDefrostOn(bool enabled);
    void setSeatHeatOn(bool enabled);

    Q_INVOKABLE void stepDriverTemp(qreal delta);
    Q_INVOKABLE void stepPassengerTemp(qreal delta);
    Q_INVOKABLE void toggleAutoMode();
    Q_INVOKABLE void toggleAc();
    Q_INVOKABLE void toggleDefrost();
    Q_INVOKABLE void toggleSeatHeat();

signals:
    void climateChanged();

private:
    static qreal clampTemp(qreal temp);
    static qreal clamp01(qreal value);

    qreal m_driverTemp = 18.0;
    qreal m_passengerTemp = 18.0;
    qreal m_fanSpeed = 0.62;
    bool m_autoMode = true;
    bool m_acOn = true;
    bool m_defrostOn = false;
    bool m_seatHeatOn = false;
};

#endif // CLIMATECONTROLLER_H
