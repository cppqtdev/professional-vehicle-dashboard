#include "appbackend.h"

#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QUrlQuery>

#include <utility>

AppBackend::AppBackend(QObject *parent)
    : QObject(parent)
    , m_settings(QStringLiteral("SmartUIDesign"), QStringLiteral("Infotainment"))
{
    loadSettings();
    applyFallbackWeather();

    connect(&m_clockTimer, &QTimer::timeout, this, &AppBackend::updateClock);
    m_clockTimer.start(1000);
    updateClock();

    connect(&m_weatherTimer, &QTimer::timeout, this, &AppBackend::refreshWeather);
    m_weatherTimer.start(20 * 60 * 1000);

    refreshRoute();
    refreshMediaLibrary();
    refreshNotifications();
    refreshWeather();
}

QString AppBackend::time() const { return m_time; }
QString AppBackend::date() const { return m_date; }
QString AppBackend::city() const { return m_city; }
int AppBackend::weatherTemp() const { return m_weatherTemp; }
QString AppBackend::weatherCondition() const { return m_weatherCondition; }
int AppBackend::rainChance() const { return m_rainChance; }
int AppBackend::humidity() const { return m_humidity; }
QString AppBackend::weatherIcon() const { return m_weatherIcon; }
QString AppBackend::weatherTexture() const { return m_weatherTexture; }
bool AppBackend::textureEnabled() const { return m_textureEnabled; }
bool AppBackend::darkTheme() const { return m_darkTheme; }
bool AppBackend::wifiOn() const { return m_wifiOn; }
bool AppBackend::autoLock() const { return m_autoLock; }
bool AppBackend::driverAssist() const { return m_driverAssist; }
bool AppBackend::ecoMode() const { return m_ecoMode; }
QString AppBackend::homeWidget() const { return m_homeWidget; }
QVariantList AppBackend::homeWidgets() const { return stringListToVariantList(m_homeWidgets); }
QVariantList AppBackend::homeWidgetSizes() const { return stringListToVariantList(m_homeWidgetSizes); }
QString AppBackend::homeTexture() const { return m_homeTexture; }
QString AppBackend::driverProfile() const { return m_driverProfile; }
QString AppBackend::themePreset() const { return m_themePreset; }
bool AppBackend::parkedAllowed() const { return m_parkedAllowed; }
bool AppBackend::vehicleMoving() const { return m_vehicleMoving; }
bool AppBackend::windowsClosed() const { return m_windowsClosed; }
int AppBackend::tirePressureWarning() const { return m_tirePressureWarning; }
QVariantList AppBackend::mediaLibrary() const { return m_mediaLibrary; }
QVariantList AppBackend::notifications() const { return m_notifications; }
QVariantMap AppBackend::routeInfo() const { return m_routeInfo; }
QVariantList AppBackend::forecast() const { return m_forecast; }

void AppBackend::setTextureEnabled(bool enabled)
{
    if (m_textureEnabled == enabled)
        return;
    m_textureEnabled = enabled;
    saveSetting(QStringLiteral("textureEnabled"), enabled);
    emit settingsChanged();
}

void AppBackend::setDarkTheme(bool enabled)
{
    if (m_darkTheme == enabled)
        return;
    m_darkTheme = enabled;
    saveSetting(QStringLiteral("darkTheme"), enabled);
    emit settingsChanged();
}

void AppBackend::setWifiOn(bool enabled)
{
    if (m_wifiOn == enabled)
        return;
    m_wifiOn = enabled;
    saveSetting(QStringLiteral("wifiOn"), enabled);
    emit settingsChanged();
}

void AppBackend::setAutoLock(bool enabled)
{
    if (m_autoLock == enabled)
        return;
    m_autoLock = enabled;
    saveSetting(QStringLiteral("autoLock"), enabled);
    emit settingsChanged();
}

