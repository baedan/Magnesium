export GameInfo

@component struct GameInfo
    finished::Bool
end

GameInfo() = GameInfo(false)