PlayMusic = PlayMusic or {}

function PlayMusic.Press()
    io.popen("osascript -e 'tell application \"Music\" to play'")
end

function PlayMusic.Release()
end
