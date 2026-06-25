#include "quicksettingscontroller.h"

#include <algorithm>

QuickSettingsController::QuickSettingsController(QObject *parent)
    : QObject(parent)
{
}

bool QuickSettingsController::cellularOn() const { return m_cellularOn; }
bool QuickSettingsController::bluetoothOn() const { return m_bluetoothOn; }
bool QuickSettingsController::notificationsMuted() const { return m_notificationsMuted; }
bool QuickSettingsController::hotspotOn() const { return m_hotspotOn; }
qreal QuickSettingsController::volume() const { return m_volume; }
qreal QuickSettingsController::brightness() const { return m_brightness; }

void QuickSettingsController::setCellularOn(bool enabled)
{
    if (m_cellularOn == enabled)
        return;
    m_cellularOn = enabled;
    emit quickSettingsChanged();
}

void QuickSettingsController::setBluetoothOn(bool enabled)
{
    if (m_bluetoothOn == enabled)
        return;
    m_bluetoothOn = enabled;
    emit quickSettingsChanged();
}

void QuickSettingsController::setNotificationsMuted(bool muted)
{
    if (m_notificationsMuted == muted)
        return;
    m_notificationsMuted = muted;
    emit quickSettingsChanged();
}

void QuickSettingsController::setHotspotOn(bool enabled)
{
    if (m_hotspotOn == enabled)
        return;
    m_hotspotOn = enabled;
    emit quickSettingsChanged();
}

void QuickSettingsController::setVolume(qreal volume)
{
    const qreal normalized = clamp01(volume);
    if (qFuzzyCompare(m_volume, normalized))
        return;
    m_volume = normalized;
    emit quickSettingsChanged();
}

void QuickSettingsController::setBrightness(qreal brightness)
{
    const qreal normalized = clamp01(brightness);
    if (qFuzzyCompare(m_brightness, normalized))
        return;
    m_brightness = normalized;
    emit quickSettingsChanged();
}

void QuickSettingsController::toggleCellular() { setCellularOn(!m_cellularOn); }
void QuickSettingsController::toggleBluetooth() { setBluetoothOn(!m_bluetoothOn); }
void QuickSettingsController::toggleNotifications() { setNotificationsMuted(!m_notificationsMuted); }
void QuickSettingsController::toggleHotspot() { setHotspotOn(!m_hotspotOn); }

qreal QuickSettingsController::clamp01(qreal value)
{
    return std::clamp(value, 0.0, 1.0);
}
