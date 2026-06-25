#include "climatecontroller.h"

#include <algorithm>

ClimateController::ClimateController(QObject *parent)
    : QObject(parent)
{
}

qreal ClimateController::driverTemp() const { return m_driverTemp; }
qreal ClimateController::passengerTemp() const { return m_passengerTemp; }
qreal ClimateController::fanSpeed() const { return m_fanSpeed; }
bool ClimateController::autoMode() const { return m_autoMode; }
bool ClimateController::acOn() const { return m_acOn; }
bool ClimateController::defrostOn() const { return m_defrostOn; }
bool ClimateController::seatHeatOn() const { return m_seatHeatOn; }

void ClimateController::setDriverTemp(qreal temp)
{
    const qreal normalized = clampTemp(temp);
    if (qFuzzyCompare(m_driverTemp, normalized))
        return;
    m_driverTemp = normalized;
    emit climateChanged();
}

void ClimateController::setPassengerTemp(qreal temp)
{
    const qreal normalized = clampTemp(temp);
    if (qFuzzyCompare(m_passengerTemp, normalized))
        return;
    m_passengerTemp = normalized;
    emit climateChanged();
}

void ClimateController::setFanSpeed(qreal speed)
{
    const qreal normalized = clamp01(speed);
    if (qFuzzyCompare(m_fanSpeed, normalized))
        return;
    m_fanSpeed = normalized;
    if (normalized > 0.0)
        m_autoMode = false;
    emit climateChanged();
}

void ClimateController::setAutoMode(bool enabled)
{
    if (m_autoMode == enabled)
        return;
    m_autoMode = enabled;
    if (enabled)
        m_fanSpeed = 0.62;
    emit climateChanged();
}

void ClimateController::setAcOn(bool enabled)
{
    if (m_acOn == enabled)
        return;
    m_acOn = enabled;
    emit climateChanged();
}

void ClimateController::setDefrostOn(bool enabled)
{
    if (m_defrostOn == enabled)
        return;
    m_defrostOn = enabled;
    if (enabled) {
        m_acOn = true;
        m_fanSpeed = std::max(m_fanSpeed, 0.72);
    }
    emit climateChanged();
}

void ClimateController::setSeatHeatOn(bool enabled)
{
    if (m_seatHeatOn == enabled)
        return;
    m_seatHeatOn = enabled;
    emit climateChanged();
}

void ClimateController::stepDriverTemp(qreal delta)
{
    setDriverTemp(m_driverTemp + delta);
}

void ClimateController::stepPassengerTemp(qreal delta)
{
    setPassengerTemp(m_passengerTemp + delta);
}

void ClimateController::toggleAutoMode() { setAutoMode(!m_autoMode); }
void ClimateController::toggleAc() { setAcOn(!m_acOn); }
void ClimateController::toggleDefrost() { setDefrostOn(!m_defrostOn); }
void ClimateController::toggleSeatHeat() { setSeatHeatOn(!m_seatHeatOn); }

qreal ClimateController::clampTemp(qreal temp)
{
    return std::clamp(temp, 16.0, 30.0);
}

qreal ClimateController::clamp01(qreal value)
{
    return std::clamp(value, 0.0, 1.0);
}
