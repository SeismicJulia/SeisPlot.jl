using Documenter
using SeisPlot

makedocs(
    sitename = "SeisPlot",
    format = Documenter.HTML(),
    modules = [SeisPlot]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
