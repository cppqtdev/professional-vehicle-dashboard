#ifndef QUICKSETTINGSCONTROLLER_H
#define QUICKSETTINGSCONTROLLER_H

#include <QObject>

class QuickSettingsController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool cellularOn READ cellularOn WRITE setCellularOn NOTIFY quickSettingsChanged)
    Q_PROPERTY(bool bluetoothOn READ bluetoothOn WRITE setBluetoothOn NOTIFY quickSettingsChanged)
    Q_PROPERTY(bool notificationsMuted READ notificationsMuted WRITE setNotificationsMuted NOTIFY quickSettingsChanged)
    Q_PROPERTY(bool hotspotOn READ hotspotOn WRITE setHotspotOn NOTIFY quickSettingsChanged)
    Q_PROPERTY(qreal volume READ volume WRITE setVolume NOTIFY quickSettingsChanged)
    Q_PROPERTY(qreal brightness READ brightness WRITE setBrightness NOTIFY quickSettingsChanged)

public:
    explicit QuickSettingsController(QObject *parent = nullptr);

    bool cellularOn() const;
    bool bluetoothOn() const;
    bool notificationsMuted() const;
    bool hotspotOn() const;
    qreal volume() const;
    qreal brightness() const;

    void setCellularOn(bool enabled);
    void setBluetoothOn(bool enabled);
    void setNotificationsMuted(bool muted);
    void setHotspotOn(bool enabled);
    void setVolume(qreal volume);
    void setBrightness(qreal brightness);

    Q_INVOKABLE void toggleCellular();
    Q_INVOKABLE void toggleBluetooth();
    Q_INVOKABLE void toggleNotifications();
    Q_INVOKABLE void toggleHotspot();

signals:
    void quickSettingsChanged();

private:
    static qreal clamp01(qreal value);

    bool m_cellularOn = true;
    bool m_bluetoothOn = false;
    bool m_notificationsMuted = true;
    bool m_hotspotOn = false;
    qreal m_volume = 0.32;
    qreal m_brightness = 0.6;
};

#endif // QUICKSETTINGSCONTROLLER_H
