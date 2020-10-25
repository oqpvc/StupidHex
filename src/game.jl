using Random

function human_vs_human()
    h = Player(human_play)
    p = game_loop(h, h, ask_board_size())
    print("\n\nGAME OVER\nPayoff: ")
    println(p)
end

function human_vs_random()
    h = Player(human_play)
    c = Player(b -> next_board(b, random))
    p = game_loop(h, c, ask_board_size())
    print("\n\nGAME OVER\nPayoff: ")
    println(p)
end

function ask_board_size()
    print("Board size? [1..26] ")
    return parse(Int, readline())
end

function game_loop(player_a, player_b, board_size, random_first_player=true)
    b = Board(board_size)
    players = [player_a, player_b]
    if random_first_player
        players = Random.shuffle(players)
    end

    while payoff(b)==0
        b = players[current_player_number(b)].play(b)
    end
    return payoff(b)
end
