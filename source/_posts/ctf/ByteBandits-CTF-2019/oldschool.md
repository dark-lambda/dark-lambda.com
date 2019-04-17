---
title: oldschool (ByteBandits CTF 2019)
date: 2019-04-17
tags:
- CTF
- "ByteBandits CTF 2019"
- study
- Haskell
categories: crypto
---

## 振り返り

解けなかったので writeup を読んで理解を深める。

`oldschool` という単語なのでシーザー暗号 (Caesar cipher) だと思ったらアフィン暗号 (Affine Cipher) だった・・・。

## アフィン暗号 (Affine Cipher)

Wikipedia によると定義は以下の通り。E と D はそれぞれ Encryption と Decryption の頭文字。

{% raw %}
$$
\begin{aligned}
E(x) & = (ax + b) \bmod m \\
D(x) & = a^{-1} (x-b) \bmod m
\end{aligned}
$$
{% endraw %}

それぞれの変数は以下の通り

変数名 | 意味
-------|---------
m | 出現する文字の種類数 (アルファベットなら 26, 平仮名なら50, etc)
a | 暗号化の鍵1, ただし a と m が互いに素 (最大公約数が1) になるように a を選ぶ
b | 暗号化の鍵2
x | 数値に変換した平文, 0 ~ m-1 のどれかと対応する

ここで \\( a^{-1} \\)は `modular multiplicative inverse of a modulo m` であり、以下の等式を満たす。

{% raw %}
$$
\begin{aligned}
1 = a a^{-1} \bmod m
\end{aligned}
$$
{% endraw %}

ちゃんと復号できることの証明

法則名 | 等式
----|-----
Identity | \\( (a \bmod m) \bmod m = a \bmod m \\)
Distributive | \\( a+b \bmod m = ((a \bmod m) + (b \bmod m)) \bmod m \\)
Distributive | \\( ab \bmod m = ((a \bmod m) (b \bmod m)) \bmod m \\)

証明

{% raw %}
$$
\begin{aligned}
D(E(x)) & = a^{-1} (E(x) - b) \bmod m \\
& = a^{-1} (((ax + b) \bmod m) - b) \bmod m \\
& = ((a^{-1} \bmod m) ((((ax + b) \bmod m) - b) \bmod m)) \bmod m \\
& = ((a^{-1} \bmod m) (( (((ax + b) \bmod m) \bmod m) + (-b) \bmod m) \bmod m)) \bmod m \\
& = ((a^{-1} \bmod m) (( ((ax + b) \bmod m) + (-b) \bmod m) \bmod m)) \bmod m \\
& = ((a^{-1} \bmod m) (( ax + b - b) \bmod m)) \bmod m \\
& = ((a^{-1} \bmod m) (ax \bmod m)) \bmod m \\
& = a^{-1}ax \bmod m \\
& = (a^{-1}a \bmod m) (x \bmod m) \bmod m \\
& = (x \bmod m) \bmod m \\
& = x \bmod m \\
& = x
\end{aligned}
$$
{% endraw %}

### シーザー暗号との関係

\\(a=1\\)の時はシーザー暗号になります。

## 具体例

具体例として大文字のアルファベット26文字を考えます。(m=26)

そのため、アルファベットと数の対応表は以下の通り。

平文 | A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z
----|
x | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25

### 暗号化

平文が `AFFINE CIPHER` とした場合の各文字が対応する数値および、暗号化の鍵を \\( a=5, b=8 \\) を選んだ場合の暗号化後の数値、最終的な暗号文を表にすると以下の通り。

平文 | A | F | F | I | N | E | C | I | P | H | E | R
-----|
x | 0 | 5 | 5 | 8 | 13 | 4 | 2 | 8 | 15 | 7 | 4 | 17
(5x + 8) | 8 | 33 | 33 | 48 | 73 | 28 | 18 | 48 | 83 | 43 | 28 | 93
(5x + 8) mod 26 | 8 | 7 | 7 | 22 | 21 | 2 | 18 | 22 | 5 | 17 | 2 | 15
暗号文 | I | H | H | W | V | C | S | W | F | R | C | P

