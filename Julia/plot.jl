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

function plotMonteCarlo(listcolors = listcolorsgrad)
  echelle = [1500000 + 10000*k for k = 1:30]
  tab = [1670528,1661410,1731737,1655218,1675659,1742432,1676167,1630005,1711317,1642368,1660285,1635878,1634662,1720643,1698019,1631610,1742537,1611023,1679491,1649772,1681944,1627968,1621227,1684128,1620138,1664278,1657785,1671681,1674595,1630976,1658343,1716714,1711568,1729568,1692494,1663316,1674002,1656059,1649772,1670748,1661894,1644063,1655684,1648842,1660326,1661204,1620407,1658163,1703592,1607730,1608473,1639422,1682566,1646070,1636794,1676918,1635643,1685650,1663819,1707717,1675323,1670568,1645102,1629720,1619450,1676830,1641750,1675050,1588842,1659174,1712394,1642657,1643874,1650663,1668493,1702216,1723663,1672372,1640737,1694225,1702810,1646749,1666262,1643815,1646018,1666006,1690202,1632094,1673690,1714518,1676442,1670217,1595669,1654564,1669603,1669159,1650899,1646163,1648444,1654526]
  results = [0 for k = 1:30]
  for i = 1:100
    results[round(Int,((tab[i]-1500000)/10000))] += 1
  end
  trace1 = [
    "x" => echelle,
    "y" => results,
    "marker" => ["color" => listcolors[1]],
    "type" => "bar"
  ]
  data = [trace1]
  layout = ["barmode" => "stack",
            "title" => "MonteCarlo results for stichastic method",
            "xaxis" => ["tickfont" => [
                "size" => 14,
                "color" => "rgb(107, 107, 107)"
              ]],
            "yaxis" => [
              "title" => "number of occurences",
              "titlefont" => [
                "size" => 16,
                "color" => "rgb(107, 107, 107)"
              ]],
              "xaxis" => [
                "title" => "revenue",
                "titlefont" => [
                  "size" => 16,
                  "color" => "rgb(107, 107, 107)"
                ]]]
  response = Plotly.plot(data, ["layout" => layout, "filename" => "stacked-bar", "fileopt" => "overwrite"])
  plot_url = response["url"]
end
