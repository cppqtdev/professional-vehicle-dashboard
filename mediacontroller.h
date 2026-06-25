#ifndef MEDIACONTROLLER_H
#define MEDIACONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QVector>

class MediaController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY mediaChanged)
    Q_PROPERTY(qreal trackProgress READ trackProgress WRITE setTrackProgress NOTIFY mediaChanged)
    Q_PROPERTY(QString trackTitle READ trackTitle NOTIFY mediaChanged)
    Q_PROPERTY(QString trackArtist READ trackArtist NOTIFY mediaChanged)
    Q_PROPERTY(QString trackElapsed READ trackElapsed NOTIFY mediaChanged)
    Q_PROPERTY(QString trackDuration READ trackDuration NOTIFY mediaChanged)
    Q_PROPERTY(int musicTab READ musicTab WRITE setMusicTab NOTIFY mediaChanged)
    Q_PROPERTY(bool musicDetailOpen READ musicDetailOpen WRITE setMusicDetailOpen NOTIFY mediaChanged)
    Q_PROPERTY(bool liked READ liked WRITE setLiked NOTIFY mediaChanged)
    Q_PROPERTY(bool repeatOn READ repeatOn WRITE setRepeatOn NOTIFY mediaChanged)

public:
    explicit MediaController(QObject *parent = nullptr);

    bool playing() const;
    qreal trackProgress() const;
    QString trackTitle() const;
    QString trackArtist() const;
    QString trackElapsed() const;
    QString trackDuration() const;
    int musicTab() const;
    bool musicDetailOpen() const;
    bool liked() const;
    bool repeatOn() const;

    void setPlaying(bool playing);
    void setTrackProgress(qreal progress);
    void setMusicTab(int tab);
    void setMusicDetailOpen(bool open);
    void setLiked(bool liked);
    void setRepeatOn(bool repeat);

    Q_INVOKABLE void playPause();
    Q_INVOKABLE void previousTrack();
    Q_INVOKABLE void nextTrack();
    Q_INVOKABLE void toggleLiked();
    Q_INVOKABLE void toggleRepeat();
    Q_INVOKABLE void openDetail();
    Q_INVOKABLE void closeDetail();
    Q_INVOKABLE void selectSource(const QString &source);

signals:
    void mediaChanged();

private:
    struct Track {
        QString title;
        QString artist;
        int durationSeconds;
    };

    void setTrackIndex(int index);
    void updateElapsedFromProgress();
    QString formatTime(int seconds) const;

    QVector<Track> m_tracks;
    QTimer m_progressTimer;
    int m_trackIndex = 0;
    bool m_playing = false;
    qreal m_trackProgress = 0.45;
    QString m_trackElapsed = QStringLiteral("02:09");
    int m_musicTab = 0;
    bool m_musicDetailOpen = false;
    bool m_liked = false;
    bool m_repeatOn = false;
};

#endif // MEDIACONTROLLER_H
