# DisableHttpProxy
防止 iOS App 被抓包

## 安装
拷贝 `NSURLSession+DisableProxy.h` 和 `NSURLSession+DisableProxy.m` 到工程中即可

## 使用

```objc
[NSURLSession disableHttpProxy];
```

## 原理
让 NSURLSessionConfiguration 的 connectionProxyDictionary 属性为空即可

## 参考
[ZXRequestBlock](https://github.com/SmileZXLee/ZXRequestBlock)，但是这个由于引入了 `ZXURLProtocol` 类导致我的 React Native App 启动无法请求本地服务器，故将其核心功能抽出来单独成库
