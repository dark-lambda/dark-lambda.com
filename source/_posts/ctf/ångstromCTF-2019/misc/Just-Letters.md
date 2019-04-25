---
title: Just Letters (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: misc
---

{% asset_img problem.png %}

## 解説

結構面白かった。

とりあえず接続して適当なコマンドを打ってみる。

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> a

λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> ls
```

全然わからない。何も表示されない。問題文のリンク先に飛ぶと `AlphaBeta` っていう `brainfuck's` 系の言語の説明があった。

Example の `Hello World!` を実際に試す。

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> cccCISccccCIScccCIYxSGSHaaCLgDLihhhDLDLgggDLTTGaaCLSGccbbbCLDLgggDLjggggDLSHDLTTGaaaCL
Hello World!
```

なんかでた。理解を深めるため、命令を短くする。wikipedia の内容によるうと

> L outputs a character to the screen

ということなので、最初に出現する `L` 以降を削除してみる。

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> cccCISccccCIScccCIYxSGSHaaCL
H
```

予想通り、1文字だけ出力された。また、文字より数値を出力させた方がデバッグしやすいので

> M     outputs a number to the screen

の通り `M` を使う。また、レジスタ1,2は `a`, `g` でインクリメンタルできるらしい。

> a     adds 1 to register 1
> g     adds 1 to register 2

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> aM
0

λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> gM
0⏎
```

全然変わらない。ということはレジスタ3が怪しい。

> C     sets register 3 to the value of register 1
> D     sets register 3 to the value of register 2

レジスタ3に値をセットするためには `C` か `D` を使えば良さそう。

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> aCM
1
```

ビンゴ。つまり、レジスタ1,2でメモリの内容を読み取り、その値をレジスタ3にコピーしたあとで出力すれば良さそうだとわかった。

あとは wikipedia の内容をもう少し読めば

> G     sets register 1 to the memory at the memory pointer
> S     adds 1 to the register

が使えそうだとわかる。またフラグはメモリの先頭から始まっているらしいので

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> GCM
97

λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> GCL
a

λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> GCLSGCL
ac
```

解けそう。最後に適当に繰り返して終わり。

```shell
λ nc misc.2019.chall.actf.co 19600
Welcome to the AlphaBeta interpreter! The flag is at the start of memory. You get one line:
> GCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCLSGCL
actf{esolangs_sure_are_fun!}
```

## フラグ

`actf{esolangs_sure_are_fun!}`

## 参考リソース

- [AlphaBeta](https://esolangs.org/wiki/AlphaBeta)