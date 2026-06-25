#ifndef APPBACKEND_H
#define APPBACKEND_H

#include <QNetworkAccessManager>
#include <QObject>
#include <QSettings>
#include <QTimer>
#include <QVariantList>
#include <QVariantMap>

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
    Q_PROPERTY(QString homeWidget READ homeWidget WRITE setHomeWidget NOTIFY settingsChanged)
    Q_PROPERTY(QVariantList homeWidgets READ homeWidgets NOTIFY settingsChanged)
    Q_PROPERTY(QVariantList homeWidgetSizes READ homeWidgetSizes NOTIFY settingsChanged)
    Q_PROPERTY(QString homeTexture READ homeTexture WRITE setHomeTexture NOTIFY settingsChanged)
    Q_PROPERTY(QString driverProfile READ driverProfile WRITE setDriverProfile NOTIFY settingsChanged)
    Q_PROPERTY(QString themePreset READ themePreset WRITE setThemePreset NOTIFY settingsChanged)
    Q_PROPERTY(bool parkedAllowed READ parkedAllowed WRITE setParkedAllowed NOTIFY vehicleChanged)
    Q_PROPERTY(bool vehicleMoving READ vehicleMoving WRITE setVehicleMoving NOTIFY vehicleChanged)
    Q_PROPERTY(bool windowsClosed READ windowsClosed WRITE setWindowsClosed NOTIFY vehicleChanged)
    Q_PROPERTY(int tirePressureWarning READ tirePressureWarning WRITE setTirePressureWarning NOTIFY vehicleChanged)
    Q_PROPERTY(QVariantList mediaLibrary READ mediaLibrary NOTIFY mediaChanged)
    Q_PROPERTY(QVariantList notifications READ notifications NOTIFY notificationsChanged)
    Q_PROPERTY(QVariantMap routeInfo READ routeInfo NOTIFY routeChanged)
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
    QString homeWidget() const;
    QVariantList homeWidgets() const;
    QVariantList homeWidgetSizes() const;
    QString homeTexture() const;
    QString driverProfile() const;
    QString themePreset() const;
    bool parkedAllowed() const;
    bool vehicleMoving() const;
    bool windowsClosed() const;
    int tirePressureWarning() const;
    QVariantList mediaLibrary() const;
    QVariantList notifications() const;
    QVariantMap routeInfo() const;
    QVariantList forecast() const;

    void setTextureEnabled(bool enabled);
    void setDarkTheme(bool enabled);
    void setWifiOn(bool enabled);
    void setAutoLock(bool enabled);
    void setDriverAssist(bool enabled);
    void setEcoMode(bool enabled);
    void setHomeWidget(const QString &widget);
    void setHomeTexture(const QString &texture);
    void setDriverProfile(const QString &profile);
    void setThemePreset(const QString &preset);
    void setParkedAllowed(bool allowed);
    void setVehicleMoving(bool moving);
    void setWindowsClosed(bool closed);
    void setTirePressureWarning(int tireIndex);

    Q_INVOKABLE void refreshWeather();
    Q_INVOKABLE void setHomeWidgetAt(int index, const QString &widget);
    Q_INVOKABLE void setHomeWidgetSizeAt(int index, const QString &size);
    Q_INVOKABLE void reorderHomeWidget(int from, int to);
    Q_INVOKABLE void executeVoiceCommand(const QString &command);
    Q_INVOKABLE void refreshRoute();
    Q_INVOKABLE void refreshMediaLibrary();
    Q_INVOKABLE void refreshNotifications();

signals:
    void timeChanged();
    void weatherChanged();
    void settingsChanged();
    void vehicleChanged();
    void routeChanged();
    void mediaChanged();
    void notificationsChanged();

private:
    void updateClock();
    void handleWeatherReply(QNetworkReply *reply);
    void applyFallbackWeather();
    QString conditionFromCode(int code) const;
    QString iconFromCode(int code) const;
    QString textureFromCode(int code) const;
    void loadSettings();
    void saveSetting(const QString &key, bool value);
    void saveSetting(const QString &key, const QString &value);
    void saveStringList(const QString &key, const QStringList &value);
    bool isAllowedWidget(const QString &widget) const;
    bool isAllowedHomeTexture(const QString &texture) const;
    void normalizeHomeWidgets();
    QVariantList stringListToVariantList(const QStringList &items) const;

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
    QString m_homeWidget = QStringLiteral("weather");
    QStringList m_homeWidgets = {QStringLiteral("weather"), QStringLiteral("music"), QStringLiteral("navigation")};
    QStringList m_homeWidgetSizes = {QStringLiteral("large"), QStringLiteral("small"), QStringLiteral("small")};
    QString m_homeTexture = QStringLiteral("weather");
    QString m_driverProfile = QStringLiteral("Adesh");
    QString m_themePreset = QStringLiteral("Ambient Indigo");
    bool m_parkedAllowed = true;
    bool m_vehicleMoving = false;
    bool m_windowsClosed = true;
    int m_tirePressureWarning = -1;
    QVariantList m_mediaLibrary;
    QVariantList m_notifications;
    QVariantMap m_routeInfo;
    QVariantList m_forecast;
};

#endif // APPBACKEND_H
