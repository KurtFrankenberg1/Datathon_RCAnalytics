import pandas as pd
import time

tickers = ['NU','RA.MX','^MXX']
dataset = {}

for ticker in tickers:
   df = pd.read_csv(f'https://query1.finance.yahoo.com/v7/finance/download/{ticker}?period1=1557064300&period2=1714920684&interval=1d&events=history&includeAdjustedClose=true')
   df['ticker'] = ticker
   dataset[ticker] = df
   time.sleep(1)

stock = pd.concat(dataset)
stock = stock.reset_index(drop=True)
print(stock)