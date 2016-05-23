#load.packages('curl', repos = 'http://cran.r-project.org')
library(quantmod)


getSymbols("DJIA", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(DJIA,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)

getSymbols("SPY", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(SPY,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)

getSymbols("AAPL", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(AAPL,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)

getSymbols("BAC", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(BAC,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)

getSymbols("NFLX", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(NFLX,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)

getSymbols("PCLN", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(PCLN,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)

getSymbols("AMZN", src = "yahoo", from = '2000-01-01',warnings = FALSE)
chartSeries(AMZN,theme = chartTheme("black", up.col='gold'),type = 'line')
addSMA(200)
