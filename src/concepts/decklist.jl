export DeckList, initialize_list

struct DeckList end

function initialize_list(list::DeckList) 
    return Vector{Entity}()
end