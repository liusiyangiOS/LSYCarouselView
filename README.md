# LSYCarouselView

[![License MIT](https://img.shields.io/cocoapods/l/LSYCarouselView)](https://www.apache.org/licenses/LICENSE-2.0.html)
![Pod version](https://img.shields.io/cocoapods/v/LSYCarouselView)
![Pod platform](https://img.shields.io/cocoapods/p/LSYCarouselView)


  LSYCarouselView是一个基于Objective-C语言的无限轮播方案的实现
  
## LSYCarouselView 实现的功能

* 无限轮播
* 传入数据自定义解析，轮播图的数据源可以是任何类型，可实现代理自行解析
* 可配置用于展示轮播图的image，如修改contentMode
* 内容展示回调（一般用于埋点）
* 点击回调
* 控件的宽度不可以给小数，会有bug😂，不过一般情况下肯定都是整数，有时间我会修复的~

## 安装

你可以在 Podfile 中加入下面一行代码来使用 LSYCarouselView

    pod 'LSYCarouselView' ~> 1.0

## 安装要求

|    LSYCarouselView 版本    | 最低 iOS Target |        注意       |
| :-----------------------: | :------------: | :--------------: |
|            1.x            |     iOS 9      | 要求 Xcode 11 以上 |

## 相关文章

* [作者博客](https://www.jianshu.com/u/e1fee33c72bc)

## 协议

LSYCarouselView 被许可在 MIT 协议下使用。查阅 LICENSE 文件来获得更多信息。
