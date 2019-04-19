---
title: Let it go (ByteBandits CTF 2019)
date: 2019-04-19
tags:
- CTF
- "ByteBandits CTF 2019"
- Wireshark
categories: misc
---

{% asset_img greetings.png %}

## 振り返り

解けなかったので writeup を読んで理解を深める。

`challenge.pcap` というファイルのみが与えられるので、wireshark で分析する系。

`192.168.43.105` のプライベートアドレスから始まっているのに No.12 のパケットからは `70.168.43.105` というように意図的に変化しているという気づきが必要だったみたい。

なので `ip.dst_host matches ".168.43.105" && !ip.dst_host == 192.168.43.105` というフィルタで見やすくする。

あとは手作業で Ascii コード表を見ながら変換しても良いけど、今回は勉強のために tshark を使います。

## tshark の使い方

ファイルを読み込むためには `-r` オプションを利用します。

```shell
λ tshark -r challenge.pcap
    1   0.000000 192.168.43.105 → 139.59.43.68 NTP 92 NTP Version 4, client
    2   0.084211 139.59.43.68 → 192.168.43.105 NTP 92 NTP Version 4, server
    3   0.999783 192.168.43.105 → 14.139.56.74 NTP 92 NTP Version 4, client
    4   1.094599 14.139.56.74 → 192.168.43.105 NTP 92 NTP Version 4, server
    5   2.002148 192.168.43.105 → 139.59.82.60 NTP 92 NTP Version 4, client
    6   2.094437 139.59.82.60 → 192.168.43.105 NTP 92 NTP Version 4, server
...
```

フィルタリングするためには、続けて文字列を指定するだけです。

```shell
λ tshark -r challenge.pcap 'ip.dst_host matches ".168.43.105" && !ip.dst_host == 192.168.43.105'
   12  10.061191 13.126.27.131 → 70.168.43.105 NTP 92 NTP Version 4, server
   14  12.061155 13.126.37.14 → 76.168.43.105 NTP 92 NTP Version 4, server
   16  66.079619 139.59.43.68 → 65.168.43.105 NTP 92 NTP Version 4, server
   18  70.090156 14.139.56.74 → 71.168.43.105 NTP 92 NTP Version 4, server
   20  71.090544 139.59.82.60 → 123.168.43.105 NTP 92 NTP Version 4, server
   22  73.079222 123.108.200.124 → 87.168.43.105 NTP 92 NTP Version 4, server
   24  77.058757  52.66.5.185 → 72.168.43.105 NTP 92 NTP Version 4, server
   27  78.057764 13.126.27.131 → 51.168.43.105 NTP 92 NTP Version 4, server
   28  78.057826 13.126.37.14 → 82.168.43.105 NTP 92 NTP Version 4, server
   30 134.099006 139.59.43.68 → 51.168.43.105 NTP 92 NTP Version 4, server
   32 137.099317 139.59.82.60 → 95.168.43.105 NTP 92 NTP Version 4, server
   34 138.098850 14.139.56.74 → 72.168.43.105 NTP 92 NTP Version 4, server
   36 142.085199 123.108.200.124 → 52.168.43.105 NTP 92 NTP Version 4, server
   39 144.066050  52.66.5.185 → 86.168.43.105 NTP 92 NTP Version 4, server
   40 144.066092 13.126.27.131 → 51.168.43.105 NTP 92 NTP Version 4, server
   44 203.080395 139.59.82.60 → 95.168.43.105 NTP 92 NTP Version 4, server
   45 203.097768 139.59.43.68 → 85.168.43.105 NTP 92 NTP Version 4, server
   47 206.261853 14.139.56.74 → 95.168.43.105 NTP 92 NTP Version 4, server
   49 210.087363 123.108.200.124 → 66.168.43.105 NTP 92 NTP Version 4, server
   51 211.065469  52.66.5.185 → 51.168.43.105 NTP 92 NTP Version 4, server
   53 213.066223 13.126.27.131 → 51.168.43.105 NTP 92 NTP Version 4, server
   56 214.558692 91.189.89.198 → 110.168.43.105 NTP 92 NTP Version 4, server
   58 269.086478 139.59.82.60 → 95.168.43.105 NTP 92 NTP Version 4, server
   60 272.086971 139.59.43.68 → 65.168.43.105 NTP 92 NTP Version 4, server
   62 273.098467 14.139.56.74 → 108.168.43.105 NTP 92 NTP Version 4, server
   64 276.138734 123.108.200.124 → 108.168.43.105 NTP 92 NTP Version 4, server
   66 279.065322 13.126.27.131 → 95.168.43.105 NTP 92 NTP Version 4, server
   68 280.066704  52.66.5.185 → 77.168.43.105 NTP 92 NTP Version 4, server
   70 282.140612 13.126.37.14 → 89.168.43.105 NTP 92 NTP Version 4, server
   72 335.108844 139.59.82.60 → 95.168.43.105 NTP 92 NTP Version 4, server
   74 338.097630 139.59.43.68 → 76.168.43.105 NTP 92 NTP Version 4, server
   76 342.109866 14.139.56.74 → 105.168.43.105 NTP 92 NTP Version 4, server
   78 343.098383 123.108.200.124 → 70.168.43.105 NTP 92 NTP Version 4, server
   80 345.075915 13.126.27.131 → 51.168.43.105 NTP 92 NTP Version 4, server
   82 348.068367  52.66.5.185 → 125.168.43.105 NTP 92 NTP Version 4, server
```

