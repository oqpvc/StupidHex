function nextboard(board::Board, expt)
    all_positions = [(i,j) for i in 1:board.size for j in 1:board.size] 
    moves = if ismissing(board.moves)
        []
    else
        board.moves
    end

    legal_positions = filter(!in(moves), all_positions)
    candidates = sort(legal_positions, lt = ((a , b) -> expt(board, a)  > expt(board, b)))

    return Board(board.size, vcat(moves, [candidates[1]]), board.switched)
end

function zero(b, p)
    return 0
end

function random(b, p)
    return randn()/4
end
