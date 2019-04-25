---
title: Control You (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: web
---

{% asset_img problem.png %}

## 解説

リンク先に飛ぶと目が痛いページが・・・。

{% asset_img process1.png %}

ソースコードにフラグが書いてあった。

```shell
λ curl https://controlyou.2019.chall.actf.co/ | grep actf
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   991  100   991    0     0   1256      0 --:--:-- --:--:-- --:--:--  1257
		if (flag.value === "actf{control_u_so_we_can't_control_you}") {
```

## フラグ

`actf{control_u_so_we_can't_control_you}`