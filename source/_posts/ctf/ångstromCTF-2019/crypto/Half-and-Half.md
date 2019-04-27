---
title: Half and Half (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: crypto
---

{% asset_img problem.png %}

## 解説

`half_and_half.py` の内容は以下の通り。

```python
from secret import flag

def xor(x, y):
	o = ''
	for i in range(len(x)):
		o += chr(ord(x[i])^ord(y[i]))
	return o

assert len(flag) % 2 == 0

half = len(flag)//2
milk = flag[:half]
cream = flag[half:]

assert xor(milk, cream) == '\x15\x02\x07\x12\x1e\x100\x01\t\n\x01"'
```

コードを読むと、どうやらフラグの前半と後半の `xor` を計算しているということがわかる。

そしてその結果が `'\x15\x02\x07\x12\x1e\x100\x01\t\n\x01"'` になるようだ。

この文字列は16進数のコードポイント形式 (`\x15`) と数値 (`0`) と文字列 (`\t`, `"`) がまざっているため、わかりにくいが、読み解くと全部で12文字だということがわかる。

ということは以下の表の下段の `x8`, `x9`, `x10`, `x11`, `x12` と上段の `x7` は即座に計算できる。

index | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12
------|---|---|---|---|---|---|---|---|---|---|---|---|
前半の12文字 | a | c | t | f | { | x1 | x2 | x3 | x4 | x5 | x6 | x7
後半の12文字 | x8 | x9 | x10 | x11 | x12 | x13 | x14 | x15 | x16 | x17 | x18 | }
xor を計算した結果 | 0x15 | 0x02 | 0x07 | 0x12 | 0x1e | 0x10 | 0 | 0x01 | \t | \n | 0x01 | "

Haskell でこれを計算してみます。

```hs
import Data.Bits
import Data.Char

solve :: Char -> Int -> Char
solve c t = chr ((ord c) `xor` t)

xs :: [(Char, Int)]
xs = [ ('a', 0x15)
     , ('c', 0x02)
     , ('t', 0x07)
     , ('f', 0x12)
     , ('{', 0x1e)
     , ('}', ord '"')
     ]
```

```shell
> map (uncurry solve) xs
"taste_"
```

良い感じです。ここまでで、さっきの表が少し埋まりました。

index | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12
------|---|---|---|---|---|---|---|---|---|---|---|---|
前半の12文字 | a | c | t | f | { | x1 | x2 | x3 | x4 | x5 | x6 | _
後半の12文字 | t | a | s | t | e | x13 | x14 | x15 | x16 | x17 | x18 | }
xor を計算した結果 | 0x15 | 0x02 | 0x07 | 0x12 | 0x1e | 0x10 | 0 | 0x01 | \t | \n | 0x01 | "

つなげると `actf{??????_taste??????}` という形になります。

ここからはエスパーで `tastes_nice` なんじゃないかと思って計算して、失敗したので `tastes_good` でいけたって感じです。

なのでそんな感じで計算すると

```hs
xs :: [(Char, Int)]
xs = [ ('t', 0x15)
     , ('a', 0x02)
     , ('s', 0x07)
     , ('t', 0x12)
     , ('e', 0x1e)
     , ('s', 0x10)
     , ('_', ord '0')
     , ('g', 0x01)
     , ('o', ord '\t')
     , ('o', ord '\n')
     , ('d', 0x01)
     , ('}', ord '"')
     ]
```

```shell
> map (uncurry solve) xs
"actf{coffee_"
```

良い感じに前半が出てきました。あとはくっつけるだけです。

```shell
> map (uncurry solve) xs <> map fst xs
"actf{coffee_tastes_good}"
```

## フラグ

`actf{coffee_tastes_good}`