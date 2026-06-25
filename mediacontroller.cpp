#include "mediacontroller.h"

#include <algorithm>

MediaController::MediaController(QObject *parent)
    : QObject(parent)
    , m_tracks({
          {QStringLiteral("House of Card"), QStringLiteral("Radiohead"), 346},
          {QStringLiteral("Everything In Its Right Place"), QStringLiteral("Radiohead"), 251},
          {QStringLiteral("Midnight City"), QStringLiteral("M83"), 244},
          {QStringLiteral("Roads"), QStringLiteral("Portishead"), 305},
      })
{
    connect(&m_progressTimer, &QTimer::timeout, this, [this]() {
        const int duration = m_tracks.at(m_trackIndex).durationSeconds;
        const qreal step = duration > 0 ? 1.0 / duration : 0.0;
        if (m_trackProgress + step >= 1.0) {
            if (m_repeatOn) {
                setTrackProgress(0.0);
            } else {
                nextTrack();
            }
            return;
        }
        setTrackProgress(m_trackProgress + step);
    });
    m_progressTimer.setInterval(1000);
    updateElapsedFromProgress();
}

bool MediaController::playing() const { return m_playing; }
qreal MediaController::trackProgress() const { return m_trackProgress; }
QString MediaController::trackTitle() const { return m_tracks.at(m_trackIndex).title; }
QString MediaController::trackArtist() const { return m_tracks.at(m_trackIndex).artist; }
QString MediaController::trackElapsed() const { return m_trackElapsed; }
QString MediaController::trackDuration() const { return formatTime(m_tracks.at(m_trackIndex).durationSeconds); }
int MediaController::musicTab() const { return m_musicTab; }
bool MediaController::musicDetailOpen() const { return m_musicDetailOpen; }
bool MediaController::liked() const { return m_liked; }
bool MediaController::repeatOn() const { return m_repeatOn; }

void MediaController::setPlaying(bool playing)
{
    if (m_playing == playing)
        return;
    m_playing = playing;
    if (m_playing)
        m_progressTimer.start();
    else
        m_progressTimer.stop();
    emit mediaChanged();
}

void MediaController::setTrackProgress(qreal progress)
{
    const qreal normalized = std::clamp(progress, 0.0, 1.0);
    if (qFuzzyCompare(m_trackProgress, normalized))
        return;
    m_trackProgress = normalized;
    updateElapsedFromProgress();
    emit mediaChanged();
}

void MediaController::setMusicTab(int tab)
{
    const int normalized = std::clamp(tab, 0, 3);
    if (m_musicTab == normalized)
        return;
    m_musicTab = normalized;
    emit mediaChanged();
}

void MediaController::setMusicDetailOpen(bool open)
{
    if (m_musicDetailOpen == open)
        return;
    m_musicDetailOpen = open;
    emit mediaChanged();
}

void MediaController::setLiked(bool liked)
{
    if (m_liked == liked)
        return;
    m_liked = liked;
    emit mediaChanged();
}

void MediaController::setRepeatOn(bool repeat)
{
    if (m_repeatOn == repeat)
        return;
    m_repeatOn = repeat;
    emit mediaChanged();
}

void MediaController::playPause()
{
    setPlaying(!m_playing);
}

void MediaController::previousTrack()
{
    if (m_trackProgress > 0.05) {
        setTrackProgress(0.0);
        return;
    }
    setTrackIndex((m_trackIndex - 1 + m_tracks.size()) % m_tracks.size());
}

void MediaController::nextTrack()
{
    setTrackIndex((m_trackIndex + 1) % m_tracks.size());
}

void MediaController::toggleLiked()
{
    setLiked(!m_liked);
}

void MediaController::toggleRepeat()
{
    setRepeatOn(!m_repeatOn);
}

void MediaController::openDetail()
{
    setMusicDetailOpen(true);
}

void MediaController::closeDetail()
{
    setMusicDetailOpen(false);
}

void MediaController::selectSource(const QString &source)
{
    if (source.contains(QStringLiteral("favorite"), Qt::CaseInsensitive)) {
        setTrackIndex(1);
    } else if (source.contains(QStringLiteral("radio"), Qt::CaseInsensitive)) {
        setTrackIndex(2);
    } else if (source.contains(QStringLiteral("popular"), Qt::CaseInsensitive)) {
        setTrackIndex(3);
    } else {
        setTrackIndex(0);
    }
    setMusicDetailOpen(true);
}

void MediaController::setTrackIndex(int index)
{
    if (index < 0 || index >= m_tracks.size() || m_trackIndex == index)
        return;
    m_trackIndex = index;
    m_trackProgress = 0.0;
    updateElapsedFromProgress();
    emit mediaChanged();
}

void MediaController::updateElapsedFromProgress()
{
    const int duration = m_tracks.at(m_trackIndex).durationSeconds;
    m_trackElapsed = formatTime(qRound(duration * m_trackProgress));
}

QString MediaController::formatTime(int seconds) const
{
    return QStringLiteral("%1:%2")
        .arg(seconds / 60, 2, 10, QLatin1Char('0'))
        .arg(seconds % 60, 2, 10, QLatin1Char('0'));
}