`ip.dst` のフィールドのみを取り出すためには `-T fields -e ip.dst` を `-r` オプションより前に指定します。

```shell
λ tshark -T fields -e ip.dst -r challenge.pcap 'ip.dst_host matches ".168.43.105" && !ip.dst_host == 192.168.43.105'
70.168.43.105
76.168.43.105
65.168.43.105
71.168.43.105
123.168.43.105
87.168.43.105
72.168.43.105
51.168.43.105
82.168.43.105
51.168.43.105
95.168.43.105
72.168.43.105
52.168.43.105
86.168.43.105
51.168.43.105
95.168.43.105
85.168.43.105
95.168.43.105
66.168.43.105
51.168.43.105
51.168.43.105
110.168.43.105
95.168.43.105
65.168.43.105
108.168.43.105
108.168.43.105
95.168.43.105
77.168.43.105
89.168.43.105
95.168.43.105
76.168.43.105
105.168.43.105
70.168.43.105
51.168.43.105
125.168.43.105
```

あとは `awk` などを使って適当に出力すれば良いですね。

```shell
λ tshark -T fields -e ip.dst -r challenge.pcap 'ip.dst_host matches ".168.43.105" && !ip.dst_host == 192.168.43.105' | awk -F. '{printf "%c",$1}'
FLAG{WH3R3_H4V3_U_B33n_All_MY_LiF3}
```

## まとめ

`FLAG{}` の ascii コード覚えた方が良いかもしれない・・・。

 | f | l | a | g | F | L | A | G | { | }
----|
10進 | 102 | 108 | 97 | 103 | 70 | 76 | 65 | 71 | 123 | 125
16進 | 0x66 | 0x6c | 0x61 | 0x67 | 0x46 | 0x4c | 0x41 | 0x47 | 0x7b | 0x7d

## フラグ

`FLAG{WH3R3_H4V3_U_B33n_All_MY_LiF3}`

## 参考リソース

- [writeup by PwnaSonic](https://ctftime.org/writeup/14700)
- [ASCIIコード表](http://www9.plala.or.jp/sgwr-t/c_sub/ascii.html)
- [filter for partial IP address](https://osqa-ask.wireshark.org/questions/22230/filter-for-partial-ip-address)
- [D.2. tshark: Terminal-based Wireshark](https://www.wireshark.org/docs/wsug_html_chunked/AppToolstshark.html)
- [tsharkコマンドの使い方](https://qiita.com/hana_shin/items/0d997d9d9dd435727edf)
- [AWK のフィールドセパレータの真実](https://qiita.com/ngyuki/items/c9917a9392f834ea7163)