---
title: CTFd を動かしてみる
date: 2020-01-05
tags:
- "CTF"
categories:
---

## インストール

```shell
λ git clone https://github.com/CTFd/CTFd.git
λ cd CTFd/
λ python3 -c "import os; f=open('.ctfd_secret_key', 'a+b'); f.write(os.urandom(64)); f.close()"
λ sudo docker-compose up
```

これで [http://localhost:8000](http://localhost:8000) にアクセス！

結構色々できてすごい。CTF の問題は Docker とかで動かせば良いっぽいね。

## 参考リソース

- [CTFd/CTFd](https://github.com/CTFd/CTFd/)
- [builtins.TypeError: must be str, not bytes](https://stackoverflow.com/questions/5512811/builtins-typeerror-must-be-str-not-bytes)
- [Install Docker Compose](https://docs.docker.com/compose/install/)