gem "pagy"
gem "ransack"

# ya-rails-template を利用するように設定
application "config.templates = './lib/templates'"

# デフォルトロケールを日本語に変更
application "config.i18n.default_locale = :ja"

pagy_rb = <<'EOS'
# frozen_string_literal: true

# Pagy initializer file (6.0.2)
# Customize only what you really need and notice that the core Pagy works also without any of the following lines.
# Should you just cherry pick part of this file, please maintain the require-order of the extras


# Pagy DEFAULT Variables
# See https://ddnexus.github.io/pagy/docs/api/pagy#variables
# All the Pagy::DEFAULT are set for all the Pagy instances but can be overridden per instance by just passing them to
# Pagy.new|Pagy::Countless.new|Pagy::Calendar::*.new or any of the #pagy* controller methods


# Instance variables
# See https://ddnexus.github.io/pagy/docs/api/pagy#instance-variables
Pagy::DEFAULT[:page]   = 1                                  # default
Pagy::DEFAULT[:items]  = 20                                 # default
Pagy::DEFAULT[:outset] = 0                                  # default


# Other Variables
# See https://ddnexus.github.io/pagy/docs/api/pagy#other-variables
# Pagy::DEFAULT[:size]       = [1,4,4,1]                       # default
# Pagy::DEFAULT[:page_param] = :page                           # default
# The :params can be also set as a lambda e.g ->(params){ params.exclude('useless').merge!('custom' => 'useful') }
# Pagy::DEFAULT[:params]     = {}                              # default
# Pagy::DEFAULT[:fragment]   = '#fragment'                     # example
# Pagy::DEFAULT[:link_extra] = 'data-remote="true"'            # example
# Pagy::DEFAULT[:i18n_key]   = 'pagy.item_name'                # default
# Pagy::DEFAULT[:cycle]      = true                            # example
# Pagy::DEFAULT[:request_path] = "/foo"                        # example


# Extras
# See https://ddnexus.github.io/pagy/categories/extra


# Backend Extras

# Arel extra: For better performance utilizing grouped ActiveRecord collections:
# See: https://ddnexus.github.io/pagy/docs/extras/arel
# require 'pagy/extras/arel'

# Array extra: Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
# See https://ddnexus.github.io/pagy/docs/extras/array
# require 'pagy/extras/array'

# Calendar extra: Add pagination filtering by calendar time unit (year, quarter, month, week, day)
# See https://ddnexus.github.io/pagy/docs/extras/calendar
# require 'pagy/extras/calendar'
# Default for each unit
# Pagy::Calendar::Year::DEFAULT[:order]     = :asc        # Time direction of pagination
# Pagy::Calendar::Year::DEFAULT[:format]    = '%Y'        # strftime format
#
# Pagy::Calendar::Quarter::DEFAULT[:order]  = :asc        # Time direction of pagination
# Pagy::Calendar::Quarter::DEFAULT[:format] = '%Y-Q%q'    # strftime format
#
# Pagy::Calendar::Month::DEFAULT[:order]    = :asc        # Time direction of pagination
# Pagy::Calendar::Month::DEFAULT[:format]   = '%Y-%m'     # strftime format
#
# Pagy::Calendar::Week::DEFAULT[:order]     = :asc        # Time direction of pagination
# Pagy::Calendar::Week::DEFAULT[:format]    = '%Y-%W'     # strftime format
#
# Pagy::Calendar::Day::DEFAULT[:order]      = :asc        # Time direction of pagination
# Pagy::Calendar::Day::DEFAULT[:format]     = '%Y-%m-%d'  # strftime format
#
# Uncomment the following lines, if you need calendar localization without using the I18n extra
# module LocalizePagyCalendar
#   def localize(time, opts)
#     ::I18n.l(time, **opts)
#   end
# end
# Pagy::Calendar.prepend LocalizePagyCalendar

