---
title: EasyPHP (ByteBandits CTF 2019)
date: 2019-04-14
tags: ["ByteBandits CTF 2019", PHP]
categories: [CTF, web]
---

## 解説

http://easyphp.ctf.euristica.in/ にアクセスすると以下の **PHP** のコードが表示される。

```php
<?php
$hashed_key = '79abe9e217c2532193f910434453b2b9521a94c25ddc2e34f55947dea77d70ff';
$parsed = parse_url($_SERVER['REQUEST_URI']);
if(isset($parsed["query"])){
    $query = $parsed["query"];
    $parsed_query = parse_str($query);
    if($parsed_query!=NULL){
        $action = $parsed_query['action'];
    }

    if($action==="auth"){
        $key = $_GET["key"];
        $hashed_input = hash('sha256', $key);
        //echo $hashed_input.'\n';
        if($hashed_input!==$hashed_key){
            die("GTFO!");
        }

        echo file_get_contents("/flag");
    }
}else{
    show_source(__FILE__);
}
?>
```

コードを読むと以下の部分はすぐにわかる。

- クエリ文字列パラメータを指定することで1つ目 (と2つ目) の `if` を突破できる
  - 1つ目のif: `if(isset($parsed["query"]))`
  - 2つ目のif: `if($parsed_query!=NULL)`
- `$action` には `?action=xxxx` で指定した値が入るので、`?action=auth` とすれば3つ目の `if` が突破できる
  - 3つ目のif: `if($action==="auth")`

問題は4つ目の `if($hashed_input!==$hashed_key)` をどうするかという感じ。

この問題では [parse_str](https://www.php.net/manual/ja/function.parse-str.php) に着目する。マニュアルによると

> URL 経由で渡されるクエリ文字列と同様に encoded_string を処理し、現在のスコープに変数をセットします。
> `parse_str ( string $encoded_string [, array &$result ] ) : void`

と説明がある。つまり、定義済みの変数を上書きするようだ・・・。(`$parsed_query = parse_str($query);` このように代入してるけど無意味)

ここまでわかればあとは簡単で、方針は以下の通り

1. `$hashed_input` と `$hashed_key` を同じ値にしたい
1. `$hashed_key` は変更できない感じがあるが、実際にはクエリパラメータに `hashed_key=xxxx` を渡せば `parse_str` により任意の値に上書きできる
1. `$hashed_input` は与えられた文字列を `sha256` でハッシュ化しているだけ

以上のことから http://easyphp.ctf.euristica.in/?action=auth&hashed_key=ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb&key=a のようなURLにアクセスすればフラグゲット

## フラグ

`flag{ezPz_pHp_0b9fd0f8}`

## 参考リソース

- [parse_str](https://www.php.net/manual/ja/function.parse-str.php)