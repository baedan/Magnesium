using Magnesium
using Documenter

DocMeta.setdocmeta!(Magnesium, :DocTestSetup, :(using Magnesium); recursive=true)

makedocs(;
    modules=[Magnesium],
    authors="baedan <anarchotransformer@proton.me> and contributors",
    repo="https://github.com/baedan/Magnesium.jl/blob/{commit}{path}#{line}",
    sitename="Magnesium.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://baedan.github.io/Magnesium.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/baedan/Magnesium.jl",
    devbranch="main",
)
