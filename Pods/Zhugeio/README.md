# IOS SDK 集成指南

## 安装SDK
最简单的安装方式是使用[CocoaPods](http://cocoapods.org/)  
 1. 安装CocoaPod `gem install cocoapods`  
 2. 项目目录下创建`Podfile`文件，并加入一行代码: `pod 'Zhugeio'`  
 3. 项目目录下执行`pod install`，CocoaPods会自动安装Zhuge SDK，并生成工作区文件*.xcworkspace，打开该工作区即可。

你也可以直接下载来安装：  
 1. 下载[SDK](https://github.com/zhugesdk/zhuge-ios)：  
 2. 把`Zhugeio`目录拖拽到项目中  
 3. 安装所有依赖： 
    `UIKit`、`Foundation`、`SystemConfiguration`、`CoreTelephony`、`'Accelerate`、`CoreGraphics`、`QuartzCore`、`libz.tbd`、`libicucore.tbd`、`CoreMotion.framework`.

## 兼容性和ARC
 1. 诸葛SDK仅支持iOS 7.0以上系统，您需要使用Xcode 5和IOS 7.0及以上开发环境进行编译，如果您的版本较低，强烈建议升级。  
 2. 诸葛SDK默认采用ARC，如果您的项目没有采用ARC，您需要在编译(`Build Phases -> Compile Sources`)时，为每个Zhuge文件标识为`-fobj-arc`。

## 诸葛用户追踪ID方案
 1. 诸葛首选采用IDFA作为用户追踪的ID，这需要您的应用安装`AdSupport`依赖包。
 2. 如果您的应用中没有广告，采用IDFA可能会审核被拒，请在编译时加入`ZHUGE_NO_ADID`标志，诸葛将会采用IDFV作为追踪的ID。  
   xcode设置方法:  
   ```
	Build Settings > Apple LLVM 6.0 - Preprocessing > Processor Macros > Release : ZHUGE_NO_ADID=1
	```

 3. 我们鼓励调用identify方法加入自己的用户ID，这样可以把因版本升级等生成的多个ID合并到您自己统一的用户ID下。
 

## 初始化
用你的应用的AppKey启动诸葛io SDK。

```
#import "Zhuge/Zhuge.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Zhuge sharedInstance] startWithAppKey:@"Your App Key" launchOptions:launchOptions];
}
```

如果您需要修改SDK的默认设置，如打开日志打印、设置版本渠道等时，一定要在`startWithAppKey`前执行。参考代码：

```
    Zhuge *zhuge = [Zhuge sharedInstance];

    // 实时调试开关
    // 设置为YES，可在诸葛io的「实时调试」页面实时观察事件数据上传
    // 建议仅在需要时打开，调试完成后，请及时关闭
    [zhuge.config setDebug : NO];

    
    // 自定义应用版本
    [zhuge.config setAppVersion:@"0.9-beta"]; // 默认是info.plist中CFBundleShortVersionString值
    
    // 自定义渠道
    [zhuge.config setChannel:@"My App Store"]; // 默认是@"App Store"

    // 开启行为追踪
    [zhuge startWithAppKey:@"Your App Key" launchOptions:launchOptions];

```

## 识别用户身份
为了保持对用户的跟踪，你需要为每一位用户记录一个唯一的ID，你可以使用用户id、email等唯一值来作为用户在诸葛io的ID。 另外，你可以在跟踪用户的时候， 记录用户更多的属性信息，便于你更了解你的用户：

```
    //定义诸葛io中的用户ID
    NSString *userId = [user getUserId]
    
    //定义属性
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"name"] = @"zhuge";
    userInfo[@"gender"] = @"男";
    userInfo[@"birthday"] = @"2014/11/11";
    userInfo[@"avatar"] = @"http://tp2.sinaimg.cn/2885710157/180/5637236139/1";
    userInfo[@"email"] = @"hello@zhuge.io";
    userInfo[@"mobile"] = @"18901010101";
    userInfo[@"qq"] = @"91919";
    userInfo[@"weixin"] = @"121212";
    userInfo[@"weibo"] = @"122222";
    userInfo[@"location"] = @"北京朝阳区";
    userInfo[@"公司"] = @"37degree";
    [[Zhuge sharedInstance] identify:userId properties:userInfo];
```
##### 预定义的属性：

为了便于分析和页面显示，我们抽取了一些共同的属性，要统计以下数据时，可按照下面格式填写。 

|属性Key     | 说明        | 
|--------|-------------|
|name    | 名称|
|gender  | 性别(值:男,女)|
|birthday| 生日(格式: yyyy/MM/dd)|
|avatar   | 头像地址|
|email   | 邮箱|
|mobile   | 手机号|
|qq      | QQ账号|
|weixin  | 微信账号|
|weibo   | 微博账号|
|location   | 地域，如北京|

**长度限制**:Key最长支持25个字符，Value最长支持255个字符，一个汉字按3个字符计算。

## 自定义事件
你可以在`startWithAppKey `之后开始记录事件（用户行为），并可记录与该事件相关的属性信息

```
    //定义与事件相关的属性信息  
	NSMutableDictionary *properties = [NSMutableDictionary dictionary];  
	properties[@"视频名称"] = @"冰与火之歌";
	properties[@"分类"] = @"奇幻";
	properties[@"时间"] = @"5:10pm";
	properties[@"来源"] = @"首页";   //属性名称不能超过255个字符，属性值不能超	过200个字符

	//记录事件
	[[Zhuge sharedInstance] track:@"观看视频" properties: 	properties;   //事件名称不能超过32个字符
```

## 如何确认事件布点代码已正确编写？


你可以使用诸葛io的「实时调试」功能实时验证事件数据是否被诸葛io的服务器正确接收。在诸葛io统计初始化之前，调用如下代码，以开启实时调试：

	// 完成调试请及时关闭
	[zhuge.config setDebug:YES];

然后，进入诸葛io的「实时调试」页面，就可以实时观察到上传的数据。 注意：调试完成后请关闭debug。

## 如何在xcode控制台查看诸葛io SDK输出的日志？

Xcode设置方法：

要在xcode控制台查看诸葛io SDK输入的日志，请在最新版的xcode中设置：

`Build Settings > Apple LLVM 7.0 - Preprocessing > Preprocessor Macros > Debug : ZHUGE_LOG=1`

