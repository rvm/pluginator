# Changelog

## 1.5.0
date: 2017-06-12

- add /lib prefix check, it can be changed with `prefix: "/(lib|local_lib)"`
- allow dashes in directory names for plugin paths
- fix older rubygems compatibility
- updated ruby and rubygems versions

## 1.4.1
date: 2017-05-23

- fix compatibility with bundler 1.15

## 1.4.0
date: 2017-05-14

- reworked finding plugins, now also searches `$LOADED_FEATURES`

## 1.3.0
date: 2014-10-20

- simplified detection of gems/plugins to load, improved tests

## 1.2.0
date: 2014-09-24

- improved detection of gems/plugins to load, based on #6

## 1.1.0
date: 2014-06-06

- register only plugins that can be loaded from activated gems, fix #3

## 1.0.1
date: 2013-12-25

- divide first_ask code into smaller methods, remove duplication
- add conversiosn helper class2name

## 1.0.0
date: 2013-12-20

- Stable version released
