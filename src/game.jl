using Random

function human_vs_human()
    h = Player(human_play)
    g, p = game_loop(h, h, ask_board_size())
    print("\n\nGAME OVER\nPayoff: ")
    println(p)
end

function human_vs_random()
    h = Player(human_play)
    c = Player(b -> next_board(b, random))
    g, p = game_loop(h, c, ask_board_size())
    print("\n\nGAME OVER\nPayoff: ")
    println(p)
end

function random_vs_random(size = ask_board_size())
    p1 = Player(b -> next_board(b, random))
    p2 = Player(b -> next_board(b, random))
    g, p = game_loop(p1, p2, size, false)
    println(g)
    println(p)
end

function ask_board_size()
    print("Board size? [1..26] ")
    return parse(Int, readline())
end

function game_loop(player_a, player_b, board_size, random_first_player=true, output=false)
    b = Board(board_size)
    players = [player_a, player_b]
    if random_first_player
        players = Random.shuffle(players)
    end

    while payoff(b)==0
        b = players[current_player_number(b)].play(b)
        if output
            println(b)
        end
    end
    return b, payoff(b)
end