void AppBackend::setDriverAssist(bool enabled)
{
    if (m_driverAssist == enabled)
        return;
    m_driverAssist = enabled;
    saveSetting(QStringLiteral("driverAssist"), enabled);
    emit settingsChanged();
}

void AppBackend::setEcoMode(bool enabled)
{
    if (m_ecoMode == enabled)
        return;
    m_ecoMode = enabled;
    saveSetting(QStringLiteral("ecoMode"), enabled);
    emit settingsChanged();
}

void AppBackend::setHomeWidget(const QString &widget)
{
    if (!isAllowedWidget(widget) || m_homeWidget == widget)
        return;
    m_homeWidget = widget;
    if (!m_homeWidgets.isEmpty()) {
        m_homeWidgets[0] = widget;
        saveStringList(QStringLiteral("homeWidgets"), m_homeWidgets);
    }
    saveSetting(QStringLiteral("homeWidget"), widget);
    emit settingsChanged();
}

void AppBackend::setHomeTexture(const QString &texture)
{
    if (!isAllowedHomeTexture(texture) || m_homeTexture == texture)
        return;
    m_homeTexture = texture;
    saveSetting(QStringLiteral("homeTexture"), texture);
    emit settingsChanged();
}

void AppBackend::setDriverProfile(const QString &profile)
{
    if (profile.isEmpty() || m_driverProfile == profile)
        return;
    m_driverProfile = profile;
    saveSetting(QStringLiteral("driverProfile"), profile);
    emit settingsChanged();
}

void AppBackend::setThemePreset(const QString &preset)
{
    if (preset.isEmpty() || m_themePreset == preset)
        return;
    m_themePreset = preset;
    saveSetting(QStringLiteral("themePreset"), preset);
    emit settingsChanged();
}

void AppBackend::setParkedAllowed(bool allowed)
{
    if (m_parkedAllowed == allowed)
        return;
    m_parkedAllowed = allowed;
    emit vehicleChanged();
}

void AppBackend::setVehicleMoving(bool moving)
{
    if (m_vehicleMoving == moving)
        return;
    m_vehicleMoving = moving;
    m_parkedAllowed = !moving;
    emit vehicleChanged();
}

void AppBackend::setWindowsClosed(bool closed)
{
    if (m_windowsClosed == closed)
        return;
    m_windowsClosed = closed;
    emit vehicleChanged();
}

void AppBackend::setTirePressureWarning(int tireIndex)
{
    if (m_tirePressureWarning == tireIndex)
        return;
    m_tirePressureWarning = tireIndex;
    emit vehicleChanged();
}

void AppBackend::setHomeWidgetAt(int index, const QString &widget)
{
    if (index < 0 || index >= m_homeWidgets.size() || !isAllowedWidget(widget)
        || m_homeWidgets.at(index) == widget)
        return;
    m_homeWidgets[index] = widget;
    m_homeWidget = m_homeWidgets.first();
    saveStringList(QStringLiteral("homeWidgets"), m_homeWidgets);
    saveSetting(QStringLiteral("homeWidget"), m_homeWidget);
    emit settingsChanged();
}

void AppBackend::setHomeWidgetSizeAt(int index, const QString &size)
{
    if (index < 0 || index >= m_homeWidgetSizes.size())
        return;
    const QString normalized = size == QStringLiteral("large") ? QStringLiteral("large") : QStringLiteral("small");
    if (m_homeWidgetSizes.at(index) == normalized)
        return;
    m_homeWidgetSizes[index] = normalized;
    saveStringList(QStringLiteral("homeWidgetSizes"), m_homeWidgetSizes);
    emit settingsChanged();
}

void AppBackend::reorderHomeWidget(int from, int to)
{
    if (from < 0 || from >= m_homeWidgets.size() || to < 0 || to >= m_homeWidgets.size() || from == to)
        return;
    m_homeWidgets.move(from, to);
    m_homeWidgetSizes.move(from, to);
    m_homeWidget = m_homeWidgets.first();
    saveStringList(QStringLiteral("homeWidgets"), m_homeWidgets);
    saveStringList(QStringLiteral("homeWidgetSizes"), m_homeWidgetSizes);
    saveSetting(QStringLiteral("homeWidget"), m_homeWidget);
    emit settingsChanged();
}

