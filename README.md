# ya rails template

Rails7 標準の scaffold に、以下機能を追加したテンプレートです。

- 一覧表示をテーブル化
- Ransack による検索・ソート
- Pagy によるページング
- TomSelect による select 要素の選択肢絞り込み
- Bootstrap5 によるスタイル付け
- i18n 対応

![ya-rails-template](https://user-images.githubusercontent.com/345832/229313913-8006e124-9425-466b-957b-f3d9a5b931eb.gif)


## 開発環境

### 起動

VSCode Container 拡張機能を使うか、 Docker Compose で開発環境を立ち上げます。
(VSCode Container 拡張機能による起動の説明は省略)

※ 本リポジトリの docker-compose ファイルでは、 PostgreSQL を利用する設定となっています。必要に応じて変更してください。

```sh
docker compose up
```

### 開発コンテナへの接続

以下コマンドで、 ruby, nodejs, yarn の環境構築済みのコンテナに入れます。

```sh
docker compose exec app bash
```

## アプリケーション作成手順

### Rails プロジェクトの作成

`rails new` コマンドで、プロジェクトを生成します。

```sh
rails new app --css=bootstrap -m ./apptemplate.rb -d postgresql
```

- `--css=bootstrap`: **必須** 本テンプレートでは、 Bootstrap を利用しているため、必ず指定してください
- `-m apptemplate.rb`: **必須** 本テンプレートで使用するライブラリの設定や、 scaffold ジェネレーターをプロジェクトに、適用するためのアプリケーションテンプレートスクリプトです。必ず指定してください
- `-d postgresql` : 使用するデータベース。プロジェクトで使用するデータベースに応じて修正してください


### DB 設定更新

開発で使用するデータベースの設定は、 `config/database.yml` 内の `development` セクション内の項目に記載します。
必要に応じて、 `production` など、別環境の設定も行ってください。

```yaml
development:
  <<: *default
  host: postgres
  database: public
  username: admin
  password: password
```

### Scaffold 実行

```sh
./bin/rails generate scaffold Role name:string
./bin/rails generate scaffold Account name:string role:belongs_to expiration_date:date
```

### 必要に応じて Model を編集

ひとつのテーブルに対して、複数カラムで foreign key を設定している場合、モデルの `belongs_to` を適切に設定してください。

例: `app/models/present_history.rb` を編集

```rb
class PresentHistory < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "from_account_id", "to_account_id"]
  end

  belongs_to :from_account, class_name: 'Account' # この行の、 `, class_name: 'Account' を追加
  belongs_to :to_account, class_name: 'Account' # この行の、 `, class_name: 'Account' を追加
end
```

### DB マイグレーション

#### マイグレーションファイルの修正

制約があれば、 `db/migrate/*_create_*` のファイルを修正してください。

#### マイグレーション実行

以下コマンドで、マイグレーションを実行してください。

```sh
rails db:migrate
```

### 必要に応じて辞書ファイルを編集

`config/locales` に、各言語毎の辞書ファイルが格納されているので、必要に応じて文字列の修正をしてください。

モデル名や、モデルの属性名を日本語化する場合、 `config/locales/ja.yml` へ、以下のように `activerecord/models`, `activerecord/attributes` 以下に文字列の定義を追加してください。

例: `config/locales/ja.yml` を編集

```
...(snip)
ja:
  ...(snip)
  activerecord:
    models:
      account: アカウント
    attributes:
      account:
        name: 名前
        role_id: 権限
        expiration_date: 期限
        created_at: 作成日
        updated_at: 更新日
```

## 動作確認

### dev server の起動

以下コマンドで、開発用にサーバーを起動します。

```sh
BINDING=0.0.0.0 bin/dev
```

### ブラウザでの確認

Scaffold の例の通り、Item と Account を作成したとして話を進めます。

`http://localhost:3000/accounts` にアクセスすると、次の図のように、検索フォーム付きの一覧画面が表示されます。
![ya-rails-template](https://user-images.githubusercontent.com/345832/229313930-bc7d49e7-1e40-44b4-85d2-646cad58397a.png)

気に入らない挙動があれば、生成されたコードを修正してください。


## License

Copyright (C) 2025 mikoto2000

This software is released under the MIT License, see LICENSE

このソフトウェアは MIT ライセンスの下で公開されています。 LICENSE を参照してください。

## Author

mikoto2000 <mikoto2000@gmail.com>

## TODO

- [x] : i18n
- [ ] : JavaScript の組み込み方の改善

## 参考資料(ググったモノたち)

- 追加したライブラリなど
    - [Introduction | Ransack documentation](https://activerecord-hackery.github.io/ransack/)
    - [Tom Select](https://tom-select.js.org/)
    - [Home | Pagy](https://ddnexus.github.io/pagy/)
    - [Bootstrap · 世界で最も人気のあるフロントエンドフレームワーク](https://getbootstrap.jp/)

- 基本的なところ
    - [Rails7をちょっと試す（Bootstrap編） - Qiita](https://qiita.com/suketa/items/e6a37cc0b466768edf57)
    - [Rails 7.0 + Ruby 3.1でゼロからアプリを作ってみたときにハマったところあれこれ - Qiita](https://qiita.com/jnchito/items/5c41a7031404c313da1f?utm_source=pocket_reader#%E7%A2%BA%E8%AA%8D%E3%83%80%E3%82%A4%E3%82%A2%E3%83%AD%E3%82%B0confirm%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E5%87%BA%E3%81%97%E6%96%B9%E3%81%8C%E5%A4%89%E3%82%8F%E3%81%A3%E3%81%9F)
    - [ActiveRecordのjoinsとpreloadとincludesとeager_loadの違い - Qiita](https://qiita.com/k0kubun/items/80c5a5494f53bb88dc58)

- 一覧表示をテーブルにした
    - [Tables - Bootstrap 4.3 - 日本語リファレンス](https://getbootstrap.jp/docs/4.3/content/tables/)
    - [tabindexで消耗していた話 - 理系学生日記](https://kiririmode.hatenablog.jp/entry/20170317/1489704147)
    - [今ブラウザで範囲選択されている文字列を得る方法 - JavaScript TIPSふぁくとりー](https://www.nishishi.com/javascript-tips/get-selection-length.html)

- ページネーション
    - [Rails: Pagy gemでRailsアプリを高速ページネーション（翻訳）｜TechRacho by BPS株式会社](https://techracho.bpsinc.jp/hachi8833/2021_07_13/57481)
    - [Rails アプリで、ページネーションに pagy を使う。](https://zenn.dev/atelier_mirai/articles/44711464b137c5)
    - [Rails PagyでOverflowエラー - Qiita](https://qiita.com/morioka1206/items/c45f75267f0a624ad6f1)

- 検索フォーム
    - [Ransackで日付検索を期間指定する方法 – 地方でリモートワーク](https://www.tom08.net/2016-07-19-180127/)
    - [[Rails]Ransackでセレクトボックスを使用する方法 - Qiita](https://qiita.com/daichi0713/items/412ad0c6fc4fad8140e0)
    - [form_forにclass名をつける - Qiita](https://qiita.com/superman9387/items/85c079599cf8fc7303ea)
    - [Form controls · Bootstrap v5.0](https://getbootstrap.jp/docs/5.0/forms/form-control/)
    - [JavaScriptのセレクタ取得で、複数要素を否定する - 空想家 Developers Blog](https://blog-progblog-web.hatenablog.com/entry/2020/12/31/184637)
    - [Accordion(アコーディオン) · Bootstrap v5.0](https://getbootstrap.jp/docs/5.0/components/accordion/)
    - [Select2の代替にTom Selectを使ってみる - Qiita](https://qiita.com/takuya-s/items/49975d70ca0fbc27ae9a)
    - [履歴 API の操作 - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/History_API/Working_with_the_History_API)
    - [検索のTurbo Frames化 - チュートリアル2 Turboで管理画面をSPA風にする｜猫でもわかるHotwire入門 Turbo編](https://zenn.dev/shita1112/books/cat-hotwire-turbo/viewer/tutorial-2#%E6%A4%9C%E7%B4%A2%E3%81%AEturbo-frames%E5%8C%96)
    - [ruby on rails - Adding hidden field in ransack - Stack Overflow](https://stackoverflow.com/questions/18579722/adding-hidden-field-in-ransack)

- Turbo の細かいところ
    - [Turbo FramesをJavaScriptから操作 - Turbo Frames｜猫でもわかるHotwire入門 Turbo編](https://zenn.dev/shita1112/books/cat-hotwire-turbo/viewer/turbo-frames#turbo-frames%E3%82%92javascript%E3%81%8B%E3%82%89%E6%93%8D%E4%BD%9C)
    - [Turboのイベント｜猫でもわかるHotwire入門 Turbo編](https://zenn.dev/shita1112/books/cat-hotwire-turbo/viewer/event)

- テンプレート／ジェネレーター系
    - [Rails アプリケーションのテンプレート - Railsガイド](https://railsguides.jp/rails_application_templates.html)
    - [Rails ジェネレータとテンプレート入門 - Railsガイド](https://railsguides.jp/generators.html)
    - [RailsのScaffoldのテンプレートを変更する方法 - Qiita](https://qiita.com/akito1986/items/d9f379191fd6b98de955)
    - [.html.erbのコメントアウトの仕方 - Qiita](https://qiita.com/Masashi9410/items/16ce1c6da64eae497615)
    - [モデルのアソシエーション情報を調べる - Qiita](https://qiita.com/yusuke-matsuda/items/9af5e90dc4079e9d9548)
    - [ruby on rails - How to pass class_name Option to Generator? - Stack Overflow](https://stackoverflow.com/questions/52356962/how-to-pass-class-name-option-to-generator)
    - [RailsでモデルのインスタンスからURLのパスを取得する仕組み](https://zenn.dev/pofkuma/articles/7eaaf9cbc60c42)
    - [Railsで「複数カラム」かつ「共通テーブル」にアソシエーション(1対多・多対多・自己結合) - Qiita](https://qiita.com/RoaaaA/items/7f541509a1e2528e65a4)

- i18n
    - [Rails 国際化（i18n）API - Railsガイド](https://railsguides.jp/i18n.html)
    - [Railsのモデル名.human_attribute_name(:カラム名)って何だっけ？ - カクカクしかじか](https://fuqda.hatenablog.com/entry/2019/04/07/212254)
    - [RailsのI18nで引数 - blog.takuyan.com](https://takuyan.hatenablog.com/entry/20111120/1321741426)
    - [【Rails】error prohibited this user from being saved:のエラーメッセージがi18nで日本語化されない - Qiita](https://qiita.com/blackpeach7/items/f3a0b321fcbab771dabf)

- その他こまごました Tips
    - [railsのlink_toでjavascript:voidやonclickを使う方法 - Qiita](https://qiita.com/ogaaryo/items/bdae9521d5a5ae831f1a)
    - [Railsで簡単に英単語を複数形にする方法 - Qiita](https://qiita.com/narikei/items/023dbf1385e798836ae8)


