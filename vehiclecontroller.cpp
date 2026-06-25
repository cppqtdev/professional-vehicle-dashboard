#include "vehiclecontroller.h"

#include <algorithm>
#include <QtMath>

VehicleController::VehicleController(QObject *parent)
    : QObject(parent)
{
    updateRange();
}

bool VehicleController::centralLock() const { return m_centralLock; }
bool VehicleController::fuelTankLock() const { return m_fuelTankLock; }
bool VehicleController::trunkOpen() const { return m_trunkOpen; }
bool VehicleController::hybridMode() const { return m_hybridMode; }
bool VehicleController::lightControl() const { return m_lightControl; }
bool VehicleController::specialRoad() const { return m_specialRoad; }
int VehicleController::controlTab() const { return m_controlTab; }
qreal VehicleController::batteryLevel() const { return m_batteryLevel; }
int VehicleController::rangeKm() const { return m_rangeKm; }
qreal VehicleController::consumption() const { return m_consumption; }
qreal VehicleController::regen() const { return m_regen; }
int VehicleController::batteryTemp() const { return m_batteryTemp; }
bool VehicleController::charging() const { return m_charging; }
bool VehicleController::parkedAllowed() const { return m_parkedAllowed; }
bool VehicleController::vehicleMoving() const { return m_vehicleMoving; }
bool VehicleController::windowsClosed() const { return m_windowsClosed; }
int VehicleController::tirePressureWarning() const { return m_tirePressureWarning; }

void VehicleController::setCentralLock(bool locked)
{
    if (m_centralLock == locked)
        return;
    m_centralLock = locked;
    if (locked)
        m_windowsClosed = true;
    emit vehicleChanged();
}

void VehicleController::setFuelTankLock(bool locked)
{
    if (m_fuelTankLock == locked)
        return;
    m_fuelTankLock = locked;
    emit vehicleChanged();
}

void VehicleController::setTrunkOpen(bool open)
{
    if (m_trunkOpen == open)
        return;
    m_trunkOpen = open;
    emit vehicleChanged();
}

void VehicleController::setHybridMode(bool enabled)
{
    if (m_hybridMode == enabled)
        return;
    m_hybridMode = enabled;
    updateRange();
    emit vehicleChanged();
}

void VehicleController::setLightControl(bool enabled)
{
    if (m_lightControl == enabled)
        return;
    m_lightControl = enabled;
    emit vehicleChanged();
}

void VehicleController::setSpecialRoad(bool enabled)
{
    if (m_specialRoad == enabled)
        return;
    m_specialRoad = enabled;
    emit vehicleChanged();
}

void VehicleController::setControlTab(int tab)
{
    const int normalized = std::clamp(tab, 0, 2);
    if (m_controlTab == normalized)
        return;
    m_controlTab = normalized;
    emit vehicleChanged();
}

void VehicleController::setBatteryLevel(qreal level)
{
    const qreal normalized = std::clamp(level, 0.0, 1.0);
    if (qFuzzyCompare(m_batteryLevel, normalized))
        return;
    m_batteryLevel = normalized;
    updateRange();
    emit vehicleChanged();
}

void VehicleController::setConsumption(qreal consumption)
{
    const qreal normalized = std::max(0.1, consumption);
    if (qFuzzyCompare(m_consumption, normalized))
        return;
    m_consumption = normalized;
    updateRange();
    emit vehicleChanged();
}

void VehicleController::setRegen(qreal regen)
{
    const qreal normalized = std::max(0.0, regen);
    if (qFuzzyCompare(m_regen, normalized))
        return;
    m_regen = normalized;
    emit vehicleChanged();
}

void VehicleController::setBatteryTemp(int temp)
{
    if (m_batteryTemp == temp)
        return;
    m_batteryTemp = temp;
    emit vehicleChanged();
}

void VehicleController::setCharging(bool charging)
{
    if (m_charging == charging)
        return;
    m_charging = charging;
    if (charging)
        setVehicleMoving(false);
    emit vehicleChanged();
}

void VehicleController::setVehicleMoving(bool moving)
{
    if (m_vehicleMoving == moving)
        return;
    m_vehicleMoving = moving;
    m_parkedAllowed = !moving;
    if (moving)
        m_charging = false;
    emit vehicleChanged();
}

void VehicleController::setWindowsClosed(bool closed)
{
    if (m_windowsClosed == closed)
        return;
    m_windowsClosed = closed;
    emit vehicleChanged();
}

void VehicleController::setTirePressureWarning(int tireIndex)
{
    const int normalized = tireIndex >= 0 && tireIndex < 4 ? tireIndex : -1;
    if (m_tirePressureWarning == normalized)
        return;
    m_tirePressureWarning = normalized;
    emit vehicleChanged();
}

void VehicleController::toggleCentralLock() { setCentralLock(!m_centralLock); }
void VehicleController::toggleFuelTankLock() { setFuelTankLock(!m_fuelTankLock); }
void VehicleController::toggleTrunk() { setTrunkOpen(!m_trunkOpen); }
void VehicleController::toggleHybridMode() { setHybridMode(!m_hybridMode); }
void VehicleController::toggleLightControl() { setLightControl(!m_lightControl); }
void VehicleController::toggleSpecialRoad() { setSpecialRoad(!m_specialRoad); }
void VehicleController::toggleCharging() { setCharging(!m_charging); }

void VehicleController::updateRange()
{
    const qreal efficiency = m_hybridMode ? 1.08 : 1.0;
    m_rangeKm = qRound(500.0 * m_batteryLevel * efficiency);
}