void AppBackend::executeVoiceCommand(const QString &command)
{
    const QString lower = command.toLower();
    if (lower.contains(QStringLiteral("lock"))) {
        setAutoLock(true);
        setWindowsClosed(true);
    } else if (lower.contains(QStringLiteral("temperature")) || lower.contains(QStringLiteral("climate"))) {
        setEcoMode(false);
    } else if (lower.contains(QStringLiteral("charger")) || lower.contains(QStringLiteral("route"))
               || lower.contains(QStringLiteral("navigate"))) {
        refreshRoute();
    } else if (lower.contains(QStringLiteral("music")) || lower.contains(QStringLiteral("playlist"))) {
        refreshMediaLibrary();
    }
}

void AppBackend::refreshRoute()
{
    m_routeInfo = QVariantMap{
        {QStringLiteral("destination"), QStringLiteral("Home")},
        {QStringLiteral("eta"), QStringLiteral("00:35")},
        {QStringLiteral("duration"), QStringLiteral("18 min")},
        {QStringLiteral("distance"), QStringLiteral("7.8 km")},
        {QStringLiteral("traffic"), QStringLiteral("Light traffic")},
        {QStringLiteral("nextTurn"), QStringLiteral("Shennan Ave in 600 m")},
        {QStringLiteral("chargers"), 4},
        {QStringLiteral("parking"), QStringLiteral("2.1 km")}
    };
    emit routeChanged();
}

void AppBackend::refreshMediaLibrary()
{
    m_mediaLibrary = {
        QVariantMap{{QStringLiteral("title"), QStringLiteral("House of Card")},
                    {QStringLiteral("artist"), QStringLiteral("Radiohead")},
                    {QStringLiteral("source"), QStringLiteral("Daily Recommended")}},
        QVariantMap{{QStringLiteral("title"), QStringLiteral("Everything In Its Right Place")},
                    {QStringLiteral("artist"), QStringLiteral("Radiohead")},
                    {QStringLiteral("source"), QStringLiteral("Favorite")}},
        QVariantMap{{QStringLiteral("title"), QStringLiteral("Midnight City")},
                    {QStringLiteral("artist"), QStringLiteral("M83")},
                    {QStringLiteral("source"), QStringLiteral("Drive Mix")}}
    };
    emit mediaChanged();
}

void AppBackend::refreshNotifications()
{
    m_notifications = {
        QVariantMap{{QStringLiteral("icon"), QStringLiteral("warning")},
                    {QStringLiteral("title"), QStringLiteral("Weather alert")},
                    {QStringLiteral("body"), QStringLiteral("Thunderstorm nearby. Route guidance will avoid flooded roads.")},
                    {QStringLiteral("time"), QStringLiteral("Now")},
                    {QStringLiteral("accent"), QStringLiteral("danger")}},
        QVariantMap{{QStringLiteral("icon"), QStringLiteral("battery")},
                    {QStringLiteral("title"), QStringLiteral("Charging suggestion")},
                    {QStringLiteral("body"), QStringLiteral("Battery projected at 22% on arrival. Add a charger stop?")},
                    {QStringLiteral("time"), QStringLiteral("2m")},
                    {QStringLiteral("accent"), QStringLiteral("accent")}},
        QVariantMap{{QStringLiteral("icon"), QStringLiteral("person")},
                    {QStringLiteral("title"), QStringLiteral("Incoming call")},
                    {QStringLiteral("body"), QStringLiteral("Aarav Kapoor. Use steering controls or voice assistant to answer.")},
                    {QStringLiteral("time"), QStringLiteral("4h")},
                    {QStringLiteral("accent"), QStringLiteral("success")}}
    };
    emit notificationsChanged();
}

