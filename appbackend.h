#ifndef APPBACKEND_H
#define APPBACKEND_H

#include <QNetworkAccessManager>
#include <QObject>
#include <QSettings>
#include <QTimer>
#include <QVariantList>

class AppBackend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString time READ time NOTIFY timeChanged)
    Q_PROPERTY(QString date READ date NOTIFY timeChanged)
    Q_PROPERTY(QString city READ city CONSTANT)
    Q_PROPERTY(int weatherTemp READ weatherTemp NOTIFY weatherChanged)
    Q_PROPERTY(QString weatherCondition READ weatherCondition NOTIFY weatherChanged)
    Q_PROPERTY(int rainChance READ rainChance NOTIFY weatherChanged)
    Q_PROPERTY(int humidity READ humidity NOTIFY weatherChanged)
    Q_PROPERTY(QString weatherIcon READ weatherIcon NOTIFY weatherChanged)
    Q_PROPERTY(QString weatherTexture READ weatherTexture NOTIFY weatherChanged)
    Q_PROPERTY(bool textureEnabled READ textureEnabled WRITE setTextureEnabled NOTIFY settingsChanged)
    Q_PROPERTY(bool darkTheme READ darkTheme WRITE setDarkTheme NOTIFY settingsChanged)
    Q_PROPERTY(bool wifiOn READ wifiOn WRITE setWifiOn NOTIFY settingsChanged)
    Q_PROPERTY(bool autoLock READ autoLock WRITE setAutoLock NOTIFY settingsChanged)
    Q_PROPERTY(bool driverAssist READ driverAssist WRITE setDriverAssist NOTIFY settingsChanged)
    Q_PROPERTY(bool ecoMode READ ecoMode WRITE setEcoMode NOTIFY settingsChanged)
    Q_PROPERTY(QVariantList forecast READ forecast NOTIFY weatherChanged)

public:
    explicit AppBackend(QObject *parent = nullptr);

    QString time() const;
    QString date() const;
    QString city() const;
    int weatherTemp() const;
    QString weatherCondition() const;
    int rainChance() const;
    int humidity() const;
    QString weatherIcon() const;
    QString weatherTexture() const;
    bool textureEnabled() const;
    bool darkTheme() const;
    bool wifiOn() const;
    bool autoLock() const;
    bool driverAssist() const;
    bool ecoMode() const;
    QVariantList forecast() const;

    void setTextureEnabled(bool enabled);
    void setDarkTheme(bool enabled);
    void setWifiOn(bool enabled);
    void setAutoLock(bool enabled);
    void setDriverAssist(bool enabled);
    void setEcoMode(bool enabled);

    Q_INVOKABLE void refreshWeather();

signals:
    void timeChanged();
    void weatherChanged();
    void settingsChanged();

private:
    void updateClock();
    void handleWeatherReply(QNetworkReply *reply);
    void applyFallbackWeather();
    QString conditionFromCode(int code) const;
    QString iconFromCode(int code) const;
    QString textureFromCode(int code) const;
    void loadSettings();
    void saveSetting(const QString &key, bool value);

    QNetworkAccessManager m_network;
    QSettings m_settings;
    QTimer m_clockTimer;
    QTimer m_weatherTimer;

    QString m_time;
    QString m_date;
    QString m_city = QStringLiteral("Nanshan | Shenzhen");
    int m_weatherTemp = 35;
    QString m_weatherCondition = QStringLiteral("Mostly Clear");
    int m_rainChance = 90;
    int m_humidity = 75;
    QString m_weatherIcon = QStringLiteral("wStorm");
    QString m_weatherTexture = QStringLiteral("storm");
    bool m_textureEnabled = true;
    bool m_darkTheme = true;
    bool m_wifiOn = true;
    bool m_autoLock = true;
    bool m_driverAssist = true;
    bool m_ecoMode = false;
    QVariantList m_forecast;
};

#endif // APPBACKEND_H
