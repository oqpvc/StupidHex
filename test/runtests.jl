using StupidHex
using Random
using Test

@testset "distance test" begin
    p = (1,1)
    q = (1,3)
    r = (4,4)
    s = (3,2)
    d = StupidHex.distance
    @test d(p, q) == 2
    @test d(p, r) == 6
    @test d(p, s) == 3
    @test d(q, r) == 4
    @test d(q, s) == 2
    @test d(r, s) == 3
    @test d(p, q) == d(q, p)
    @test d(p, r) == d(r, p)
    @test d(p, s) == d(s, p)
    @test d(q, r) == d(r, q)
    @test d(q, s) == d(s, q)
    @test d(r, s) == d(s, r)
end

@testset "path finding test" begin
    nodes = [(1,1), (1,2), (1,3), (2,3), (3,2)]
    @test StupidHex.has_path(nodes, [(1,1)], [(3,2)]) == true
    @test StupidHex.has_path(nodes, [(2,1)], [(3,2)]) == false
    @test StupidHex.has_path(nodes, [(1,1), (2,1)], [(3,2)]) == true
    @test StupidHex.has_path(nodes, [(1,1), (2,1)], [(3,1)]) == false
    @test StupidHex.has_path(nodes, [(1,1), (2,1)], [(3,1), (3,2)]) == true
end

@testset "random vs random gameplay" begin
    r = StupidHex.Player(b -> StupidHex.next_board(b, StupidHex.random))
    for i in 1:70
        g, p = StupidHex.game_loop(r, r, 7)
        @test p != 0
    end
    for i in 1:10
        g, p = StupidHex.game_loop(r, r, 11)
        @test p != 0
        g, p = StupidHex.game_loop(r, r, 13)
        @test p != 0
        g, p = StupidHex.game_loop(r, r, 17)
        @test p != 0
    end
end
