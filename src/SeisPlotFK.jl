"""
    SeisPlotFK(d; <keyword arguments>)

Plot time-space, frequency-wavenumber or amplitude-frequency 2D seismic data `d`
with color, wiggles or overlay.

# Arguments
* `d`: 2D data to plot.
* `extent`: extent of the data (optional).

# Keyword arguments
* `cmap="PuOr"`: colormap for  `"color"` or `"overlay"` style.
* `pclip=99.9`: percentile for determining clip.
* `vmin="NULL"`: minimum value used in colormapping data.
* `vmax="NULL"`: maximum value used in colormapping data.
* `aspect="auto"`: color image aspect ratio.
* `interpolation="Hanning"`: interpolation method for colormapping data.
* `fmax=100`: maximum frequency for `"FK"` or `"Amplitude"` plot.
* `title=" "`: title of plot.
* `titlesize=16`: size of title.
* `xlabel=" "`: label on x-axis.
* `xunits=" "`: units of y-axis.
* `ylabel=" "`: label on x-axis.
* `yunits=" "`: units of y-axis.
* `labelsize=14`: size of labels on axis.
* `ox=0`: first point of x-axis.
* `dx=1`: increment of x-axis.
* `oy=0`: first point of y-axis.
* `dy=1`: increment of y-axis.
* `xticks="NULL"`: ticks on x-axis.
* `yticks="NULL"`: ticks on y-axis.
* `xticklabels="NULL"`: labels on ticks of x-axis.
* `yticklabels="NULL"`: labels on ticks of y-axis.
* `ticksize=11`: size of labels on ticks.
* `fignum="NULL"`: number of figure.
* `wbox=6`: width of figure in inches.
* `hbox=6`: height of figure in inches.
* `dpi=100`: dots-per-inch of figure.
* `name="NULL"`: name of the figure to save (only if `name` is given).

# Example
```julia
julia> d, extent = SeisLinearEvents(); SeisPlotFK(d);
```

Credits: Aaron Stanton, 2015
"""
function SeisPlotFK(d::Array{T,2};
                           cmap="PuOr", pclip=99.9, vmin="NULL", vmax="NULL",
                           aspect="auto", interpolation="Hanning", fmax=100,
                           scal="NULL", title=" ", titlesize=16, xlabel=" ", xunits=" ",
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
    pl[:ion]()
    if (fignum == "NULL")
	fig = pl[:figure](figsize=(wbox, hbox), dpi=dpi, facecolor="w",
                           edgecolor="k")
    else
	fig = pl[:figure](num=fignum, figsize=(wbox, hbox), dpi=dpi,
                           facecolor="w", edgecolor="k")
    end

	xlabel = "Wavenumber"
	xunits = "(1/m)"
	ylabel = "Frequency"
	yunits = "Hz"

	dk = 1/dx/size(d[:,:], 2)
	kmin = -dk*size(d[:,:], 2)/2
	kmax =  dk*size(d[:,:], 2)/2
	df = 1/dy/size(d[:,:], 1)
	FMAX = df*size(d[:,:], 1)/2
	if fmax > FMAX
	    fmax = FMAX
	end
	nf = convert(Int32, floor((size(d[:, :], 1)/2)*fmax/FMAX))
	D = abs.(fftshift(fft(d[:, :])))
	D = D[round(Int,end/2):round(Int,end/2)+nf, :]
	if (vmin=="NULL" || vmax=="NULL")
	    a = 0.
	    if (pclip<=100)
		b = quantile(abs.(D[:]), (pclip/100))
	    else
		b = quantile(abs.(D[:]), 1)*pclip/100
	    end
	end
    im = pl[:imshow](D, cmap=cmap, vmin=a, vmax=b, extent=[kmin,kmax,fmax,0.0],
                            aspect=aspect)

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
