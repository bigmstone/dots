NextSong = NextSong or {}

function NextSong.Press()
    io.popen("osascript -e 'tell application \"Music\" to play next track'")
end

function NextSong.Release()
end
