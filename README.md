# JMRouter
一个轻量级，纯Swift，协议化的路由控件

## 安装

只支持手动安装，也就是直接将源码目录放入工程😅，原因如下：

- 源码简单，加上注释300行左右


- 不同项目都会修改固定的代码来定制自己的路由格式


- JMRouter使用了枚举方式，集中式管理了所有可路由的controller，当有新的路由时，需要添加一个case

## 使用

JMRouter目前支持跳转某个controller，以及执行特定的action，如下

```
/// 1. 跳转界面可以用类似下面格式url
/// scheme1://page/map?title="地图"

/// 2. 执行action可以用类似下面格式url，这里表示打电话
/// scheme2://action/tel?phone=xxxxxx
```

使用时只需执行对应的一行代码即可

```
JMRouter.routing(url: "scheme1://page/map?title="地图")
JMRouter.routing(url: "scheme2://action/tel?phone=xxxxxx")
```

routing完整定义如下

```
	/// 通过url 来跳转对应页面, 或执行某个action
	///
	/// - Parameters:
	///   - urlString: url字符串
	///   - object: 额外的参数
	///   - vc: 优先使用传入的controller来执行跳转或action，否则会自动寻找当前的controller
	///   - completion: routing完成后的回调（有动画会异步），Bool同return的返回值；注意：如果是push(animated: true)成功的，completion在0.35s后调用，这个是自定义的时间。
	/// - Returns: 如果找到了对应的page并跳转成功，或执行了对应action，返回true
	@discardableResult
	public static func routing(with urlString: String,
							   object: Any? = nil,
							   from vc: UIViewController? = nil,
							   completion: Completion? = nil) -> Bool
```

另外如果是应用内使用，建议用枚举的模式，更方便

```
/// 应用内使用枚举方式跳转更方便
JMRouter.goto(.home, from: self) { resrult, homeVc in
    YYHud.showTip(resrult ? "操作成功" : "操作失败")
}
```

当然，为了能简单使用，我们还会有些使用前准备工作😀

1. 使用前需要调用一次`JMRouter.registerPagePathMap()`，建议放到didFinishLaunchingWithOptions中

2. 想要一个controller支持路由跳转，需要实现Routable协议

   ```
   /// 路由协议 controller实现这个协议，表示支持路由跳转
   public protocol Routable {
       /// 路由界面唯一标志
   	static var routePath: JMRouter.Page { get }
   	
   	/// 路由界面出现的动画方式，目前只有 push, present，默认为push(animated:true)
   	static var routeAnimation: JMRouter.Animation { get }
   	
   	/// 路由界面如何生成
   	static func routePageCreate(with scheme: String?, parameters: [String: String]?, object: Any?) -> UIViewController?
   }
   
   /// 一些默认值
   public extension Routable {
       //static var routeUrl: String { return JMRouter.pageRoot + routePath.rawValue + "/"}
       static var routeAnimation: JMRouter.Animation { return .push(animated:true) }
   }
   ```

3. 每添加一个controller需要在JMRouter.Page中添加一个case，表示该controller的唯一路径，Action同理

      ```
      // MARK: - 支持的pages
      extension JMRouter {
          /// 声明支持的路由跳转有哪些，字符串
          public enum Page: String {
              case home
              case vc1 //key和约定的字符串一致时
              case vc2 = "nibVc" //key和约定的字符串不一致时
          }
      }
      ```

4. 没有了，没有了，没有了😜



demo中更为详细的例子，使用前可以先看看


## 更详细的定制

目前的我们使用设计规则是分别取url的

- scheme：表示支持的协议，可以配置多个
- host：表示执行操作的类型，跳转界面或执行action
- lastPathComponent：表示执行的具体操作，比如跳转到地图页，打电话等。。

这些配置在每个项目中可能都有自己的规则，所以可以根据需求自行调整😀

**scheme定义在JMRouter.swift文件中**

```
/// 支持的schemes
public static let schemes = ["scheme1", "scheme2", "scheme3"]
```

**host分别定义在文件JMRouter+Page.swift和JMRouter+Action.swift的扩展中**

```
private extension JMRouter.Page {}
private extension JMRouter.Action {}
```

**lastPathComponent也是分别定义在JMRouter+Page.swift和JMRouter+Action.swift文件中，使用了2个枚举类型**

```
// MARK: - 支持的pages
extension JMRouter {
    /// 声明哪些controller支持路由跳转
    public enum Page: String {
        case home
        case vc1 //key和约定的字符串一致时
        case vc2 = "nibVc" //key和约定的字符串不一致时
    }
}

// MARK: - 支持的action
extension JMRouter {
    public enum Action: String {
        case tel
    }
}
```

对于一些UI层次结构比较特殊的项目，最后还有一个地方可能需要注意

**JMRouter+Page.swift**中**goto**函数里用来跳转的vc，优先使用传入的vc，否则使用app top

```
public static func goto(_ page: JMRouter.Page,
							url: String? = nil,
							parameters: [String : String]? = nil,
							object: Any? = nil,
							from vc: UIViewController? = nil,
							completion: Completion? = nil) -> UIViewController? {
     。。。   
	/// 优先使用传入的vc，否则使用app top
    guard let finalViewController = vc ?? UIViewController.appTopVC else {
        return nil
    }      
    。。。
}
```

## License

MIT License

Copyright (c) 2017 聚美优品

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

