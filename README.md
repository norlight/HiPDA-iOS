# HiPDA iOS


*基于MVVM+RAC的一次实践。*

##简介

采用MVVM，Model层为瘦Model，只包含属性和少许可以自管理的解析转换逻辑。

大多情况下，每个Controller会有一个对应的mainView（可在loadView处直接赋值的view），以ViewModel初始化Controller，Controller内再用该ViewModel初始化mainView，两者共用一个ViewModel。

每个View会有一个ViewModel与之适配，View内一般会有setupViews初始化视图和bindViewModel两个阶段。

上述流程各方法使用protocol进行约定。

除了侧滑抽屉部分，应用内所有的跳转都基于ViewModel。思路来自雷纯锋大神，做了少许改进，hook了ViewModel层，避开对服务总线的依赖，可在任意ViewModel内类似[self pushViewModel:anotherVM]这样直接进行跳转。
参考：[MVVM With ReactiveCocoa](http://blog.leichunfeng.com/blog/2016/02/27/mvvm-with-reactivecocoa/)


##基本思路

爬回HTML，生成DOM，结合CSS Selector、XPath、正则等进行解析、清理、修改。

帖子详情楼层内容先进行清理，再使用DTCoreText进行原生显示。诸如投票贴、屏蔽贴、引用等特殊内容，会插入object标签，计算好尺寸，显示时用原生视图替代。

##目录结构

    .
    └── HiPDA
        ├── Model：数据层
        ├── View：视图层
        ├── ViewModel：VM层
        ├── Controller：控制器层
        ├── Resource：资源文件，图片、JSON、HTML、PLIST等
        │   └── Image：图片
        ├── Util：各种工具、通用类
        │   ├── Base：基类
        │   ├── Category：分类
        │   ├── Common：一些共有类
        │   └── Manager：单例
        └── Vendor：没使用CocoaPods管理的第三方库


##第三方类库

    .
    └── Pods
        ├── AFNetworking：网络库，必备，不多说
        ├── Aspects：AOP面向切面编程
        ├── BlocksKit：各式callback的block化
        ├── DTCoreText：HTML原生渲染
        ├── HTMLKit：HTML解析、修改，部分DOM API在Cocoa上的实现，支持CSS Selector
        ├── JDStatusBarNotification：状态栏提示
        ├── Kiwi：单元测试
        ├── MBProgressHUD：HUD提示
        ├── MJRefresh：下拉、上拉刷新
        ├── Masonry：自动布局，必备，不多说
        ├── Ono:HTML解析，支持CSS Selector、XPath
        ├── RETableViewManager：表单UI库
        ├── ReactiveCocoa：Cocoa上的函数响应式编程，重型武器，炒鸡好使
        ├── ReactiveViewModel：RAC的MVVM辅助类
        ├── RegexKitLite：正则表达式
        ├── SAMKeychain：keychain封装
        ├── SWRevealViewController：侧滑抽屉
        ├── UITableView+FDTemplateLayoutCell：几行代码解决不定行高计算
        └── YYKit：全能库，优酷大神作品