# encoding: utf-8

gem "pagy"
gem "ransack"
gem "rails-i18n"

gem "rubocop", group: "development"
gem "rubocop-rails", group: "development"
gem "rubocop-performance", group: "development"
gem "rubocop-minitest", group: "development"
gem "rubocop-i18n", group: "development"
gem "rubocop-thread_safety", group: "development"
gem "erb_lint", group: "development"

# ya-rails-template を利用するように設定
application "config.templates = './lib/templates'"

# デフォルトロケール・タイムゾーンを日本に変更
application "config.i18n.default_locale = :ja"
application "config.time_zone = 'Asia/Tokyo'"
application "config.active_record.default_timezone = :local"

application(nil, env: "development") do
  "config.hosts = /.*/"
end

# pagy の初期化処理を追加
pagy_rb = File.read(Pathname.new(File.expand_path(File.dirname(__FILE__))).join('initializers').join('pagy.rb').to_s)
initializer "pagy.rb", pagy_rb

# ransack の初期化処理を追加
ransack_rb = File.read(Pathname.new(File.expand_path(File.dirname(__FILE__))).join('initializers').join('ransack.rb').to_s)
initializer "ransack.rb", ransack_rb

# select 選択肢絞り込み UI 作成用ライブラリのインストール
run "yarn add tom-select"

after_bundle do
  # scaffold ジェネレーターテンプレートのコピー
  require 'fileutils'
  FileUtils.cp_r(Pathname.new(__dir__).join('templates').to_s, Pathname.new('lib').join('templates').to_s)

  # TomSelect 用のスタイルシートを、 application.bootstrap.scss へ追記
  tom_select_style_str = <<~'EOS'

  @import "tom-select/dist/css/tom-select.bootstrap5";

  /* アコーディオンのヘッダーに色付け */
  .accordion {
    --bs-accordion-bg: var(--bs-accordion-active-bg);
  }
  EOS
  File.write(Pathname.new('app').join('assets').join('stylesheets').join('application.bootstrap.scss').to_s, tom_select_style_str, mode: "a")

  # コピーした js に定義されている関数を使えるように application.js を修正
  FileUtils.cp(
    Pathname.new(__dir__).join('javascript').join('ya-common.js').to_s,
    Pathname.new('app').join('javascript').join('ya-common.js').to_s
  )
  File.write(Pathname.new('app').join('javascript').join('application.js').to_s, "\nimport 'ya-common'\n", mode: "a")

  # ya-common を importmap に登録
  File.write(Pathname.new('config').join('importmap.rb').to_s, 'pin "ya-common", to: "ya-common.js"' + "\n", mode: "a")

  # TomSelect を importmap に登録
  system('./bin/importmap pin tom-select@2.3.0')


  # 辞書ファイルのコピー
  locales_from = Dir.glob(Pathname.new(File.expand_path(File.dirname(__FILE__))).join('config').join('locales').join('*').to_s)
  locales_to = Pathname.new('config').join('locales').to_s
  puts "copy locales from: #{locales_from}, to: #{locales_to}"
  FileUtils.cp(locales_from, locales_to)

  # dotfile のコピー
  dotfiles_from = Dir.glob(Pathname.new(File.expand_path(File.dirname(__FILE__))).join('dotfile').join('.*').to_s, File::FNM_DOTMATCH).reject { |e| e =~ /\.{1,2}$/ }
  dotfiles_to = Pathname.new('.').to_s
  puts "copy dotfiles from: #{dotfiles_from}, to: #{dotfiles_to}"
  FileUtils.cp(dotfiles_from, dotfiles_to)
end
