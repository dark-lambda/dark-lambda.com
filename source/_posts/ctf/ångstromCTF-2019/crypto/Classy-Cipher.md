---
title: Classy Cipher (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: crypto
---

{% asset_img problem.png %}

## 解説

`classy_cipher.py` の内容は以下の通り。

```python
from secret import flag, shift

def encrypt(d, s):
	e = ''
	for c in d:
		e += chr((ord(c)+s) % 0xff)
	return e

assert encrypt(flag, shift) == ':<M?TLH8<A:KFBG@V'
```

フラグを `shift` 分ずらしてるだけ。フラグの形式は `actf{xxxxxx}` となっているはずなので `a` と `:` が対応するような `shift` を探す。

Haskell で書くとこんな感じ。

```hs
import Data.Char

solve :: Char -> Char -> Int
solve plain encrypted = head [ n | n <- [0..0xff], shift n plain == encrypted]

shift :: Int -> Char -> Char
shift k c = chr ((ord c + k) `mod` 0xff)
```

試してみます。

```shell
*Main> solve 'a' ':'
216
```

シフト数がわかったので復号します。

```shell
*Main> map (shift (-216)) ":<M?TLH8<A:KFBG@V"
"actf{so_charming}"
```

## フラグ

`actf{so_charming}`