void AppBackend::updateClock()
{
    const QDateTime now = QDateTime::currentDateTime();
    const QString nextTime = now.toString(QStringLiteral("HH:mm"));
    const QString nextDate = now.toString(QStringLiteral("dddd | MMM d"));

    if (nextTime == m_time && nextDate == m_date)
        return;

    m_time = nextTime;
    m_date = nextDate;
    emit timeChanged();
}

void AppBackend::refreshWeather()
{
    QUrl url(QStringLiteral("https://api.open-meteo.com/v1/forecast"));
    QUrlQuery query;
    query.addQueryItem(QStringLiteral("latitude"), QStringLiteral("22.5333"));
    query.addQueryItem(QStringLiteral("longitude"), QStringLiteral("113.9304"));
    query.addQueryItem(QStringLiteral("current"),
                       QStringLiteral("temperature_2m,relative_humidity_2m,precipitation,weather_code"));
    query.addQueryItem(QStringLiteral("daily"),
                       QStringLiteral("weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max"));
    query.addQueryItem(QStringLiteral("forecast_days"), QStringLiteral("5"));
    query.addQueryItem(QStringLiteral("timezone"), QStringLiteral("auto"));
    url.setQuery(query);

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::UserAgentHeader,
                      QStringLiteral("smartuidesign/1.0 Qt Open-Meteo client"));

    QNetworkReply *reply = m_network.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        handleWeatherReply(reply);
    });
}

void AppBackend::handleWeatherReply(QNetworkReply *reply)
{
    reply->deleteLater();
    if (reply->error() != QNetworkReply::NoError)
        return;

    const QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    if (!doc.isObject())
        return;

    const QJsonObject root = doc.object();
    const QJsonObject current = root.value(QStringLiteral("current")).toObject();
    if (!current.isEmpty()) {
        const int code = current.value(QStringLiteral("weather_code")).toInt();
        m_weatherTemp = qRound(current.value(QStringLiteral("temperature_2m")).toDouble(m_weatherTemp));
        m_humidity = current.value(QStringLiteral("relative_humidity_2m")).toInt(m_humidity);
        m_weatherCondition = conditionFromCode(code);
        m_weatherIcon = iconFromCode(code);
        m_weatherTexture = textureFromCode(code);
    }

    const QJsonObject daily = root.value(QStringLiteral("daily")).toObject();
    const QJsonArray times = daily.value(QStringLiteral("time")).toArray();
    const QJsonArray codes = daily.value(QStringLiteral("weather_code")).toArray();
    const QJsonArray highs = daily.value(QStringLiteral("temperature_2m_max")).toArray();
    const QJsonArray lows = daily.value(QStringLiteral("temperature_2m_min")).toArray();
    const QJsonArray rain = daily.value(QStringLiteral("precipitation_probability_max")).toArray();

    QVariantList nextForecast;
    const int days = std::min({int(times.size()), int(codes.size()), int(highs.size()),
                               int(lows.size()), int(rain.size()), 5});
    for (int i = 0; i < days; ++i) {
        const QDate date = QDate::fromString(times.at(i).toString(), Qt::ISODate);
        const int code = codes.at(i).toInt();
        QVariantMap day;
        day.insert(QStringLiteral("day"),
                   date.isValid() ? date.toString(QStringLiteral("d ddd")).toUpper()
                                  : times.at(i).toString());
        day.insert(QStringLiteral("icon"), iconFromCode(code));
        day.insert(QStringLiteral("hi"), qRound(highs.at(i).toDouble()));
        day.insert(QStringLiteral("lo"), qRound(lows.at(i).toDouble()));
        day.insert(QStringLiteral("cond"), conditionFromCode(code));
        day.insert(QStringLiteral("rain"), rain.at(i).toInt());
        nextForecast.append(day);
    }

    if (!nextForecast.isEmpty()) {
        m_forecast = nextForecast;
        bool ok = false;
        const int todayRain = nextForecast.first().toMap().value(QStringLiteral("rain")).toInt(&ok);
        if (ok)
            m_rainChance = todayRain;
    }

    emit weatherChanged();
}

