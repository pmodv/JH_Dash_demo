using JuliaHub
using Sockets,Dash,CSV
using DataFrames
using PlotlyJS


# download CSV file (we don't need to specify the project - associates by user)
data_ref = JuliaHub.dataset("phil-vernes","csv_data")
abs_path = pwd()

# check to make sure dataset isn't already downloaded
if !isfile(abs_path*"/"*"csv_data.csv")
    # first argument is dataset reference; second is desired filename in instance
    JuliaHub.download_dataset(data_ref,"csv_data.csv");
end

# sample data for Histograms - loaded into a dataframe
df = CSV.read(abs_path*"/"*"csv_data.csv",DataFrame)

# PlotlyJS API

hist = make_subplots(rows=3,cols=1)

add_trace!(hist, PlotlyJS.histogram(df,x=:d1,nbinsx=1,name="d1"),row=1,col=1)
add_trace!(hist, PlotlyJS.histogram(df,x=:d2,nbinsx=5,name="d2"),row=2,col=1)
add_trace!(hist, PlotlyJS.histogram(df,x=:d3,nbinsx=15,name="d3"),row=3,col=1)

relayout!(hist, title_text="Histogram subplots")



port = 8229
app = dash(requests_pathname_prefix="/proxy/$port/",external_stylesheets = ["/assets/dash_demo.css"])

app.title = "Interactive Plotting - Julia and Dash"

app.layout = html_div() do
    html_h1("Histograms - Interactive binning"),

    html_div(className = "row") do

        html_div(className = "plot column",
            dcc_graph(
            id = "plot",
            figure = hist
            )
        ),

        # parent div of all the sliders - note the "style" Dict which we can use to shift it down (which I did)
        html_div(className = "slider column") do
            
            html_div(id = "d1-slider-div", className="slider"), 
            
            dcc_slider(
                id = "d1-slider",
                min = 1,
                max = 50,
                step = 1,
                value = 10.
            ),

            html_div(id = "d2-slider-div", className="slider"),
            
            dcc_slider(
                id = "d2-slider",
                min = 1,
                max = 50,
                step = 1,
                value = 5
            ),

            html_div(id = "d3-slider-div",className="slider"),
            
            dcc_slider(
                id = "d3-slider",
                min = 1,
                max = 50,
                step = 1,
                value = 15
            )

        end
    end
end

# we have a multiple-input callback for our chart 
# you can not have more than one callback for a given target
callback!(
    app,  # "plot" is component id;  "figure" is a propery of the "plot" component
    # note:  dcc_graph does not accept a value for its "children" property
    # hence, we use its "figure" property
    Output("plot", "figure"),
    # again, "d1-slider" is component id; "value" is a property of this "d1-slider"
    Input("d1-slider","value"),
    Input("d2-slider","value"),
    Input("d3-slider", "value")
) do d1_bin, d2_bin, d3_bin
    "d1 bin size: $(d1_bin)" 
    "d2 bin size: $(d2_bin)"
    "d3 bin size: $(d3_bin)"   

    hist = make_subplots(rows=3,cols=1)

    add_trace!(hist, PlotlyJS.histogram(df,x=:d1,nbinsx=d1_bin,name="d1"),row=1,col=1)
    add_trace!(hist, PlotlyJS.histogram(df,x=:d2,nbinsx=d2_bin,name="d2"),row=2,col=1)
    add_trace!(hist, PlotlyJS.histogram(df,x=:d3,nbinsx=d3_bin,name="d3"),row=3,col=1)
    
    relayout!(hist, title_text="Histogram subplots")

    return hist
end

# callback so the sliders show their values

# callback to send slider value to be displayed under first slider component
callback!(
    app,
    # we use the "children" property for setting value for "div" components 
    # you will see this used for the rest of the callbacks that refresh
    # the slider value 
    Output("d1-slider-div", "children"),
    Input("d1-slider", "value")
) do d1_bin_value
    "d1 bin size: $(d1_bin_value)"
end

# callback to send slider value to be displayed under second slider component
callback!(
    app,
    Output("d2-slider-div", "children"),
    Input("d2-slider", "value")
) do d2_bin_value
  "d2 bin size : $(d2_bin_value)"
end

# callback to send slider value to be displayed under third slider component
callback!(
    app,
    Output("d3-slider-div", "children"),
    Input("d3-slider", "value")
) do d3_bin_value
  "d3 bin size : $(d3_bin_value)"
end

run_server(app, Sockets.localhost, port)