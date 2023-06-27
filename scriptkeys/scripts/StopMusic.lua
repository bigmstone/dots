StopMusic = StopMusic or {}

function StopMusic.Press()
    io.popen("osascript -e 'tell application \"Music\" to pause'")
end

function StopMusic.Release()
end