void AppBackend::applyFallbackWeather()
{
    m_forecast = {
        QVariantMap{{QStringLiteral("day"), QStringLiteral("27 SUN")}, {QStringLiteral("icon"), QStringLiteral("wRain")},
                    {QStringLiteral("hi"), 23}, {QStringLiteral("lo"), 18}, {QStringLiteral("cond"), QStringLiteral("Showers")},
                    {QStringLiteral("rain"), 90}},
        QVariantMap{{QStringLiteral("day"), QStringLiteral("28 MON")}, {QStringLiteral("icon"), QStringLiteral("wPartly")},
                    {QStringLiteral("hi"), 26}, {QStringLiteral("lo"), 20}, {QStringLiteral("cond"), QStringLiteral("Partly Cloudy")},
                    {QStringLiteral("rain"), 40}},
        QVariantMap{{QStringLiteral("day"), QStringLiteral("29 TUE")}, {QStringLiteral("icon"), QStringLiteral("wSun")},
                    {QStringLiteral("hi"), 35}, {QStringLiteral("lo"), 27}, {QStringLiteral("cond"), QStringLiteral("Mostly Clear")},
                    {QStringLiteral("rain"), 18}},
        QVariantMap{{QStringLiteral("day"), QStringLiteral("30 WED")}, {QStringLiteral("icon"), QStringLiteral("wRain")},
                    {QStringLiteral("hi"), 20}, {QStringLiteral("lo"), 16}, {QStringLiteral("cond"), QStringLiteral("Rain")},
                    {QStringLiteral("rain"), 86}},
        QVariantMap{{QStringLiteral("day"), QStringLiteral("1 FRI")}, {QStringLiteral("icon"), QStringLiteral("wStorm")},
                    {QStringLiteral("hi"), 25}, {QStringLiteral("lo"), 18}, {QStringLiteral("cond"), QStringLiteral("Thunderstorm")},
                    {QStringLiteral("rain"), 72}}
    };
}

QString AppBackend::conditionFromCode(int code) const
{
    if (code == 0) return QStringLiteral("Clear");
    if (code <= 3) return QStringLiteral("Partly Cloudy");
    if (code == 45 || code == 48) return QStringLiteral("Fog");
    if (code >= 51 && code <= 57) return QStringLiteral("Drizzle");
    if (code >= 61 && code <= 67) return QStringLiteral("Rain");
    if (code >= 71 && code <= 77) return QStringLiteral("Snow");
    if (code >= 80 && code <= 82) return QStringLiteral("Showers");
    if (code >= 95) return QStringLiteral("Thunderstorm");
    return QStringLiteral("Mostly Clear");
}

QString AppBackend::iconFromCode(int code) const
{
    if (code == 0) return QStringLiteral("wSun");
    if (code <= 3 || code == 45 || code == 48) return QStringLiteral("wPartly");
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return QStringLiteral("wRain");
    if (code >= 95) return QStringLiteral("wStorm");
    return QStringLiteral("wCloud");
}

QString AppBackend::textureFromCode(int code) const
{
    if (code >= 95) return QStringLiteral("storm");
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) return QStringLiteral("rain");
    if (code == 45 || code == 48 || code >= 71) return QStringLiteral("mist");
    if (code >= 1 && code <= 3) return QStringLiteral("cloud");
    return QStringLiteral("clear");
}

