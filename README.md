<a name="logo"/>
<div align="center">
<a href="http://saig.physics.ualberta.ca/" target="_blank">
<img src="https://saig.physics.ualberta.ca/lib/tpl/dokuwiki/images/logo.png" alt="SAIG Logo" width="240" height="106"></img>
</a>
</div>

# SeisPlot.jl

[![Build Status](https://travis-ci.org/SeismicJulia/SeisPlot.jl.svg?branch=master)](https://travis-ci.org/SeismicJulia/SeisPlot.jl)

This package contains plotting tools for SeismicJulia project.

At the moment, it is updated and tested against Julia v1.

## Installation

To use this package you must first install the [Julia](http://julialang.org/downloads/) programming language.
The package uses the Julia PyPlot and PyCall packages. 
Then, run the Julia application and type, at the prompt

```using Pkg```

```Pkg.add("https://github.com/SeismicJulia/SeisPlot.jl.git")```

```using SeisPlot```

If you use the SeismicJulia project, please cite the following paper
```
@article{stanton2016efficient,
  title={Efficient geophysical research in Julia},
  author={Stanton, Aaron and Sacchi, Mauricio D},
  journal={CSEG GeoConvention 2016},
  pages={1--3},
  year={2016}
}
```

## Basic usage
For SeisMain, please refer [here](https://github.com/SeismicJulia/SeisMain.jl).

The following example produces the figure below.

```Julia
using SeisPlot
using SeisMain 
download("http://seismic.physics.ualberta.ca/data/small_stack.su","small_stack.su");
SegyToSeis("small_stack.su","small_stack",format="su",input_type="ieee");
nt = size(d,1);
dt = h[1].d1;

plotpar = Dict(:xlabel=>"X",:dx=>1,
           :ylabel=>"Time",:yunits=>"(seconds)",:oy=>0,:dy=>h[1].d1,
           :cmap=>"PuOr",:fignum=>1,
           :title=>"small_stack.su");
SeisPlot(d; style="overlay",plotpar...);


```

![plot1](http://seismic.physics.ualberta.ca/figures/616_79_PR2.png)

## For developers: contributing to the project

* New at GitHub? These [basic commands](http://seismic.physics.ualberta.ca/docs/git_basic_commands.pdf)
and this [dictionary](http://seismic.physics.ualberta.ca/docs/git_dictionary.pdf) might help.
* This [tutorial](http://seismic.physics.ualberta.ca/docs/develop_SeismicJulia.pdf) provides the basics
steps you need to follow in order to fork the main repository, change the source code in your forked
repository, commit the changes, and make pull requests using GitHub.
* For contributions to the package, please follow the general guidelines given here:
[Modifications.md](https://github.com/SeismicJulia/Seismic.jl/blob/master/Modifications.md).
