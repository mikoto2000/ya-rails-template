gem "pagy"
gem "ransack"
gem "rails-i18n"

gem "rubocop", group: "development"
gem "rubocop-rails", group: "development"
gem "rubocop-performance", group: "development"
gem "rubocop-minitest", group: "development"
gem "rubocop-i18n", group: "development"
gem "rubocop-thread_safety", group: "development"
gem "erb_lint", :github => 'mikoto2000/erb-lint', ref: '9ef15e20da0ad46077c88b73bac06e4edd15d2c2'

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
  ya_common_js_import_code = <<~'EOS'
/**
 * 要素の詳細画面へ遷移(Enterキーでの遷移)
 */
export function handleEnterKeypressListItem(event, target, url) {
  if (event.key === "Enter") {
    handleClick(event, target, url)
  }
}
/**
 * 要素の詳細画面へ遷移
 */
export function handleClickListItem(event, target, url) {
  // 文字列選択動作でなければクリック処理発火
  let selection = String(document.getSelection());
  if (!selection || selection.length === 0) {
    window.location = url;
  }
}
/**
 * 削除ボタンを押下した際に、 tr のクリックイベントが発火しないようにする
 */
export function handleDeleteListItem(event, target) {
  event.stopPropagation();
}
/**
 * form 内の submit, reset 以外の入力欄を空にする
 */
export function clear_form(event) {
  event.preventDefault(false);
  // input, select のクリア
  event.currentTarget.form.querySelectorAll('input:not([type=submit]):not([type=reset]):not([type=hidden]), select').forEach((e) => {
    e.value = '';
  });
  // TomSelect の表示要素クリア
  event.currentTarget.form.querySelectorAll('.tomselected').forEach((e) => {
    e.tomselect.clear();
  });
}

/* turbo frame を利用した検索をすると、クエリ文字列がアドレスバーに反映されないため自分で反映させる */
window.addEventListener('load', function() {
  const turboFrame = document.getElementById('list');
  if (turboFrame) {
    turboFrame.addEventListener('turbo:frame-load', (event) => {
      const url = new URL(event.currentTarget.src);
      window.history.pushState({ path: url.toString() }, '', url.toString());

      // pagy の 1 ページごとの表示件数フィールドの幅を 3 桁に固定する
      // turboFrame ロード時の更新
      changePagyItemsSelectorWidth();
    });
  }

  // pagy の 1 ページごとの表示件数フィールドの幅を 3 桁に固定する
  // ページロード時の更新
  changePagyItemsSelectorWidth();
});

/* pagy_items_selector_js の幅を 3 桁に固定する */
function changePagyItemsSelectorWidth() {
  const pagyItemsSelector = document.getElementById('pagy-limit-selector')?.querySelector('input');
  if (pagyItemsSelector) {
    // 表示を 3 桁に固定
    pagyItemsSelector.style.width = '3em';
    // search_form_for では、クエリパラメーターが `<form の name 属性>[<パラメーター名>]` になっているが、
    // これだと pagy のページングに使えないため、 `<パラメーター名>` の形式に無理やり変更
    document.getElementById('f-limit').name = 'limit';
    pagyItemsSelector.addEventListener('change', (event) => {
      handleOnChangePagyItemsSelectorJs(event.currentTarget);
    });
  }
}

/* pagy_items_selector_js で生成された input 要素から数値を取得し、 1 ページごとの要素数を更新する */
export function updateItemPerPage(event) {
  event.preventDefault(false);

  const pagyItemsSelector = document.getElementById('pagy-limit-selector');
  const itemPerPage = pagyItemsSelector.querySelector('input').value;

  // 現在の URL を取得
  const url = new URL(window.location);

  // url から現在のクエリ文字列を取得
  const params = new URLSearchParams(url.search);

  // pagy_items_selector_js で指定された値に上書き
  params.set('limit', itemPerPage);

  // 新 URL の作成
  const newUrl = url.origin + url.pathname + '?' + params.toString()

  // Turbo Frames のフレームを取得
  const turboFrame = document.getElementById('list');
  turboFrame.src = newUrl;
};

/* pagy_items_selector_js で生成された input 要素が更新されたら、 form の hidden 要素に反映する */
export function handleOnChangePagyItemsSelectorJs(currentTarget) {
  const itemPerPage = currentTarget.value;

  // itemPerPage を隠しフォームに反映
  const hiddenFormForItemPerPage = document.getElementById('f-limit');
  hiddenFormForItemPerPage.value = itemPerPage;
};

window.handleEnterKeypressListItem = handleEnterKeypressListItem;
window.handleClickListItem = handleClickListItem;
window.handleDeleteListItem = handleDeleteListItem;
window.clear_form = clear_form;
window.updateItemPerPage = updateItemPerPage;
window.handleOnChangePagyItemsSelectorJs = handleOnChangePagyItemsSelectorJs;

import * as TomSelect from "tom-select";

export function initTomSelect() {
  document.querySelectorAll('select').forEach((e) => {
    if (!e.tomselect) {
      new TomSelect(e, {
        plugins: {
          remove_button: {
            title:'Remove this item',
          }
        },
        field: 'text',
        direction: 'asc'
      });
    }
  });
}

document.addEventListener('turbo:load', () => {
  initTomSelect();
});

document.addEventListener('turbo:render', () => {
  initTomSelect();
});


  EOS
  File.write(Pathname.new('app').join('javascript').join('application.js').to_s, ya_common_js_import_code, mode: "a")

  # TomSelect を importmap に登録
  File.write(Pathname.new('config').join('importmap.rb').to_s, 'pin "tom-select", to: "https://cdn.jsdelivr.net/npm/tom-select@2/dist/js/tom-select.complete.min.js"', mode: "a")

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
