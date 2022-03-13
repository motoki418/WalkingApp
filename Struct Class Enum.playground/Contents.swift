import UIKit

//var greeting = "Hello, playground"
//
//class SomeClass{
//    let id: Int
//    let name: String
//
//    init(id: Int, name: String){
//        self.id = id
//        self.name = name
//    }
//    func printName(){
//        print(name)
//    }
//}
//let instance = SomeClass(id: 1, name: "name")
//instance.printName()
//
////RegisterUserクラスのスーパークラス
//class User{
//    let id: Int
//
//    var message: String{
//        return "Hello."
//    }
//
//    init(id: Int){
//        self.id = id
//    }
//
//    func printProfile(){
//        print("id: \(id)")
//        print("message: \(message)")
//    }
//}
//
////Userクラスを継承したクラス
//class RegisterUser: User{
//    let name: String
//
//    init(id: Int, name: String) {
//        self.name = name
//        super.init(id: id)
//    }
//}
//
//let registeredUser = RegisterUser(id: 1, name: "Yosuke Ishikawa")
//let id = registeredUser.id
//let message = registeredUser.message
//registeredUser.printProfile()


//RegisterUserクラスのスーパークラス
//class User{
//    let id: Int
//
//    var message: String{
//        return "Hello."
//    }
//
//    init(id: Int){
//        self.id = id
//    }
//
//    func printProfile(){
//        print("id: \(id)")
//        print("message: \(message)")
//    }
//}
//
////Userクラスを継承したクラス
//class RegisterUser: User{
//    let name: String
//
//    override var message: String{
//        return "Hello, my name is \(name)"
//    }
//    init(id: Int, name: String) {
//        self.name = name
//        super.init(id: id)
//    }
//
//    override func printProfile() {
//        super.printProfile()
//        print("name: \(name)")
//    }
//}
//
//let user = User(id: 1)
//user.printProfile()
//print("---")
//
//let registeredUser = RegisterUser(id: 2, name: "Yusei Nishiyama")
//registeredUser.printProfile()
//
////finalキーワード
//class SuperClass{
//    func overridableMethod(){
//    }
//    final func finalMethod()
//    }
//}
//class SubClass: SuperClass{
//    override func overridableMethod() {
//    }
//    //オーバーライド不可能なためエラー
//    override func finalMethod(){
//    }
//
//}
//class InheritableClass{}
//class ValidSubClass: InheritableClass{}
//final class FinalClass{}
//継承不可能なためエラー
//class InvalidClass: FinalClass{}

//クラスプロパティ　クラス自身に紐付くプロパティ
//class A{
//    class var className: String{
//        return "A"
//    }
//}
//class B: A{
//    override class var className: String{
//        return "B"
//    }
//}
//
//A.className
//B.className

//クラスメソッド　クラス自身に紐づくメソッド
//class A{
//    class func inheritanchHierarchy() -> String{
//        return "A"
//    }
//}
//class B: A{
//    override class func inheritanchHierarchy() -> String {
//        return super.inheritanchHierarchy() + "<-B"
//    }
//}
//
//class C : B{
//    override class func inheritanchHierarchy() -> String {
//        return super.inheritanchHierarchy() + "<-C"
//    }
//}
//A.inheritanchHierarchy()
//B.inheritanchHierarchy()
//C.inheritanchHierarchy()

//class A{
//    class var className: String{
//        return "A"
//    }
//    static var baseClassName: String{
//        return "A"
//    }
//}
//
//class B: A{
//    override class var className: String{
//        return "B"
//    }
    //スタティックプロパティはオーバーライド(再定義)できない
//    override static var baseClassName: String{
//        return "A"
//    }
//}
//
//A.className
//B.className
//
//A.baseClassName
//
//
//class Mail{
//    let from: String
//    let to: String
//    let title: String
//    //指定イニシャライザ
//    init(from: String, to: String, title: String){
//        self.from = from
//        self.to = to
//        self.title = title
//    }
//
//    //コンビニエンスイニシャライザ
//    convenience init(from: String, to: String) {
//        self.init(from: from, to: to, title: "Hello, \(from)")
//    }
//}
//
//class User{
//    let id: Int
//
//    init(id: Int){
//        self.id = id
//    }
//
//    func printProfile(){
//        print("id: \(id)")
//    }
//}
//
//class RegisteredUser: User{
//    let name: String
//
//    init(id: Int, name: String) {
//        //第一段階
//        self.name = name
//        super.init(id: id)
//        //第二段階
//        self.printProfile()
//    }
//}
//
//class User1{
//    let id = 0
//    let name = "Taro"
//
//    //以下と同等のイニシャライザが自動的に定義される
//    //デフォルトイニシャライザ
//    //init(){}
//}
//let user1 = User1()
//user1.id
//user1.name
//
//class User2{
//    let id: Int
//    let name: String
//    //id, nameの二つを初期化する方法がないためエラーになる
//}

//値の比較と参照先の比較について
class SomeClass: Equatable{
    static func == (lhs: SomeClass, rhs: SomeClass) -> Bool{
        return true
    }
}
let a = SomeClass()
let b = SomeClass()
let c = a
//定数aとbは同じ値なのでtrue
a == b
//定数aとbの参照先は異なるためfalseになる
a === b
//定数aとbの参照先はおなじなのでtrue
a === c

//列挙型
enum Weekday {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
//インスタンス化
let sunday = Weekday.sunday
let monday = Weekday.monday

enum Weekday1 {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(japaneseName: String){
        switch japaneseName{
        case "日": self = .sunday
        case "月": self = .monday
        case "火": self = .tuesday
        case "水": self = .wednesday
        case "木": self = .thursday
        case "金": self = .friday
        case "土": self = .saturday
        default: return nil
        }
    }
}

let sunday1 = Weekday1(japaneseName: "日")
let monday2 = Weekday1(japaneseName: "月")

enum Weekday2 {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    //ストアドプロパティは持てずコンピューテッドプロパティしか持てない
    var name: String{
        switch self{
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        }
    }
}

let weekday2 = Weekday2.monday
let name = weekday2.name


enum Symbol: Character{
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
}
let symbol = Symbol(rawValue: "#")
let character = symbol?.rawValue



class Person{
    var name: String
    init(name: String){
        self.name = name
    }
    deinit {
        print("[deinit]Bye, \(self.name)")
    }
}
func foo(){
    print("Entering foo()")
    let p = Person(name: "Ichiro")
    print("p.name = \(p.name)")
    print("Exit foo()")
}
foo()
