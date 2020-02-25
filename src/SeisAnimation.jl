"""
    SeisAnimation(path, d; <keyword arguments>)

make animation of a 3D cube

# Arguments
- `path::String`: path to save the generated animation.
- `d::Array{Real,3}`: 3D data to plot.

# Keyword arguments

- `wbox=6`: width of figure in inches.
- `hbox=6`: height of figure in inches.
- `dpi=100`: dots-per-inch of figure.

- `cmap="gray"`: colormap
- `pclip=98`: percentile for determining clip.
- `vmin="NULL"`: minimum value used in colormapping data.
- `vmax="NULL"`: maximum value used in colormapping data.
- `aspect="auto"`: image aspect ratio.
- `interpolation="Hanning"`: interpolation method for colormapping data.
- `title=" "`: title of plot.
- `titlesize=16`: size of title.
- `xlabel=" "`: label on x-axis.
- `ylabel=" "`: label on x-axis.
- `labelsize=14`: size of labels on axis.

- `ox=0`: first point of x-axis.
- `dx=1`: increment of x-axis.
- `oy=0`: first point of y-axis.
- `dy=1`: increment of y-axis.

- `xticks="NULL"`: ticks on x-axis.
- `yticks="NULL"`: ticks on y-axis.
- `ticksize=11`: size of labels on ticks.

- `jump=1`: number of slices jumped when making animation.
- `interal=200`: delay for each frames, default 200 ms.

# Example
```julia
julia> path = joinpath(homedir(), "Desktop/animation")
julia> SeisAnimation(path, randn(100,100,10); wbox=6, hbox=4, cmap="gray", vmax=1, vmin=-1,
                     ox=10, dx=10, oy=2, dy=2, title="wavefield", xlabel="X (m)", ylabel="Z (m)", jump=1, interval=400)
```
"""
function SeisAnimation(pathout::Ts, d::Array{Tv,3}; wbox=6, hbox=6, dpi=100,
                       cmap="gray", vmin="NULL", vmax="NULL", pclip=98,
                       ox=0, dx=1, oy=0, dy=1, aspect="auto", interpolation="Hanning",
                       title=" ", titlesize=16, xlabel=" ", ylabel=" ", labelsize=14,
                       xticks="NULL", yticks="NULL", ticksize=11, jump=1,
                       interval=200) where {Ts<:String, Tv<:AbstractFloat}

    # dimensions of data
    (n1, n2, n3) = size(d)

    # open canvas
    fig = pl.figure(figsize=(wbox,hbox), dpi=dpi, facecolor="w", edgecolor="k")

    # generate figure for each frontal slice
    ims = PyCall.PyObject[]
    for i = 1 : jump : n3

        s = d[:,:,i]

        # dynamic range
        if (vmin=="NULL" || vmax=="NULL")
           if (pclip<=100)
    	        a = -quantile(abs.(s[:]), (pclip/100))
    	     else
    	        a = -quantile(abs.(s[:]), 1)*pclip/100
    	     end
    	     b = -a
        else
    	     a = vmin
    	     b = vmax
        end

        # generate figure
        image = pl.imshow(s, cmap=cmap, vmin=a, vmax=b,
                          extent=[ox, ox+(size(s,2)-1)*dx, oy+(size(s,1)-1)*dy, oy],
                          aspect=aspect, interpolation=interpolation)

        # tile and ticks
        pl.title(title, fontsize=titlesize)
        pl.xlabel(xlabel, fontsize=labelsize)
        pl.ylabel(ylabel, fontsize=labelsize)

        xticks == "NULL" ? nothing : pl.xticks(xticks)
        yticks == "NULL" ? nothing : pl.yticks(yticks)
        ax = pl.gca()
        pl.setp(ax.get_xticklabels(), fontsize=ticksize)
        pl.setp(ax.get_yticklabels(), fontsize=ticksize)
        tight_layout()

        # save as one element of the array
        push!(ims, PyCall.PyObject[image])
    end

    # make a animation from vector of image
    ani = anim.ArtistAnimation(fig, ims, interval=interval, blit=true)

    # save the result as mp4 file
    pathout = join([pathout ".mp4"])
    ani.save(pathout)

    return nothing
end
