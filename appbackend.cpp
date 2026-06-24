#include "appbackend.h"

#include <QDateTime>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QUrlQuery>

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
}

void AppBackend::saveSetting(const QString &key, bool value)
{
    m_settings.setValue(key, value);
    m_settings.sync();
}
