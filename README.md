# ena

[![Build Status](https://travis-ci.org/kwappa/ena.svg)](https://travis-ci.org/kwappa/ena)
[![Coverage Status](https://coveralls.io/repos/kwappa/ena/badge.png?branch=master)](https://coveralls.io/r/kwappa/ena?branch=master)
[![Code Climate](https://codeclimate.com/github/kwappa/ena/badges/gpa.svg)](https://codeclimate.com/github/kwappa/ena)

ena : engineer's name archive

## How to install

### run in local environment (MacOS X)

#### qiita-markdown

* [Qiita::Markdownを使う on Yosemite - Qiita](http://qiita.com/kwappa/items/020f745f880538f0b0ec)

```
% brew install icu4c
% brew install cmake
```

```
% git clone https://github.com/github/gemoji.git
% bundle install
```

```
diff --git a/Rakefile b/Rakefile
index 2cea5c9..64965dc 100644
--- a/Rakefile
+++ b/Rakefile
@@ -1,4 +1,5 @@
 require 'rake/testtask'
+load 'lib/tasks/emoji.rake'

 task :default => :test
```

```
% bundle exec rake emoji
% mv public/images/emoji #{ENA_ROOT_DIR}/public/images
```

#### nokogiri

* [Ruby - nokogiri を bundle install する on Mavericks - Qiita](http://qiita.com/kwappa/items/20eecde98c81cc08cba8)

```
% brew tap homebrew/dupes
% brew install libiconv
% brew install libxml2
% brew link --force libxml2
% bundle config build.nokogiri --use-system-libraries
```

#### Pygments

if Internal Server Error is raised when highlight code by Pygments (maybe it happens on Mavericks), you have to install pygments manually.

```
% easy_install Pygments
```

## How to deploy to Heroku

specify build pack url via Heroku Toolbelt

```
% heroku config:set BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-multi.git
```

custom buildpacks to install `libicu-dev` and `cmake` are specified in `.buildpacks`.
