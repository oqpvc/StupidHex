struct Player
    play::Function
end

function best_move(board::Board, Q)
    if payoff(board) != 0
        error("Game is already finished, no further moves to play")
    end

    all_positions = [(i,j) for i in 1:board.size for j in 1:board.size] 

    legal_positions = filter(!in(board.moves), all_positions)
    best = partialsort(legal_positions, 1, lt = ((a , b) -> Q(board, a)  > Q(board, b)))

    return best
end


function next_board(board::Board, Q)
    if payoff(board) != 0
        error("Game is already finished, no further moves to play")
    end

    move = best_move(board, Q)

    # check if switching is possible
    if length(board.moves) == 1 && board.switched == false
        # switch if we have expected negative utility
        if Q(board, move) < 0
            return Board(board.size, board.moves, true)
        end
    end

    return Board(board.size, vcat(board.moves, [move]), board.switched)
end

function zero(b, p)
    return 0
end

function random(b, p)
    return randn()/4
end

function current_player_number(board::Board)
    switch_offset = board.switched ? 1 : 0
    if iseven(length(board.moves)+switch_offset)
        return 1
    else
        return 2
    end
end

function human_play(board::Board)
    print(board)

    print("You are Player ")
    print(current_player_number(board))
    print(".\n")
    if length(board.moves)==1 && board.switched==false
        print("Do you want to switch? [y/n] ")
        will = readline()
        if will=="y"
            return Board(board.size, board.moves, true)
        end
    end

    print("Which row to play? [1.." * string(board.size) * "] ")
    row = parse(Int, readline())
    print("Which column to play? [a.." * Char(96+board.size) * "] ")
    column = Int(readline()[1])-96

    return Board(board.size, vcat(board.moves, [(row, column)]), board.switched)
end