# Countless extra: Paginate without any count, saving one query per rendering
# See https://ddnexus.github.io/pagy/docs/extras/countless
# require 'pagy/extras/countless'
# Pagy::DEFAULT[:countless_minimal] = false   # default (eager loading)

# Elasticsearch Rails extra: Paginate `ElasticsearchRails::Results` objects
# See https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails
# Default :pagy_search method: change only if you use also
# the searchkick or meilisearch extra that defines the same
# Pagy::DEFAULT[:elasticsearch_rails_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:elasticsearch_rails_search] = :search
# require 'pagy/extras/elasticsearch_rails'

# Headers extra: http response headers (and other helpers) useful for API pagination
# See http://ddnexus.github.io/pagy/extras/headers
# require 'pagy/extras/headers'
# Pagy::DEFAULT[:headers] = { page: 'Current-Page',
#                            items: 'Page-Items',
#                            count: 'Total-Count',
#                            pages: 'Total-Pages' }     # default

# Meilisearch extra: Paginate `Meilisearch` result objects
# See https://ddnexus.github.io/pagy/docs/extras/meilisearch
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or searchkick extra that define the same method
# Pagy::DEFAULT[:meilisearch_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:meilisearch_search] = :ms_search
# require 'pagy/extras/meilisearch'

# Metadata extra: Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.
# See https://ddnexus.github.io/pagy/docs/extras/metadata
# you must require the frontend helpers internal extra (BEFORE the metadata extra) ONLY if you need also the :sequels
# require 'pagy/extras/frontend_helpers'
# require 'pagy/extras/metadata'
# For performance reasons, you should explicitly set ONLY the metadata you use in the frontend
# Pagy::DEFAULT[:metadata] = %i[scaffold_url page prev next last]   # example

# Searchkick extra: Paginate `Searchkick::Results` objects
# See https://ddnexus.github.io/pagy/docs/extras/searchkick
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or meilisearch extra that defines the same
# DEFAULT[:searchkick_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:searchkick_search] = :search
# require 'pagy/extras/searchkick'
# uncomment if you are going to use Searchkick.pagy_search
# Searchkick.extend Pagy::Searchkick


# Frontend Extras

# Bootstrap extra: Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
require 'pagy/extras/bootstrap'

# Bulma extra: Add nav, nav_js and combo_nav_js helpers and templates for Bulma pagination
# See https://ddnexus.github.io/pagy/docs/extras/bulma
# require 'pagy/extras/bulma'

# Foundation extra: Add nav, nav_js and combo_nav_js helpers and templates for Foundation pagination
# See https://ddnexus.github.io/pagy/docs/extras/foundation
# require 'pagy/extras/foundation'

# Materialize extra: Add nav, nav_js and combo_nav_js helpers for Materialize pagination
# See https://ddnexus.github.io/pagy/docs/extras/materialize
# require 'pagy/extras/materialize'

# Navs extra: Add nav_js and combo_nav_js javascript helpers
# Notice: the other frontend extras add their own framework-styled versions,
# so require this extra only if you need the unstyled version
# See https://ddnexus.github.io/pagy/docs/extras/navs
# require 'pagy/extras/navs'

# Semantic extra: Add nav, nav_js and combo_nav_js helpers for Semantic UI pagination
# See https://ddnexus.github.io/pagy/docs/extras/semantic
# require 'pagy/extras/semantic'

# UIkit extra: Add nav helper and templates for UIkit pagination
# See https://ddnexus.github.io/pagy/docs/extras/uikit
# require 'pagy/extras/uikit'

# Multi size var used by the *_nav_js helpers
# See https://ddnexus.github.io/pagy/docs/extras/navs#steps
# Pagy::DEFAULT[:steps] = { 0 => [2,3,3,2], 540 => [3,5,5,3], 720 => [5,7,7,5] }   # example


# Feature Extras

