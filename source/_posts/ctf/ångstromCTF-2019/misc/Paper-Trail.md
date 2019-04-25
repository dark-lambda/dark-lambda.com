---
title: Paper Trail (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: misc
---

{% asset_img problem.png %}

## 解説

`paper_trail.pcapng` ということでネットワークのパケット問題。

Wireshark の `TCP Stream` で終わり

{% asset_img process.png %}

せっかくなので `tshark` を使ってワンライナーで抜き出す例。

```shell
λ tshark -r paper_trail.pcapng -z follow,tcp,ascii,0 | grep "^PRIVMSG" | sed 1,2d | awk -F: '{printf "%c",$2}'
actf{fake_math_papers}
```

## フラグ

`actf{fake_math_papers}`

## 参考リソース

- [awkの出力について（シングルクォーテーション、改行なし）](https://qiita.com/sora083/items/0e80488f52268677cb5e)
- [ファイルの先頭を指定行数ぶん読み飛ばす](http://mythosil.hatenablog.com/entry/2017/09/21/221411)
- [Tshark. Follow TCP Stream en modo CLI mediante estadísticas tshark.](https://seguridadyredes.wordpress.com/2012/09/20/tshark-follow-tcp-stream-en-modo-cli-mediante-estadisticas-tshark/)