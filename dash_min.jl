
using JuliaHub,Dash, PlotlyJS
using Sockets, CSV,DataFrames

port = 8177
abs_path = pwd()

app = dash(requests_pathname_prefix="/proxy/$port/")

# download CSV file (we don't need to specify the project - associates by user)
data_ref = JuliaHub.dataset("phil-vernes","csv_data")
abs_path = pwd()

# check to make sure dataset isn't already downloaded
if !isfile(abs_path*"/"*"csv_data.csv")
    # first argument is dataset reference; second is desired filename in instance
    JuliaHub.download_dataset(data_ref,"csv_data.csv");
end

df = CSV.read(abs_path*"/"*"csv_data.csv",DataFrame)


hist = plot(df, x=:d2, kind="histogram", nbinsx=20)

hist2 = plot(df, x=:d3, kind="histogram", nbinsx=20)

# define Dash layout  (docs:  https://dash.plotly.com/layout )

app.layout = Dash.html_div() do
    Dash.html_h1("Dash 🤝 Plots"),
    Dash.dcc_graph(id = "test", figure=hist),
    Dash.dcc_graph(id = "test2", figure=hist2)
end

run_server(app, Sockets.localhost, port)