# Gearbox extra: Automatically change the number of items per page depending on the page number
# See https://ddnexus.github.io/pagy/docs/extras/gearbox
# require 'pagy/extras/gearbox'
# set to false only if you want to make :gearbox_extra an opt-in variable
# Pagy::DEFAULT[:gearbox_extra] = false               # default true
# Pagy::DEFAULT[:gearbox_items] = [15, 30, 60, 100]   # default

# Items extra: Allow the client to request a custom number of items per page with an optional selector UI
# See https://ddnexus.github.io/pagy/docs/extras/items
require 'pagy/extras/items'
# set to false only if you want to make :items_extra an opt-in variable
# Pagy::DEFAULT[:items_extra] = false    # default true
# Pagy::DEFAULT[:items_param] = :items   # default
# Pagy::DEFAULT[:max_items]   = 100      # default

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/docs/extras/overflow
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page    # default  (other options: :last_page and :exception)

# Support extra: Extra support for features like: incremental, infinite, auto-scroll pagination
# See https://ddnexus.github.io/pagy/docs/extras/support
# require 'pagy/extras/support'

# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/docs/extras/trim
# require 'pagy/extras/trim'
# set to false only if you want to make :trim_extra an opt-in variable
# Pagy::DEFAULT[:trim_extra] = false # default true

# Standalone extra: Use pagy in non Rack environment/gem
# See https://ddnexus.github.io/pagy/docs/extras/standalone
# require 'pagy/extras/standalone'
# Pagy::DEFAULT[:url] = 'http://www.example.com/subdir'  # optional default


# Rails
# Enable the .js file required by the helpers that use javascript
# (pagy*_nav_js, pagy*_combo_nav_js, and pagy_items_selector_js)
# See https://ddnexus.github.io/pagy/docs/api/javascript

# With the asset pipeline
# Sprockets need to look into the pagy javascripts dir, so add it to the assets paths
# Rails.application.config.assets.paths << Pagy.root.join('javascripts')

# I18n

# Pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# See https://ddnexus.github.io/pagy/docs/api/i18n
# Notice: No need to configure anything in this section if your app uses only "en"
# or if you use the i18n extra below
#
# Examples:
# load the "de" built-in locale:
# Pagy::I18n.load(locale: 'de')
#
# load the "de" locale defined in the custom file at :filepath:
# Pagy::I18n.load(locale: 'de', filepath: 'path/to/pagy-de.yml')
#
# load the "de", "en" and "es" built-in locales:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
#
# load the "en" built-in locale, a custom "es" locale,
# and a totally custom locale complete with a custom :pluralize proc:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'en' },
#                 { locale: 'es', filepath: 'path/to/pagy-es.yml' },
#                 { locale: 'xyz',  # not built-in
#                   filepath: 'path/to/pagy-xyz.yml',
#                   pluralize: lambda{ |count| ... } )


# I18n extra: uses the standard i18n gem which is ~18x slower using ~10x more memory
# than the default pagy internal i18n (see above)
# See https://ddnexus.github.io/pagy/docs/extras/i18n
require 'pagy/extras/i18n'

# Default i18n key
# Pagy::DEFAULT[:i18n_key] = 'pagy.item_name'   # default


# When you are done setting your own default freeze it, so it will not get changed accidentally
Pagy::DEFAULT.freeze
EOS
initializer "pagy.rb", pagy_rb

ransack_rb = <<'EOS'
Ransack.configure do |config|
  config.custom_arrows = {
    up_arrow: '<i class="bi-sort-down"></i>',
    down_arrow: '<i class="bi-sort-down-alt"></i>',
    default_arrow: '<i class="bi-arrow-down-up"></i>'
  }

  config.add_predicate 'lteq_end_of_day',
    :arel_predicate => 'lteq',
    :formatter => proc {|v| v.end_of_day},
    :compounds => false

  config.add_predicate 'lteq_end_of_minute',
    :arel_predicate => 'lteq',
    :formatter => proc {|v| v + 59},
    :compounds => false
end
EOS
initializer "ransack.rb", ransack_rb

