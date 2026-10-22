"""Opening Range Breakout (ORB) with retest - intraday backtester.

Rules (per day, regular session only, times in US/Eastern):
  1. Opening range = high/low of the first N minutes (default 15: 9:30-9:45).
  2. Breakout: a bar after the range closes beyond the range (above high = long
     setup, below low = short setup). The first breakout of the day decides
     the direction.
  3. Retest: a later bar trades back to the broken level (low <= range high
     + tolerance for longs) but closes on the breakout side (close >= range
     high). A close back inside the range before a retest cancels the setup.
  4. Entry: price then breaks the retest bar's extreme (high for longs).
     Filled at that level (or the bar open if it gaps through) plus slippage.
  5. Exit: stop, target at R_MULT * risk, or at the session close.
     Stop is either the opposite side of the range ("range") or the retest
     bar's extreme ("retest").
  One trade per day max; no new entries after LAST_ENTRY.

Mode "immediate" skips the retest and enters on the close of the breakout
bar, as a baseline to compare against.

Input: CSV with columns timestamp,open,high,low,close[,volume].
Timestamps are converted to US/Eastern.
"""

import argparse
from dataclasses import dataclass

import numpy as np
import pandas as pd

SESSION_OPEN = pd.Timedelta(hours=9, minutes=30)
LAST_ENTRY = pd.Timedelta(hours=15)
SESSION_CLOSE = pd.Timedelta(hours=16)


@dataclass
class Params:
    or_minutes: int = 15
    mode: str = "retest"          # "retest" or "immediate"
    stop: str = "range"           # "range" or "retest"
    r_mult: float = 2.0
    retest_tol: float = 0.0005    # 0.05% of price counts as "touching" the level
    slippage: float = 0.0002      # per side, fraction of price
    commission: float = 0.0001    # per side, fraction of price


def load_bars(path):
    df = pd.read_csv(path)
    df.columns = [c.lower() for c in df.columns]
    ts = pd.to_datetime(df["timestamp"], utc=True).dt.tz_convert("America/New_York")
    df = df.assign(timestamp=ts).set_index("timestamp").sort_index()
    tod = df.index - df.index.normalize()
    return df[(tod >= SESSION_OPEN) & (tod < SESSION_CLOSE)]


def _bar_minutes(day):
    return int(pd.Series(day.index).diff().dropna().mode().iloc[0].total_seconds() // 60)


def run_day(day, p):
    tod = day.index - day.index.normalize()
    or_end = SESSION_OPEN + pd.Timedelta(minutes=p.or_minutes)
    rng = day[tod < or_end]
    rest = day[tod >= or_end]
    if len(rng) < p.or_minutes // _bar_minutes(day) or rest.empty:
        return None
    hi, lo = rng["high"].max(), rng["low"].min()

    side = None          # +1 long, -1 short
    retest_bar = None
    entry = stop = None
    entry_time = None
    rows = list(rest.itertuples())

    for i, b in enumerate(rows):
        t = b.Index - b.Index.normalize()
        if entry is None:
            if t >= LAST_ENTRY:
                return None
            if side is None:
                if b.close > hi:
                    side = 1
                elif b.close < lo:
                    side = -1
                else:
                    continue
                if p.mode == "immediate":
                    entry, entry_time = b.close, b.Index
                    stop = lo if side == 1 else hi
                continue
            level = hi if side == 1 else lo
            tol = level * p.retest_tol
            if retest_bar is None:
                if (side == 1 and b.close < level) or (side == -1 and b.close > level):
                    return None  # failed breakout, back inside the range
                touched = b.low <= level + tol if side == 1 else b.high >= level - tol
                if touched:
                    retest_bar = b
                continue
            trigger = retest_bar.high if side == 1 else retest_bar.low
            if (side == 1 and b.close < level) or (side == -1 and b.close > level):
                return None
            if (side == 1 and b.high > trigger) or (side == -1 and b.low < trigger):
                entry = max(b.open, trigger) if side == 1 else min(b.open, trigger)
                entry_time = b.Index
                if p.stop == "retest":
                    stop = retest_bar.low if side == 1 else retest_bar.high
                else:
                    stop = lo if side == 1 else hi
                # this bar may also hit stop/target; fall through to exit check
            else:
                # a new deeper touch of the level becomes the retest bar
                if (side == 1 and b.low <= level + tol) or (side == -1 and b.high >= level - tol):
                    retest_bar = b
                continue

        risk = (entry - stop) * side
        if risk <= 0:
            return None
        target = entry + side * p.r_mult * risk
        exit_px, reason = None, None
        if side == 1:
            if b.low <= stop:
                exit_px, reason = min(b.open, stop) if b.Index != entry_time else stop, "stop"
            elif b.high >= target and b.Index != entry_time:
                exit_px, reason = max(b.open, target), "target"
        else:
            if b.high >= stop:
                exit_px, reason = max(b.open, stop) if b.Index != entry_time else stop, "stop"
            elif b.low <= target and b.Index != entry_time:
                exit_px, reason = min(b.open, target), "target"
        if exit_px is None and i == len(rows) - 1:
            exit_px, reason = b.close, "close"
        if exit_px is not None:
            cost = (p.slippage + p.commission) * (entry + exit_px)
            pnl = side * (exit_px - entry) - cost
            return dict(date=day.index[0].date(), side="long" if side == 1 else "short",
                        entry_time=entry_time.time(), entry=entry, stop=stop, target=target,
                        exit_time=b.Index.time(), exit=exit_px, reason=reason,
                        ret=pnl / entry, r=pnl / risk)
    return None


def backtest(bars, p):
    trades = [t for _, d in bars.groupby(bars.index.date) if (t := run_day(d, p))]
    return pd.DataFrame(trades)


def summarize(trades, n_days):
    if trades.empty:
        return dict(trades=0)
    eq = (1 + trades["ret"]).cumprod()
    dd = (eq / eq.cummax() - 1).min()
    wins = trades["r"] > 0
    gross_win = trades.loc[wins, "ret"].sum()
    gross_loss = -trades.loc[~wins, "ret"].sum()
    return dict(
        trades=len(trades),
        days=n_days,
        win_rate=wins.mean(),
        avg_r=trades["r"].mean(),
        profit_factor=gross_win / gross_loss if gross_loss else np.inf,
        total_return=eq.iloc[-1] - 1,
        max_drawdown=dd,
        long_trades=(trades["side"] == "long").sum(),
        short_trades=(trades["side"] == "short").sum(),
        targets=(trades["reason"] == "target").mean(),
        stops=(trades["reason"] == "stop").mean(),
    )


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("csv")
    ap.add_argument("--or-minutes", type=int, default=15)
    ap.add_argument("--mode", choices=["retest", "immediate"], default="retest")
    ap.add_argument("--stop", choices=["range", "retest"], default="range")
    ap.add_argument("--r-mult", type=float, default=2.0)
    ap.add_argument("--trades-out")
    a = ap.parse_args()
    bars = load_bars(a.csv)
    p = Params(or_minutes=a.or_minutes, mode=a.mode, stop=a.stop, r_mult=a.r_mult)
    trades = backtest(bars, p)
    for k, v in summarize(trades, len(set(bars.index.date))).items():
        print(f"{k:>14}: {v:.3f}" if isinstance(v, float) else f"{k:>14}: {v}")
    if a.trades_out:
        trades.to_csv(a.trades_out, index=False)


if __name__ == "__main__":
    main()