この結果から、`AFFINE CIPHER` は `IHHWVC SWFRCP` に暗号化されることがわかります。

### 復号化

復号化の第一ステップとして\\( a^{-1} \\)の値を考えてみましょう。

\\( a^{-1} \\) というのは次の等式を満たす数 (モジュラ逆数) でした。

{% raw %}
$$
\begin{aligned}
1 = a a^{-1} \bmod m
\end{aligned}
$$
{% endraw %}

上記の等式を理解するために `ベズーの等式(Bézout's identity)` と呼ばれる定理を見てみましょう。(\\(a, b\\)は0ではない整数です)

{% raw %}
$$
\begin{aligned}
ax+by=gcd(a,b)
\end{aligned}
$$
{% endraw %}

ここで、わかりやすさのために変数名を変更します。

{% raw %}
$$
\begin{aligned}
aa^{-1}+my &= gcd(a,m)
\end{aligned}
$$
{% endraw %}

さらに \\(a\\) と \\(m\\) が互いに素であると仮定しているため

{% raw %}
$$
\begin{aligned}
aa^{-1}+my &= gcd(a,m) = 1
\end{aligned}
$$
{% endraw %}

が成り立ち、式を整理すると

{% raw %}
$$
\begin{aligned}
aa^{-1}+my &= 1 \\
aa^{-1}-1 &= (-y)m
\end{aligned}
$$
{% endraw %}

となり、\\(\mod m\\) で表せば

{% raw %}
$$
\begin{aligned}
aa^{-1} \equiv 1 (\bmod m)
\end{aligned}
$$
{% endraw %}

となります。これで最初の等式と関連する合同式を導くことができました。\\( a^{-1} \\) は \\(a\\) と \\(m\\) が互いに素であれば必ず存在するという事実は、このベズーの等式によって保証されています。

では次に、実際に \\(a^{-1}\\) の値を計算するためにはどうすれば良いのでしょうか？そのためには、拡張ユークリッドの互除法を使います。

ユークリッドの互除法により、与えられた2つの数の最大公約数を求めることができますが、拡張ユークリッドの互除法は最大公約数とともに、ベズーの等式を満たす\\(x,y\\)の組を求めることができます。

{% raw %}
$$
\begin{aligned}
ax+by &= gcd(a,b)
\end{aligned}
$$
{% endraw %}

アルゴリズムの詳細についてはここでは説明しませんが、計算すると \\(a^{-1} = -5\\) が求まります。

今回の場合 \\(a^{-1}\\) の \\(a\\) は \\(5\\) なので \\( 5^{-1}\\) は \\( 21 \\) を選んでみましょう。(拡張ユークリッドの互除法で計算すると \\(-5\\) が出てきますが、わかりやすさのため +26 した 21 を使うことにします)

先ほどの等式を満たすかどうか確認してみます。

{% raw %}
$$
\begin{aligned}
& 5 \cdot 5^{-1} \bmod 26 \\
&= 5 \cdot 21 \bmod 26 \\
&= 105 \bmod 26 \\
&= 1
\end{aligned}
$$
{% endraw %}

問題なさそうです。

これで必要な値が全て求まったため、実際に計算できるようになりました。

暗号文 | I | H | H | W | V | C | S | W | F | R | C | P
-----|
y | 8 | 7 | 7 | 22 | 21 | 2 | 18 | 22 | 5 | 17 | 2 | 15
21(y − 8) | 0 | −21 | −21 | 294 | 273 | −126 | 210 | 294 | −63 | 189 | −126 | 147
21(y − 8) mod 26 | 0 | 5 | 5 | 8 | 13 | 4 | 2 | 8 | 15 | 7 | 4 | 17
平文 | A | F | F | I | N | E | C | I | P | H | E | R

