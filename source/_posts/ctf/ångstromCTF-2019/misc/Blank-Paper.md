---
title: Blank Paper (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: misc
---

{% asset_img problem.png %}

## 解説

壊れて開けない PDF からフラグを回収する問題。とりあえずpdfをダウンロードします。

マジックバイトが抜けている可能性があるので、確認します。

```shell
λ xxd blank_paper.pdf | head -n 1
00000000: 0000 0000 2d31 2e35 0a25 bff7 a2fe 0a33  ....-1.5.%.....3
```

予想通りです。あとは PDF のマジックバイトを公式リファレンスで確認して、その値で上書きすれば良さそうですね。

[Document Management – Portable Document Format – Part 1: PDF 1.7, First Edition](https://www.adobe.com/devnet/pdf/pdf_reference.html) の `7.5.2 File Header` によると

> The first line of a PDF file shall be a ***header*** consisting of the 5 characters `%PDF-` followed by a version number of the form `1.N`, where `N` is a digit between 0 and 7

と記載があるので、最初の5文字は `%PDF-` で固定ということがわかりました。それぞれの 16進数の値は以下の通りです。

Ascii | hex
------|--------
% | 0x25
P | 0x50
D | 0x44
F | 0x46
- | 0x2d

今回は先頭4バイトが抜けているので `2550 4446` とすれば良いことがわかりました。

コンテスト中は `vim` で上書きしましたが、勉強のため `dd` コマンドで作業してみます。

```shell
λ echo -n "%PDF" | dd of=blank_paper.pdf bs=1 conv=notrunc
4+0 records in
4+0 records out
4 bytes transferred in 0.000802 secs (4987 bytes/sec)
```

dd コマンドのオプション | 意味
----------|--------
of | 標準出力の代わりにファイルへ書き込む。
bs | 1回に読み書きするブロックサイズ（バイト数
conv | 指定しないと書き換えたデータがファイルの末尾となり、以降に存在していたデータは削除されてしまう。

ちゃんと変更されているかどうか確認してみます。

```shell
λ xxd blank_paper.pdf | head -n 1
00000000: 2550 4446 2d31 2e35 0a25 bff7 a2fe 0a33  %PDF-1.5.%.....3
```

良さそうですね。最後に pdf を開いてフラグゲット。

## 別解

`qpdf` を使えば、何もしなくても正しい PDF に変換することができます。

```shell
λ qpdf --qdf blank_paper.pdf out.pdf
WARNING: blank_paper.pdf: can't find PDF header
qpdf: operation succeeded with warnings; resulting file may have some problems
```

## フラグ

`actf{knot_very_interesting}`

## 参考リソース

- [PDF REFERENCE AND ADOBE EXTENSIONS TO THE PDF SPECIFICATION](https://www.adobe.com/devnet/pdf/pdf_reference.html)
- [ファイルのマジックバイト判定](http://php.o0o0.jp/article/php-magicbytes)
- [普通の Linux 環境で手軽にバイナリファイルを編集する (dd, vim)](https://qiita.com/albatross/items/a2e3c690875b321096d7)
- [【 dd 】コマンド――ブロック単位でファイルをコピー、変換する](https://www.atmarkit.co.jp/ait/articles/1711/30/news027.html)
- [QPDF Manual](http://qpdf.sourceforge.net/files/qpdf-manual.html)