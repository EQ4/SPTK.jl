function test_swipe()
    println("test f0 estimation")
    srand(98765)
    dummy_input = rand(1024)

    println("-- test_swipe")

    for otype in [0, 1, 2]
        for fs in [16000]
            for hopsize in [40, 80, 160, 320]
                f0 = swipe(dummy_input, fs, hopsize, otype=otype)
                @test all(isfinite(f0))
                otype == 0 && @test all(f0 .>= 0)
            end
        end
    end

    # invalid otype
    @test_throws ArgumentError swipe(dummy_input, 16000, 80, otype=-1)
    @test_throws ArgumentError swipe(dummy_input, 16000, 80, otype=-3)

    # invalid min/max
    @test_throws ArgumentError swipe(dummy_input, 16000, 80, min=60.0, max=60.0)
    swipe(dummy_input, 16000, 80, min=60.0, max=7999.0)
    @test_throws ArgumentError swipe(dummy_input, 16000, 80, min=60.0, max=8000.0)
end

function test_rapt()
    println("test f0 estimation")
    srand(98765)
    dummy_input = rand(Float32, 1024)

    println("-- test_rapt")
    for otype in [0, 1, 2]
        for fs in [16000]
            for hopsize in [40, 80, 160, 320]
                f0 = rapt(dummy_input, fs, hopsize, otype=otype)
                @test all(isfinite(f0))
                otype == 0 && @test all(f0 .>= 0)
            end
        end
    end

    fs = 16000

    # invalid otype
    @test_throws ArgumentError rapt(dummy_input, fs, 80, otype=-1)
    @test_throws ArgumentError rapt(dummy_input, fs, 80, otype=-3)

    # invalid min/max
    @test_throws ArgumentError rapt(dummy_input, 16000, 80, min=60.0, max=60.0)
    @test_throws ArgumentError rapt(dummy_input, 16000, 80, min=60.0, max=8000.0)

    # valid frame period (corner case)
    rapt(rand(Float32, 10000), fs, 1600)

    # invalid frame_period
    @test_throws ArgumentError rapt(dummy_input, fs, 1601)

    # invalid input length (too small)
    @test_throws Exception rapt(dummy_input[:100], fs, 80)
end

test_swipe()
test_rapt()