# select 選択肢絞り込み UI 作成用ライブラリのインストール
run "yarn add tom-select"

after_bundle do
  # scaffold ジェネレーターテンプレートのコピー
  require 'fileutils'
  FileUtils.cp_r(Pathname.new(__dir__).join('templates').to_s, Pathname.new('lib').join('templates').to_s)

  # TomSelect 用のスクリプトを、 application.js へ追記
  tom_select_str = <<~'EOS'

  import TomSelect from "tom-select"

  window.setupTomSelectForSingleSelect = function setupTomSelectForSingleSelect() {
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

  window.setupTomSelectForMultiSelect = function setupTomSelectForSingleSelect() {
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

  EOS
  File.write(Pathname.new('app').join('javascript').join('application.js').to_s, tom_select_str, mode: "a")

  # TomSelect 用のスタイルシートを、 application.bootstrap.scss へ追記
  tom_select_style_str = <<~'EOS'

  @import "tom-select/dist/css/tom-select.bootstrap5";

  /* アコーディオンのヘッダーに色付け */
  .accordion {
    --bs-accordion-bg: var(--bs-accordion-active-bg);
  }
  EOS
  File.write(Pathname.new('app').join('assets').join('stylesheets').join('application.bootstrap.scss').to_s, tom_select_style_str, mode: "a")

  # 全ページ共通の JavaScript を配置
  ya_common_js_code = <<~'EOS'
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
      });
    }

    const pagyItemsSelector = document.getElementById('pagy-items-selector')?.querySelector('input');
    if (pagyItemsSelector) {
      // 表示を 3 桁に固定
      pagyItemsSelector.style.width = '3em';
      // search_form_for では、クエリパラメーターが `<form の name 属性>[<パラメーター名>]` になっているが、
      // これだと pagy のページングに使えないため、 `<パラメーター名>` の形式に無理やり変更
      document.getElementById('f-items').name = 'items';
      pagyItemsSelector.addEventListener('change', (event) => {
        handleOnChangePagyItemsSelectorJs(event.currentTarget);
      });
    }
  });

  /* pagy_items_selector_js で生成された input 要素から数値を取得し、 1 ページごとの要素数を更新する */
  export function updateItemPerPage() {
    event.preventDefault(false);

    const pagyItemsSelector = document.getElementById('pagy-items-selector');
    const itemPerPage = pagyItemsSelector.querySelector('input').value;

    // 現在の URL を取得
    const url = new URL(window.location);

    // url から現在のクエリ文字列を取得
    const params = new URLSearchParams(url.search);

    // pagy_items_selector_js で指定された値に上書き
    params.set('items', itemPerPage);

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
    const hiddenFormForItemPerPage = document.getElementById('f-items');
    hiddenFormForItemPerPage.value = itemPerPage;
  };

  EOS
  File.write(Pathname.new('app').join('javascript').join('ya-common.js').to_s, ya_common_js_code, mode: "a")

  ya_common_js_import_code = <<~'EOS'

  // 行儀が悪いが、グローバルに展開してしまう
  import { handleEnterKeypressListItem, handleClickListItem, handleDeleteListItem, clear_form, updateItemPerPage, handleOnChangePagyItemsSelectorJs } from "./ya-common"
  window.handleEnterKeypressListItem = handleEnterKeypressListItem;
  window.handleClickListItem = handleClickListItem;
  window.handleDeleteListItem = handleDeleteListItem;
  window.clear_form = clear_form;
  window.updateItemPerPage = updateItemPerPage;
  window.handleOnChangePagyItemsSelectorJs = handleOnChangePagyItemsSelectorJs;

  EOS
  File.write(Pathname.new('app').join('javascript').join('application.js').to_s, ya_common_js_import_code, mode: "a")

  # 辞書ファイルのコピー
FileUtils.cp(Dir.glob(Pathname.new(File.expand_path(File.dirname(__FILE__))).join('config').join('locales').join('*').to_s), Pathname.new('config').join('locales').to_s)
end