この結果から、`IHHWVC SWFRCP` を `AFFINE CIPHER` に正しく復号できたことがわかります。

## Haskell で実装してみる

ここまで理解すれば実際に実装できそうなので、Haskell でアフィン暗号を暗号化・復号化する関数を書いてみましょう。

まずは `encryption` 関数を定義します。

```hs
module Affine (encryption) where

type Key = (Int, Int) -- 暗号鍵 a, b のペア

encryption :: Key -> Char -> Char
encryption (a,b) c = substD e
  where
    e = (a*x + b) `mod` m
    m = 26
    x = substE c

substE :: Char -> Int
substE c = fromEnum c - fromEnum 'A'

substD :: Int-> Char
substD i = toEnum (i + fromEnum 'A')
```

素朴に書けばこんな感じです。

```haskell
> encryption (5,8) 'A'
'I'

> encryption (5,8) 'F'
'H'

> map (encryption (5,8) "AFFINE CIPHER"
"IHHWVCZSWFRCP"
```

空白の扱いで、ちょっとバグってますね。もう少し良い感じに直しましょう。

```hs
encryption :: Key -> Char -> Char
encryption (a,b) c
  | c `elem` ['A'..'Z'] = substD e
  | otherwise = c
  where
    e = (a*x + b) `mod` m
    m = 26
    x = substE c
```

```hs
> map (encryption (5,8)) "AFFINE CIPHER"
"IHHWVC SWFRCP"
```

良い感じになりました。

