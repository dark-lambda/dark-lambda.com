---
title: The Mueller Report (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: misc
---

{% asset_img problem.png %}

## 解説

問題のリンク先から `full-mueller-report.pdf (138.8 MB)` をダウンロードします。(結構時間かかる)

あとは `strings` コマンドを叩くだけでフラグが出てきます。

```shell
λ strings full-mueller-report.pdf | grep actf
actf{no0o0o0_col1l1l1luuuusiioooon}
```

## フラグ

`actf{no0o0o0_col1l1l1luuuusiioooon}`