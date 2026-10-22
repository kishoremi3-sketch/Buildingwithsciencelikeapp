"""Download QQQ 5-minute regular-session bars from Interactive Brokers into a CSV.

Needs TWS or IB Gateway running locally with the API enabled
(Configure > API > Settings, port 7497 paper / 7496 live), and:
    pip install ib_async pandas

Usage:
    python fetch_ibkr.py --end 2025-11-30 --months 24 --out qqq_5m.csv
"""

import argparse

import pandas as pd
from ib_async import IB, Stock, util


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--symbol", default="QQQ")
    ap.add_argument("--end", default="2025-11-30")
    ap.add_argument("--months", type=int, default=24)
    ap.add_argument("--port", type=int, default=7497)
    ap.add_argument("--out", default="qqq_5m.csv")
    a = ap.parse_args()

    ib = IB()
    ib.connect("127.0.0.1", a.port, clientId=17)
    contract = Stock(a.symbol, "SMART", "USD")
    ib.qualifyContracts(contract)

    end = pd.Timestamp(a.end, tz="America/New_York") + pd.Timedelta(hours=16)
    start = end - pd.DateOffset(months=a.months)
    frames = []
    while end > start:
        # IBKR serves 5-minute bars in chunks; one month per request is safe
        bars = ib.reqHistoricalData(
            contract,
            endDateTime=end.tz_convert("UTC").strftime("%Y%m%d-%H:%M:%S"),
            durationStr="1 M",
            barSizeSetting="5 mins",
            whatToShow="TRADES",
            useRTH=True,
            formatDate=2,
        )
        if not bars:
            break
        df = util.df(bars)
        frames.append(df)
        print(f"{df['date'].iloc[0]} -> {df['date'].iloc[-1]}  ({len(df)} bars)")
        end = pd.Timestamp(df["date"].iloc[0])
        ib.sleep(2)  # stay under IBKR's historical-data pacing limits
    ib.disconnect()

    out = pd.concat(frames).drop_duplicates("date").sort_values("date")
    out = out[pd.to_datetime(out["date"], utc=True) >= start.tz_convert("UTC")]
    out = out.rename(columns={"date": "timestamp"})[["timestamp", "open", "high", "low", "close", "volume"]]
    out.to_csv(a.out, index=False)
    print(f"wrote {len(out)} bars to {a.out}")


if __name__ == "__main__":
    main()