次に復号化する関数 `decryption` を定義します。拡張ユークリッドの互除法の計算は cryptonite の [gcde](https://www.stackage.org/haddock/lts-13.17/cryptonite-0.25/Crypto-Number-Basic.html#v:gcde) を利用しています。

```hs
decryption :: Key -> Char -> Char
decryption (a,b) c
  | c `elem` ['A'..'Z'] = substD e
  | otherwise = c
  where
    e = fromIntegral invA * (x-b) `mod` m
    m = 26
    x = substE c
    (invA, _y, _v) = gcde (toInteger a) (toInteger m)
```

```shell
> map (decryption (5,8)) "IHHWVC SWFRCP"
"AFFINE CIPHER"
```

これで暗号・復号のための処理が実装できました。

## 今回の問題

`Csj mexp vz gvmM3wjkCMwnHCs3XmMvkjDvQs3w` が暗号文です。暗号化の鍵である \\(a, b\\) は不明です。

そのため、適当な `a` と `b` を選んで試してみましょう。26 と互いに素な最小の `a` は 3 なのでそれを使います。`b` は 0~25 までの全てを表示するようにしてみましょう。とりあえず、動かしたいので全部大文字にしておきます。

```hs
crack :: Int -> String -> IO ()
crack a crypted = forM_ [0..25] $ \i -> do
  putStr $ show i <> ": "
  putStrLn $ map (decryption (a, i) . toUpper) crypted
```

```shell
> crack 3 "Csj mexp vz gvmM3wjkCMwnHCs3XmMvkjDvQs3w"
0: SGD EKZF HR CHEE3QDMSEQNLSG3ZEEHMDBHOG3Q
1: JXU VBQW YI TYVV3HUDJVHECJX3QVVYDUSYFX3H
2: AOL MSHN PZ KPMM3YLUAMYVTAO3HMMPULJPWO3Y
3: RFC DJYE GQ BGDD3PCLRDPMKRF3YDDGLCAGNF3P
4: IWT UAPV XH SXUU3GTCIUGDBIW3PUUXCTRXEW3G
5: ZNK LRGM OY JOLL3XKTZLXUSZN3GLLOTKIOVN3X
6: QEB CIXD FP AFCC3OBKQCOLJQE3XCCFKBZFME3O
7: HVS TZOU WG RWTT3FSBHTFCAHV3OTTWBSQWDV3F
8: YMJ KQFL NX INKK3WJSYKWTRYM3FKKNSJHNUM3W
9: PDA BHWC EO ZEBB3NAJPBNKIPD3WBBEJAYELD3N
10: GUR SYNT VF QVSS3ERAGSEBZGU3NSSVARPVCU3E
11: XLI JPEK MW HMJJ3VIRXJVSQXL3EJJMRIGMTL3V
12: OCZ AGVB DN YDAA3MZIOAMJHOC3VAADIZXDKC3M
13: FTQ RXMS UE PURR3DQZFRDAYFT3MRRUZQOUBT3D
14: WKH IODJ LV GLII3UHQWIURPWK3DIILQHFLSK3U
15: NBY ZFUA CM XCZZ3LYHNZLIGNB3UZZCHYWCJB3L
16: ESP QWLR TD OTQQ3CPYEQCZXES3LQQTYPNTAS3C
17: VJG HNCI KU FKHH3TGPVHTQOVJ3CHHKPGEKRJ3T
18: MAX YETZ BL WBYY3KXGMYKHFMA3TYYBGXVBIA3K
19: DRO PVKQ SC NSPP3BOXDPBYWDR3KPPSXOMSZR3B
20: UIF GMBH JT EJGG3SFOUGSPNUI3BGGJOFDJQI3S
21: LZW XDSY AK VAXX3JWFLXJGELZ3SXXAFWUAHZ3J
22: CQN OUJP RB MROO3ANWCOAXVCQ3JOORWNLRYQ3A
23: THE FLAG IS DIFF3RENTFROMTH3AFFINECIPH3R
24: KYV WCRX ZJ UZWW3IVEKWIFDKY3RWWZEVTZGY3I
25: BPM NTIO QA LQNN3ZMVBNZWUBP3INNQVMKQXP3Z
```

\\(a=3, b=23\\) の時に `THE FLAG IS DIFF3RENTFROMTH3AFFINECIPH3R` ってなってますね。大文字と小文字の両方に対応できるように改良します。

```hs
decryption :: Key -> Char -> Char
decryption (a,b) c
  | c `elem` ['A'..'Z'] || c `elem` ['a'..'z'] = substD base e
  | otherwise = c
  where
    e = fromIntegral invA * (x-b) `mod` m
    m = 26
    x = substE c
    (invA, _y, _v) = gcde (toInteger a) (toInteger m)
    base = if isUpper c then 'A' else 'a'

substE :: Char -> Int
substE c = fromEnum c - fromEnum base
  where
    base = if isUpper c then 'A' else 'a'

substD :: Char -> Int-> Char
substD base i = toEnum (i + fromEnum base)

crack :: Int -> String -> IO ()
crack a crypted = forM_ [0..25] $ \i -> do
  putStr $ show i <> ": "
  putStrLn $ map (decryption (a, i)) crypted
```

```shell
> map (decryption (3,23)) "Csj mexp vz gvmM3wjkCMwnHCs3XmMvkjDvQs3w"
"The flag is difF3renTFroMTh3AfFineCiPh3r"
```

ということで復習完了。

参考にした writeup は [Cryptii](https://cryptii.com/pipes/caesar-cipher) というサービスでポチポチ数値変えてました。

## フラグ

`flag{difF3renTFroMTh3AfFineCiPh3r}`

## 参考リソース

- [Affine cipher - Wikipedia](https://en.wikipedia.org/wiki/Affine_cipher)
- [Modulo operation - Wikipedia](https://en.wikipedia.org/wiki/Modulo_operation)
- [Modular multiplicative inverse - Wikipedia](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse)
- [Extended Euclidean algorithm - Wikipedia](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm)
- [Bézout's identity](https://en.wikipedia.org/wiki/B%C3%A9zout%27s_identity)
- [writeup by warlock_rootx](https://ctftime.org/writeup/14628)
- [writeup by Team_M](https://ctftime.org/writeup/14615)