---
title: Runes (ångstromCTF 2019)
date: 2019-04-28
tags:
- "CTF"
- "ångstromCTF 2019"
- study
- Haskell
categories: crypto
---

## 振り返り

問題文の *Paillier* が問題を解くためのヒントだということに気づけなかった。

*Paillier* 暗号というのも初めてなので、ちゃんと勉強しよう。

## Paillier 暗号

ペイエ暗号というらしい。

RSAに似てるけど加法準同型性を満たす珍しい暗号みたいで、存在を知れてよかった。

## 今回の問題の解き方

`runes.txt` には以下の内容だけが含まれています。

```text
n: 99157116611790833573985267443453374677300242114595736901854871276546481648883
g: 99157116611790833573985267443453374677300242114595736901854871276546481648884
c: 2433283484328067719826123652791700922735828879195114568755579061061723786565164234075183183699826399799223318790711772573290060335232568738641793425546869
```

まずは `msieve` で `p` と `q` の値を求めます。

```shell
λ msieve -q -v -e 99157116611790833573985267443453374677300242114595736901854871276546481648883
...
factoring 99157116611790833573985267443453374677300242114595736901854871276546481648883 (77 digits)
...
p39 factor: 310013024566643256138761337388255591613
p39 factor: 319848228152346890121384041219876391791
elapsed time 00:02:03
```

77桁なので2分程度で求まりました。

あとはこんな感じのプログラムで復号します。

```haskell
import Crypto.Number.ModArithmetic
import Crypto.Number.Serialize

import Data.Text
import Data.Text.Encoding

p, q, n, g, c :: Integer
p = 310013024566643256138761337388255591613
q = 319848228152346890121384041219876391791
n = 99157116611790833573985267443453374677300242114595736901854871276546481648883
g = 99157116611790833573985267443453374677300242114595736901854871276546481648884
c = 2433283484328067719826123652791700922735828879195114568755579061061723786565164234075183183699826399799223318790711772573290060335232568738641793425546869

l :: Integer -> Integer
l x = (x - 1) `div` n

solve :: Integer -> Integer
solve c = (l (expSafe c lambda (n^2)) * mu) `mod` n
  where
    lambda = lcm (p-1) (q-1)
    mu = inverseCoprimes (l (expSafe g lambda (n^2))) n

toDisplay :: Integer -> Text
toDisplay = decodeUtf8 . i2osp
```

実行結果

```shell
*Main> solve c
8483734412270322850839331621532480687141757

*Main> toDisplay $ solve c
"actf{crypto_lives}"
```

## フラグ

`"actf{crypto_lives}"`

## 参考リソース

- [writeup by nitrow](https://github.com/wborgeaud/ctf-writeups/blob/master/angstromctf2019/Runes.md)
- [Paillier cryptosystem](https://en.wikipedia.org/wiki/Paillier_cryptosystem)
- [公開鍵暗号 - Paillier暗号](http://elliptic-shiho.hatenablog.com/entry/2015/12/14/213328)
- [公開鍵暗号 Paillier暗号の勉強](https://ykm11.hatenablog.com/entry/2018/10/19/205950)
- [Public-Key Cryptosystems Based on Composite Degree Residuosity Classes](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.112.4035&rep=rep1&type=pdf)