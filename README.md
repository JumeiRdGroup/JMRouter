# JMRouter

一个轻量级，纯Swift，协议化的路由控件，[使用demo](https://github.com/JumeiRdGroup/JMRouter)



## 要求

- iOS 8.0+ 
- Swift 5.0+



## 安装

```
pod 'JMRouter'
```



## 使用

1. 自定义一个enum，实现JMRoutePage协议，每个case，表示该controller的唯一路径

```
enum Page: String, JMRoutePage {
    case home //key和约定的字符串一致
    case vc1 
    case vc2 = "nibVc" //key和约定的字符串不一致时
}
```

2. 想要一个controller支持路由跳转，需要实现JMRoutable协议，比如

```
extension HomeController: JMRoutable {
    static var routePage: JMRoutePage {
        return Page.home
    }
    
    static func routePageCreated(with url: String?,
                                 parameters: [String: String]?,
                                 object: Any?) -> UIViewController? {
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateInitialViewController()
    }
}
```

3. 可以使用下面2种方式跳转，可以带额外参数，并提供跳转完成回调

```
/// 应用内使用枚举方式跳转更方便
JMRouter.goto(Page.home, from: self, object: UIColor.random) { resrult, _ in
    YYHud.showTip(resrult ? "操作成功" : "操作失败")
}
```

```
/// 使用url跳转
JMRouter.routing(with: "scheme1://page/home?title="地图") { resrult, _ in
    YYHud.showTip(resrult ? "操作成功" : "操作失败")
}
```

url类似下面这种格式，lastPathComponent为界面，可以带参数

```
/// scheme1://page/map?title="地图"
```

#### routing完整定义如下

```
/// 通过url 来跳转对应页面, 或执行某个action
///
/// - Parameters:
///   - urlString: url字符串
///   - object: 额外的参数
///   - vc: 优先使用传入的controller来执行跳转或action，否则会自动寻找当前的controller
///   - completion: routing完成后的回调（有动画会异步），Bool同return的返回值
/// - Returns: 如果找到了对应的page并跳转成功，或执行了对应action，返回true
@discardableResult
public static func routing(with urlString: String,
                          object: Any? = nil,
                          from vc: UIViewController? = nil,
                          completion: Completion? = nil) -> Bool
```

4. 在使用前需要调用一次路由注册

```
static func setup(with appDelegate: UIApplicationDelegate,
                  schemes: [String],
                  pageHost: String = "page")
```

demo中更为详细的例子，使用前可以先看看



## 更详细的说明

### 设计思路

分别取url的

- scheme：表示支持的协议，可以配置多个
- host：表示执行操作的类型，默认是page，之前还支持action，不过发现不好单独提取出来，需要自己支持吧
- lastPathComponent：表示执行的具体操作，比如跳转到地图页

这些配置在每个项目中可能都有自己的规则，所以可以根据需求自行调整😀

**scheme和host定义在JMRouter.swift文件中，通过setup参数初始化**

```
/// 支持的schemes
public static private(set) var schemes = [""]
public static private(set) var pageHost = "page"
```

**lastPathComponent的Page部分在自己工程中定义，使用枚举**

```
/// 声明哪些controller支持路由跳转
enum Page: String, JMRoutePage {
    case home
    case vc1 //key和约定的字符串一致时
    case vc2 = "nibVc" //key和约定的字符串不一致时
}
```

### 对于一些UI层次结构比较特殊的项目

还有一个地方可能需要注意

**JMRouter+Page.swift**中**goto**函数里用来跳转的vc，优先使用传入的vc，否则使用app top

```
/// 通过枚举来跳转对应页面
@discardableResult
static func goto(_ page: JMRoutePage,
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

### 路由映射

JMRouter.setup方法内部会调用registerPathMap，遍历主工程中所有类，判断是否实现JMRoutable协议来自动注册映射关系，可能会有点耗时。根据我们自己项目测试来看，大概几W个类，1秒内完成，所有看情况这步可以优化。。

```
/// 遍历所有的类，检测是否实现Routable，存入字典作为映射表，使用Router前必须先调用
static func registerPathMap(with appDelegate: UIApplicationDelegate) {
    var count: UInt32 = 0
    guard let image = class_getImageName(object_getClass(appDelegate)),
        let classes = objc_copyClassNamesForImage(image, &count) else {
            print("JMRouter registerPathMap failed!!!!!!!!!!!!!!!!!!")
            return
    }

    for i in 0 ..< Int(count) {
        if let clsName = String(cString: classes[i], encoding: .utf8)?.components(separatedBy: ".").last {
            if let cls = clsName.toClass() as? JMRoutable.Type {
                pagePathMap.updateValue(clsName, forKey: cls.routePage.rawValue)
            }
        }
    }
}
```



## License

JMRouter is available under the MIT license. See the LICENSE file for more info.