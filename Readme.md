JuliaHub Demo

This repository consists of the two main programs:  a `Pluto` program, the contents of which are included in `plutoFiles`, and the main program, in the parent directory.  

The demo illustrates how to:

* Use the `JuliaHub` package to access datasets stored on JuliaHub and read them
* Use the `Plots.jl` front-end with the `Plotly` backend:  yes, you can use *one* plotting front-end for various backends:
     https://docs.juliaplots.org/latest/backends/
* Create a minimum `Dash` application, using datasets downloaded from JuliaHub and plotting them
* Create a `Dash` application with a UI, including multiple-input callbacks and single-input callbacks

  
Kindly note that the `JuliaHub` package sits in the following repository: 
  
    https://github.com/JuliaComputing/JuliaHubClient2.jl



Main Directory Files:

* dash_demo.jl:  demo program illustrating the use of
* dash_min.jl:  "minimal" demo Dash example - useful for quickly broadcasting charts without a UI
* csv_data.csv:  the CSV data read into a dataframe by both `dash_demo.jl` and `dash_min.jl`

Sub-Directory Contents:
* Assets: dash_demo.css for `dash_demo.jl`
* plutoFiles: contains an `html` showing the notebook from the demonstration and also includes `notebook_file.jl` for reproducing the notebook.  Note:  the markdown in `notebook_file.jl` will not be executed, and so you can safely paste that code into your IDE and execute it.
