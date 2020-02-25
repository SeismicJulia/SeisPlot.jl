"""
    SeisPlotTX(d ; <keyword arguments>)

Plot time-space,  2D seismic data `d` with color, wiggles or overlay.

# Arguments
- `d::Array{Real,2}`: 2D data to plot.


# Keyword arguments

- `style="color"`: style of the plot: `"color"`, `"wiggles"` or `"overlay"`.
- `cmap="PuOr"`: colormap for  `"color"` or `"overlay"` style.
- `pclip=98`: percentile for determining clip.
- `vmin="NULL"`: minimum value used in colormapping data.
- `vmax="NULL"`: maximum value used in colormapping data.
- `aspect="auto"`: color image aspect ratio.
- `interpolation="Hanning"`: interpolation method for colormapping data.

- `wiggle_fill_color="k"`: color for filling the positive wiggles.
- `wiggle_line_color="k"`: color for wiggles' lines.
- `wiggle_trace_increment=1`: increment for wiggle traces.
- `xcur=1.2`: wiggle excursion in traces corresponding to clip.
- `scal="NULL"`: scale for wiggles.

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
- `dy=1`: increment of y-axis.

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
julia> d = SeisLinearEvents(); SeisPlotTX(d);
```

Credits: Aaron Stanton, 2015
"""
function SeisPlotTX(d::Array{T,2}; style="color",
                           cmap="PuOr", pclip=98, vmin="NULL", vmax="NULL",
                           aspect="auto", interpolation="Hanning",
                           wiggle_fill_color="k", wiggle_line_color="k",
                           wiggle_trace_increment=1, xcur=1.2, scal="NULL",
                           title=" ", titlesize=16, xlabel=" ", xunits=" ",
                           ylabel=" ", yunits=" ", labelsize=14, ox=0, dx=1,
                           oy=0, dy=1, xticks="NULL", yticks="NULL",
                           xticklabels="NULL", yticklabels="NULL", ticksize=11,
                           fignum="NULL", wbox=6, hbox=6, dpi=100, name="NULL") where {T<:Real}

    if (vmin=="NULL" || vmax=="NULL")
        if (pclip<=100)
	    a = -quantile(abs.(d[:]), (pclip/100))
	else
	    a = -quantile(abs.(d[:]), 1)*pclip/100
	end
	b = -a
    else
	a = vmin
	b = vmax
    end
    pl.ion()
    if (fignum == "NULL")
	fig = pl.figure(figsize=(wbox, hbox), dpi=dpi, facecolor="w",
                           edgecolor="k")
    else
	fig = pl.figure(num=fignum, figsize=(wbox, hbox), dpi=dpi,
                           facecolor="w", edgecolor="k")
    end

	if (style != "wiggles")
	    imm = pl.imshow(d, cmap=cmap, vmin=a, vmax=b,
                            extent=[ox - dx/2,ox + (size(d,2)-1)*dx + dx/2,
                                    oy + (size(d,1)-1)*dy,oy],
                            aspect=aspect, interpolation=interpolation)
	end
	if (style != "color")
            style=="wiggles" ? margin = dx : margin = dx/2
	    y = oy .+ dy*collect(0:1:size(d, 1)-1)
	    x = ox .+ dx*collect(0:1:size(d, 2)-1)
	    delta = wiggle_trace_increment*dx
	    hmin = minimum(x)
	    hmax = maximum(x)
            dmax = maximum(abs.(d[:]))
	    alpha = xcur*delta
            scal=="NULL" ? alpha = alpha/maximum(abs.(d[:])) : alpha=alpha*scal
	    for k = 1:wiggle_trace_increment:size(d, 2)
		x_vert = Float64[]
		y_vert = Float64[]
		sc = x[k] * ones(size(d, 1))
        s  = d[:,k]*alpha + sc
		imm = pl.plot( s, y, wiggle_line_color)
		if (style != "overlay")
		    pl.fill_betweenx(y, sc, s, where=s.>sc, facecolor=wiggle_line_color)
		end
	    end
	    pl.axis([ox - margin, ox + (size(d, 2)-1)*dx + margin,
                      oy + (size(d, 1)-1)*dy, oy])
	end

    pl.title(title, fontsize=titlesize)
    pl.xlabel(join([xlabel " " xunits]), fontsize=labelsize)
    pl.ylabel(join([ylabel " " yunits]), fontsize=labelsize)
    xticks == "NULL" ? nothing : pl.xticks(xticks)
    yticks == "NULL" ? nothing : pl.yticks(yticks)
    ax = pl.gca()
    xticklabels == "NULL" ? nothing : ax.set_xticklabels(xticklabels)
    yticklabels == "NULL" ? nothing : ax.set_yticklabels(yticklabels)
    pl.setp(ax.get_xticklabels(), fontsize=ticksize)
    pl.setp(ax.get_yticklabels(), fontsize=ticksize)
    if (name == "NULL")
	pl.show()
    else
	pl.savefig(name, dpi=dpi)
	pl.close()
    end
    return imm
end
