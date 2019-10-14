# SQL(HQL) Beautify 

VS Code 插件用于优化SQL代码.

VS Code extension that beautifies SQL(HQL).

## Attention 注意

这个插件在hql语句上更加兼容，因为它是我的主要工作语言。

This extension is more compatible in `Hive SQL` than in other sql language.

## Features 特点

### Beautify SQL

一键美化你的SQL！请确保你使用的语言是`SQL`，选择需要优化的代码块，按下`Alt+Shift+f`即可使用！ 

Beatify your SQL!  Make sure the language is set to `SQL`,then select your sql code and press `Alt+Shift+f` just like you normally would.

![demo](https://toolsforsql.cn/demo.gif?raw=true)

### Beautify SQL DDL

一键美化你的DDL！请确保你使用的语言是`SQL`，选择需要优化的代码块，按下`Alt+Shift+l`即可使用！ 

Beatify your SQL DDL!  Make sure the language is set to `SQL`,then select your sql code and press `Alt+Shift+l`.

![demo](https://toolsforsql.cn/demo2.gif?raw=true)

## Release Notes 更迭日志

### 0.0.1

Initial release

### 0.0.4

Fix some bugs

### 0.0.7
Add beautify ddl

### 0.0.9
Support `CASE WHEN` auto-wrap

### 0.0.12
Fix some bugs of auto-wrap

### 0.1.7
Align words after `as` left

![as](https://toolsforsql.cn/as.gif?raw=true)

### 0.1.8

Fix `order by` auto-wrap when `order by` in special hql syntax like `row number() over(partition by order by)`