void AppBackend::loadSettings()
{
    m_darkTheme = m_settings.value(QStringLiteral("darkTheme"), true).toBool();
    m_textureEnabled = m_settings.value(QStringLiteral("textureEnabled"), true).toBool();
    m_wifiOn = m_settings.value(QStringLiteral("wifiOn"), true).toBool();
    m_autoLock = m_settings.value(QStringLiteral("autoLock"), true).toBool();
    m_driverAssist = m_settings.value(QStringLiteral("driverAssist"), true).toBool();
    m_ecoMode = m_settings.value(QStringLiteral("ecoMode"), false).toBool();
    m_homeWidget = m_settings.value(QStringLiteral("homeWidget"), QStringLiteral("weather")).toString();
    m_homeWidgets = m_settings.value(QStringLiteral("homeWidgets"), m_homeWidgets).toStringList();
    m_homeWidgetSizes = m_settings.value(QStringLiteral("homeWidgetSizes"), m_homeWidgetSizes).toStringList();
    m_homeTexture = m_settings.value(QStringLiteral("homeTexture"), QStringLiteral("weather")).toString();
    if (!isAllowedHomeTexture(m_homeTexture))
        m_homeTexture = QStringLiteral("weather");
    m_driverProfile = m_settings.value(QStringLiteral("driverProfile"), QStringLiteral("Adesh")).toString();
    m_themePreset = m_settings.value(QStringLiteral("themePreset"), QStringLiteral("Ambient Indigo")).toString();
    normalizeHomeWidgets();
    m_homeWidget = m_homeWidgets.first();
}

void AppBackend::saveSetting(const QString &key, bool value)
{
    m_settings.setValue(key, value);
    m_settings.sync();
}

void AppBackend::saveSetting(const QString &key, const QString &value)
{
    m_settings.setValue(key, value);
    m_settings.sync();
}

void AppBackend::saveStringList(const QString &key, const QStringList &value)
{
    m_settings.setValue(key, value);
    m_settings.sync();
}

bool AppBackend::isAllowedWidget(const QString &widget) const
{
    static const QStringList allowed = {
        QStringLiteral("weather"),
        QStringLiteral("music"),
        QStringLiteral("energy"),
        QStringLiteral("quick"),
        QStringLiteral("navigation"),
        QStringLiteral("climate"),
        QStringLiteral("tires"),
        QStringLiteral("trip"),
        QStringLiteral("calendar"),
        QStringLiteral("calls")
    };
    return allowed.contains(widget);
}

bool AppBackend::isAllowedHomeTexture(const QString &texture) const
{
    static const QStringList allowed = {
        QStringLiteral("weather"),
        QStringLiteral("clear"),
        QStringLiteral("cloud"),
        QStringLiteral("mist"),
        QStringLiteral("rain"),
        QStringLiteral("storm"),
        QStringLiteral("none")
    };
    return allowed.contains(texture);
}

void AppBackend::normalizeHomeWidgets()
{
    QStringList normalizedWidgets;
    for (const QString &widget : std::as_const(m_homeWidgets)) {
        if (isAllowedWidget(widget) && !normalizedWidgets.contains(widget))
            normalizedWidgets.append(widget);
    }
    if (normalizedWidgets.isEmpty())
        normalizedWidgets = {QStringLiteral("weather"), QStringLiteral("music"), QStringLiteral("navigation")};
    while (normalizedWidgets.size() < 3)
        normalizedWidgets.append(normalizedWidgets.size() == 1 ? QStringLiteral("music") : QStringLiteral("navigation"));
    while (normalizedWidgets.size() > 3)
        normalizedWidgets.removeLast();
    m_homeWidgets = normalizedWidgets;

    QStringList normalizedSizes;
    for (const QString &size : std::as_const(m_homeWidgetSizes))
        normalizedSizes.append(size == QStringLiteral("large") ? QStringLiteral("large") : QStringLiteral("small"));
    while (normalizedSizes.size() < m_homeWidgets.size())
        normalizedSizes.append(normalizedSizes.isEmpty() ? QStringLiteral("large") : QStringLiteral("small"));
    while (normalizedSizes.size() > m_homeWidgets.size())
        normalizedSizes.removeLast();
    m_homeWidgetSizes = normalizedSizes;
}

QVariantList AppBackend::stringListToVariantList(const QStringList &items) const
{
    QVariantList list;
    for (const QString &item : items)
        list.append(item);
    return list;
}
