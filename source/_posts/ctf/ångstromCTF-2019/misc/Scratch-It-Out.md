---
title: Scratch It Out (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: misc
---

{% asset_img problem.png %}

## 解説

`project.json` をダウンロードして中身を見てみる。

`json isStage` のようなキーワードで検索するとプログラミング言語の `Scratch` の情報が出てくるので、たぶんこれ。

`project.json` を `project.sb2` のように名前を変更する。

```shell
λ mv project.json project.sb2
```

このファイルをオンラインエディタで開くとこんな感じ。

{% asset_img process1.png %}

動かしてみると猫がフラグを教えてくれる。

{% asset_img process2.png %}

## フラグ

`actf{Th5_0pT1maL_LANgUaG3}`

## 参考リソース

- [Scratch File Format](https://en.scratch-wiki.info/wiki/Scratch_File_Format)
- [Scratch Online Editor](https://scratch.mit.edu/projects/editor/)
- [Scratch 2.0をハッキングしてみよう その1](https://qiita.com/kobotyann/items/e43727944c5687d53dcf)