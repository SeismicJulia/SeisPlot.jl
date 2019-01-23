module SeisPlot

using PyCall, Statistics, Requires, FFTW
using PyPlot

#@require PyPlot
const pl = PyNULL()
const lines= PyNULL()


export SeisPlotTX,
SeisPlotAmplitude,
SeisPlotCoordinates,
SeisPlotFK

include("SeisPlotTX.jl")
include("SeisPlotCoordinates.jl")
include("SeisPlotAmplitude.jl")
include("SeisPlotFK.jl")

export pl, lines

function __init__()
    copy!(pl,pyimport_conda("matplotlib.pyplot","matplotlib"))
    copy!(lines,pyimport_conda("matplotlib.lines","matplotlib"))
end
end
