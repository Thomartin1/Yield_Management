# Learn about API authentication here: https://plot.ly/julia/getting-started
# Find your api_key here: https://plot.ly/settings/api

using Plotly

#liste de gradient de couleurs de bleu à vert sur 17 pas
listcolorsgrad = ["rgb(101, 87, 244)", #1
              "rgb(86, 96, 243)",  #2
              "rgb(86, 119, 243)", #3
              "rgb(86, 142, 243)", #4
              "rgb(85, 165, 243)", #5
              "rgb(85, 188, 243)", #6
              "rgb(85, 211, 243)", #7
              "rgb(85, 235, 243)", #8
              "rgb(84, 243, 228)", #9
              "rgb(84, 243, 204)", #10
              "rgb(84, 243, 181)", #11
              "rgb(84, 243, 157)", #12
              "rgb(83, 243, 133)", #13
              "rgb(83, 243, 109)", #14
              "rgb(83, 243, 85)",  #15
              "rgb(104, 243, 83)", #16
              "rgb(128, 242, 82)"] #17

function plotBidprice(listofbidprices, listcolors = listcolorsgrad)
  data = []
  trace1 = [
    "x" => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17],
    "y" => listofbidprices,
    "name" => "Timeframe 1",
    "marker" => ["color" => listcolors],
    "type" => "bar"
  ]
  append!(data,[trace1])

  layout = [
    "title" => "Bid-price Evolution",
    "xaxis" => ["tickfont" => [
        "size" => 14,
        "color" => "rgb(107, 107, 107)"
      ]],
    "yaxis" => [
      "title" => "Bid-price value",
      "titlefont" => [
        "size" => 16,
        "color" => "rgb(107, 107, 107)"
      ],
      "tickfont" => [
        "size" => 14,
        "color" => "rgb(107, 107, 107)"
      ]
    ],
    "legend" => [
      "x" => 0,
      "y" => 1.0,
      "bgcolor" => "rgba(255, 255, 255, 0)",
      "bordercolor" => "rgba(255, 255, 255, 0)"
    ],
    "barmode" => "group",
    "bargap" => 0.1,
    "bargroupgap" => 0
  ]
  response = Plotly.plot(data, ["layout" => layout, "filename" => "style-bar", "fileopt" => "overwrite"])
  plot_url = response["url"]
end

function plotCapacity(listoflegs, listoflistofcapacity, capacity, listcolors = listcolorsgrad)
  trace1 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[17],
    "name" => "TimeFrame 17",
    "marker" => ["color" => listcolors[1]],
    "type" => "bar"
  ]
  trace2 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[16],
    "name" => "TimeFrame 16",
    "marker" => ["color" => listcolors[2]],
    "type" => "bar"
  ]
  trace3 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[15],
    "name" => "TimeFrame 15",
    "marker" => ["color" => listcolors[3]],
    "type" => "bar"
  ]
  trace4 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[14],
    "marker" => ["color" => listcolors[4]],
    "name" => "TimeFrame 14",
    "type" => "bar"
  ]
  trace5 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[13],
    "name" => "TimeFrame 13",
    "marker" => ["color" => listcolors[5]],
    "type" => "bar"
  ]
  trace6 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[12],
    "name" => "TimeFrame 12",
    "marker" => ["color" => listcolors[6]],
    "type" => "bar"
  ]
  trace7 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[11],
    "name" => "TimeFrame 11",
    "marker" => ["color" => listcolors[7]],
    "type" => "bar"
  ]
  trace8 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[10],
    "name" => "TimeFrame 10",
    "marker" => ["color" => listcolors[8]],
    "type" => "bar"
  ]
  trace9 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[9],
    "name" => "TimeFrame 9",
    "marker" => ["color" => listcolors[9]],
    "type" => "bar"
  ]
  trace10 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[8],
    "name" => "TimeFrame 8",
    "marker" => ["color" => listcolors[10]],
    "type" => "bar"
  ]
  trace11 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[7],
    "name" => "TimeFrame 7",
    "marker" => ["color" => listcolors[11]],
    "type" => "bar"
  ]
  trace12 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[6],
    "name" => "TimeFrame 6",
    "marker" => ["color" => listcolors[12]],
    "type" => "bar"
  ]
  trace13 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[5],
    "name" => "TimeFrame 5",
    "marker" => ["color" => listcolors[13]],
    "type" => "bar"
  ]
  trace14 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[4],
    "name" => "TimeFrame 4",
    "marker" => ["color" => listcolors[14]],
    "type" => "bar"
  ]
  trace15 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[3],
    "name" => "TimeFrame 3",
    "marker" => ["color" => listcolors[15]],
    "type" => "bar"
  ]
  trace16 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[2],
    "name" => "TimeFrame 2",
    "marker" => ["color" => listcolors[16]],
    "type" => "bar"
  ]
  trace17 = [
    "x" => listoflegs,
    "y" => listoflistofcapacity[1],
    "name" => "TimeFrame 1",
    "marker" => ["color" => listcolors[17]],
    "type" => "bar"
  ]
  trace18 = [
    "x" => listoflegs,
    "y" => capacity,
    "name" => "Capacity left",
    "marker" => ["color" => "rgb(223, 12, 28)"],
    "type" => "bar"
  ]
  data = [trace1, trace2, trace3, trace4,trace5, trace6, trace7, trace8,
          trace9, trace10, trace11, trace12,trace13, trace14, trace15, trace16,
          trace17, trace18]
  layout = ["barmode" => "stack",
            "title" => "Seats sold by flight for each TimeFrame",
            "xaxis" => ["tickfont" => [
                "size" => 14,
                "color" => "rgb(107, 107, 107)"
              ]],
            "yaxis" => [
              "title" => "Seats sold",
              "titlefont" => [
                "size" => 16,
                "color" => "rgb(107, 107, 107)"
              ]]]
  response = Plotly.plot(data, ["layout" => layout, "filename" => "stacked-bar", "fileopt" => "overwrite"])
  plot_url = response["url"]
end
