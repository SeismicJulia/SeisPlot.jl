module SeisPlot

using PyCall, Statistics, Requires, FFTW
using PyPlot
import SeisMain

#@require PyPlot
const pl    = PyNULL()
const lines = PyNULL()
const anim  = PyNULL()


export SeisPlotTX,
SeisPlotAmplitude,
SeisPlotCoordinates,
SeisPlotFK,
SeisAnimation

include("SeisAnimation.jl")
include("SeisPlotTX.jl")
include("SeisPlotCoordinates.jl")
include("SeisPlotAmplitude.jl")
include("SeisPlotFK.jl")

export pl, lines

function __init__()
    copy!(pl,    pyimport_conda("matplotlib.pyplot",    "matplotlib"))
    copy!(lines, pyimport_conda("matplotlib.lines",     "matplotlib"))
    copy!(anim,  pyimport_conda("matplotlib.animation", "matplotlib"))
end
end
