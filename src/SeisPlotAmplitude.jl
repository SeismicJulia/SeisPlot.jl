"""
    SeisPlotAmplitude(d,fmax,dt ; <keyword arguments>)

Plot amplitude-frequency 2D seismic data `d`


# Arguments
- `d::Array{Real,2}`: 2D data to plot.
- `fmax::Real`: maximum frequency.
- `dt::Real`: time sample interval.

# Keyword arguments

- `title=" "`: title of plot.
- `titlesize=16`: size of title.
- `xlabel=" "`: label on x-axis.
- `xunits=" "`: units of y-axis.
- `ylabel=" "`: label on x-axis.
- `yunits=" "`: units of y-axis.
- `labelsize=14`: size of labels on axis.
- `ox=0`: first point of x-axis.
- `dx=1`: increment of x-axis.
- `oy=0`: first point of y-axis.
- `xticks="NULL"`: ticks on x-axis.
- `yticks="NULL"`: ticks on y-axis.
- `xticklabels="NULL"`: labels on ticks of x-axis.
- `yticklabels="NULL"`: labels on ticks of y-axis.
- `ticksize=11`: size of labels on ticks.
- `fignum="NULL"`: number of figure.
- `wbox=6`: width of figure in inches.
- `hbox=6`: height of figure in inches.
- `dpi=100`: dots-per-inch of figure.
- `name="NULL"`: name of the figure to save (only if `name` is given).

# Example
```julia
julia> d = SeisLinearEvents(); SeisPlotAmplitude(d,100,0.004);
```

Credits: Aaron Stanton, 2015
"""
function SeisPlotAmplitude(d::Array{T<Real,2}, fmax::Real, dt::Real;
                           title=" ", titlesize=16, xlabel=" ", xunits=" ",
                           ylabel=" ", yunits=" ", labelsize=14, ox=0, dx=1,
                           oy=0, xticks="NULL", yticks="NULL",
                           xticklabels="NULL", yticklabels="NULL", ticksize=11,
                           fignum="NULL", wbox=6, hbox=6, dpi=100, name="NULL")

pl[:ion]()
if (fignum == "NULL")
    fig = pl[:figure](figsize=(wbox, hbox), dpi=dpi, facecolor="w",
                       edgecolor="k")
else
	fig = pl[:figure](num=fignum, figsize=(wbox, hbox), dpi=dpi,
                           facecolor="w", edgecolor="k")
end


xlabel = "Frequency"
xunits = "(Hz)"
ylabel = "Ampltitude"
yunits = ""

nx = size(d[:,:], 2)
df = 1/dt/size(d[:, :], 1)
FMAX = df*size(d[:, :], 1)/2
if fmax > FMAX
    fmax = FMAX
end
nf = convert(Int32, floor((size(d[:, :], 1)/2)*fmax/FMAX))
y = fftshift(sum(abs.(fft(d[:, :], 1)), dims=2))/nx
y = y[round(Int,end/2):round(Int, end/2)+nf]
norm = maximum(y[:])
if (norm > 0.)
	y = y/norm
end

x = collect(0:df:fmax)
im = pl[:plot](x, y)

pl[:title](title)
pl[:xlabel](join([xlabel " " xunits]))
pl[:ylabel](join([ylabel " " yunits]))
pl[:axis]([0, fmax, 0, 1.1])
pl[:title](title, fontsize=titlesize)
pl[:xlabel](join([xlabel " " xunits]), fontsize=labelsize)
pl[:ylabel](join([ylabel " " yunits]), fontsize=labelsize)
xticks == "NULL" ? nothing : pl[:xticks](xticks)
yticks == "NULL" ? nothing : pl[:yticks](yticks)
ax = pl[:gca]()
xticklabels == "NULL" ? nothing : ax[:set_xticklabels](xticklabels)
yticklabels == "NULL" ? nothing : ax[:set_yticklabels](yticklabels)
pl[:setp](ax[:get_xticklabels](), fontsize=ticksize)
pl[:setp](ax[:get_yticklabels](), fontsize=ticksize)

if (name == "NULL")
    pl[:show]()
else
    pl[:savefig](name, dpi=dpi)
    pl[:close]()
end

return im

end
