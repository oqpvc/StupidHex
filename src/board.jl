"""
    Board

Basic structure of a Hex game.

# Fields
- `size::Int`: size of the field
- `moves::Array{Tuple{Int,Int},1}`: played moves, for example could be [(1,2),
  (2,3), (4,7)], which means that the first move was played at (1,2), the second
  at (2,3) and the third at (4,7)
- `switched::Bool`: Has the switching rule been used (in which case the odd
  moves count for Player 2)
"""
struct Board
    size::Int
    moves::Array{Tuple{Int,Int},1}
    switched::Bool
    function Board(size, moves=[], switched=false)
        return new(size, moves, switched)
    end
end


function theoretical_neighbours(p)
    i, j = p[1], p[2]
    return [(i,j), (i-1, j), (i-1,j+1), (i,j-1), (i,j+1), (i+1,j), (i+1, j-1)]
end

function reachable_in_one(occupied_fields, start)
    return filter(x -> in(x, theoretical_neighbours(start)), occupied_fields)
end

function reachable(occupied_fields, start)
    tmp = reachable_in_one(occupied_fields, start)
    next = vcat(map(s -> reachable_in_one(occupied_fields, s), tmp)...)
    while tmp != next
        tmp = next
        next = sort(unique(vcat(map(s -> reachable_in_one(occupied_fields, s), tmp)...)))
    end
    return next
end

function has_path(fields, starts, targets)
    if findfirst(in(fields), starts) === nothing
        return false
    end

    # superfluous nodes are nodes in starts which we have already reached
    superfluous = []
    for s in starts
        if !(s in superfluous) && in(s, fields)
            nodes = reachable(fields, s)
            if findfirst(in(targets), nodes) !== nothing
                return true
            end

            superfluous = vcat(superfluous, filter(in(starts), nodes))
            fields = filter(!in(nodes), fields)
        end
    end
    return false
end

"""
    payoff(board::Board)

Is 1 if Player 1 has a winning path, -1 if Player 2 has a winning path and 0 else.
"""
function payoff(board::Board)
    moves_odd = [board.moves[i] for i in 1:length(board.moves) if isodd(i)]
    moves_even = [board.moves[i] for i in 1:length(board.moves) if iseven(i)]

    if has_path(moves_odd, [(1,i) for i in 1:board.size], [(board.size, j) for j in 1:board.size]) == true
        if board.switched
            return -1
        else
            return 1
        end
    elseif has_path(moves_even, [(i, 1) for i in 1:board.size], [(j, board.size)
                                                                 for j in 1:board.size])  == true
        if board.switched
            return 1
        else
            return -1
        end
    else
        return 0
    end
end

function Base.show(io::IO, board::Board)
    if board.size > 26
        error("not implemented")
    end
    # print the first line
    for i in 1:board.size
        print(io, " ")
        print(io, Char(96+i))
        print(io, " ")
    end
    print(io, "\n")
    for i in 1:board.size
        leading_spaces = i-1
        if i>9
            leading_spaces -= 1
        end
        for k in 1:leading_spaces
            print(io, " ")
        end

        print(io, i)
        print(io, "\\")

        for j in 1:board.size
            idx = findfirst(isequal((i,j)), board.moves)

            if idx !== nothing
                print(io, ["x", "o"][idx%2 + 1])
            else
                print(io, ".")
            end

            if j<board.size
                print(io, "  ")
            end
        end

        print(io, "\\")
        print(io, i)
        print(io, "\n")
    end

    # print last line
    leading_spaces = 1+board.size
    for k in 1:leading_spaces
        print(io, " ")
    end
    for i in 1:board.size
        print(io, " ")
        print(io, Char(96+i))
        print(io, " ")
    end
    print(io, "\n")

    players = board.switched ? ["x horizontally", "o vertically"] : ["o vertically", "x horizontally"]
    println(io, "Player 1: " * players[1])
    println(io, "Player 2: " * players[2])
end
