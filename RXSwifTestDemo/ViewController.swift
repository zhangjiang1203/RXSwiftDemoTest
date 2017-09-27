//
//  ViewController.swift
//  RXSwifTestDemo
//
//  Created by DFHZ on 2017/9/4.
//  Copyright © 2017年 DFHZ. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UITableViewController {

    let disposeBag = DisposeBag()
    struct Player {
        var score:Variable<Int>
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mergeTest()
    }
    
    func replayTest()  {
        let testReplay = Observable.just("haha").map{print($0)}.shareReplay(4)
        //map中的代码只执行一遍
        //添加上shareReplay(1)只执行一次 1可以替换成其他的数字
        testReplay.subscribe { (event) in
            print(event)
        }.addDisposableTo(DisposeBag())
        
        testReplay.subscribe { (event) in
            print(event)
        }.addDisposableTo(DisposeBag())
        
    }
    
    func listenToView() {
        let subscription = Observable<Int>.interval(0.3, scheduler: SerialDispatchQueueScheduler.init(internalSerialQueueName: "test"))
        .observeOn(MainScheduler.init())
        .subscribe { (event) in
            print(event)
        }
        
        
        Thread.sleep(forTimeInterval: 2.0)
        subscription.dispose()//手动释放
    }
    
    func flatMapTest() {
        //MARK:将一个sequence转换为一个sequence，当你接收一个sequence的事件，你还想接收其他的sequence发出的事件的话可以使用flatMap，他会将每一个sequence事件进行处理以后，然后再以一个新的sequence形式发出事件，
        //切换之后，把之前的sequence也会执行一遍
        //flatMapLatest 只会接收最新的value事件
        let xiaohong = Player.init(score: Variable(80))
        let xiaoming = Player.init(score: Variable(90))
        let lisi = Player.init(score: Variable(100))
        
        let player = Variable(xiaohong)
        player.asObservable()
              .flatMap { $0.score.asObservable()}
              .subscribe(onNext: {print($0) })
              .addDisposableTo(disposeBag)
        //监控player的变化
        xiaohong.score.value = 60
        
        //更换value 相当于
        player.value = xiaoming
        xiaohong.score.value = 95
        xiaohong.score.value = 220
        player.value = lisi
        xiaoming.score.value = 180
    }
    
    func mapTest()  {
        //map通过传入一个函数闭包把原来的sequence转变为一个新的sequence的操作
        //每一个元素自己相乘
        Observable
            .of(1,2,3,4)
            .map{$0 * $0}
            .subscribe(onNext: {print($0)})
            .addDisposableTo(disposeBag)
    }
    
    
    func switchLatestTest() {
        //MARK:switchLatestTest可以对事件流进行转换，本来监听的subject1 可以通过更改variable里面的value更换事件源，变成监听subject2了
        let subject1 = BehaviorSubject(value:"1")
        let subject2 = BehaviorSubject(value: "A")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext: {print($0)})
            .addDisposableTo(disposeBag)
        
        subject1.onNext("2")
        subject1.onNext("3")
        
        variable.value = subject2
        
        subject1.onNext("4")
        subject2.onNext("B")
        
        variable.value = subject1
        subject2.onNext("hello world")
        
        subject1.onNext("123")
    }
    
    //Sequence 把一系列元素转换为事件序列
    func rxTest1()  {
        let sequenceOfElements = Observable.of(1,2,3,4)
        _ = sequenceOfElements.subscribe { (event) in
            print(event)
        }
    }
    
    func rxTest2() {
        let disposeBag = DisposeBag()
        //MARK:never创建一个sequence 不发出任何事件信号
        Observable<String>.never().subscribe { (event) in
            print("never===%@",event)
        }.addDisposableTo(disposeBag)
        
        //MARK:empty创建一个空的sequence 只能发出一个complete事件
        Observable<Int>.empty().subscribe { event in
            print("empty===%@",event)
        }.addDisposableTo(disposeBag)
        
        //MARK:just创建一个只能发出一种特定事件的sequence 能正常结束
        Observable.just("hahah").subscribe { (event) in
            print("just===%@",event)
        }.addDisposableTo(disposeBag)
        
        //MARK:of创建一个sequence能发出很多种事件信号
        Observable.of("heheh","hahah","heihei","enen").subscribe(onNext: { string in
            print("of===%@",string)
        }).addDisposableTo(disposeBag)
        
        //MARK:和上面的差别就是少了onNext:
        Observable.of("heheh","hahah","heihei","enen").subscribe({string in
            print("of===%@",string)
        }).addDisposableTo(disposeBag)
        
        //MARK:from从集合中创建sequence 例如数组、字典或者set
        Observable.from(["heheh","hahah","heihei","enen"]).subscribe(onNext: {
            print("from===\($0)")
        }).addDisposableTo(disposeBag);
        
        //MARK:create操作符传入一个观察者obsever 调用observer的onNext，onComplete和onError方法 ，返回一个可观察的obserable序列
        let myJust = {(element:String)->Observable<String> in
            return Observable.create({ observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            })
        }
        myJust("ni hao zhong guo")
            .subscribe{print($0)}
            .addDisposableTo(disposeBag)
        
        //MARK:range 创建一个sequence 它会发出这个范围中的从开始到结束的所有事件,
        Observable.range(start: 1, count: 10)
            .subscribe{print($0)}
            .addDisposableTo(disposeBag)
        
        //MARK:repeatElement 创建一个sequence 发出特定的事件n次
        Observable.repeatElement("repeat")
            .take(3)//取前三次
            .subscribe{print($0)}
            .addDisposableTo(disposeBag)
        
        //MARK:generate是创建一个可观察sequence 当初始化的条件为true的时候 他就会发出所对应的事件
        Observable.generate(
            initialState: 0,//初始值
            condition: { $0 < 3},//继续循环的条件
            iterate: {$0 + 1}//执行的动作
        )
        .subscribe(onNext: {print($0)})
        .addDisposableTo(disposeBag)
        
        //MARK:deferred 会为每一个订阅者observer创建一个新的可观察序列
        var count = 1
        let deferredSequence = Observable<String>.deferred {
            print("creating \(count)")
            count += 1
            return Observable.create({ (observer) -> Disposable in
                print("Emitting……")
                observer.onNext("小鸡")
                observer.onNext("小狗")
                observer.onNext("猴子")
                return Disposables.create()
            })
        }
        
        deferredSequence
            .subscribe(onNext: {print($0)})
            .addDisposableTo(disposeBag)
        
        deferredSequence
            .subscribe(onNext:{print($0)})
            .addDisposableTo(disposeBag)
        
        //MARK:创建一个可观察序列 但不发出任何正常的事件，只发出error事件并结束
//         Observable<Int>.error()
//            .subscribe{print($0)}
//            .addDisposeableTo(disposeBag)
        //MARK:doOn 个人感觉就是在直接onNext处理时候，先执行某个方法，doNext(:)方法就是在subscribe(onNext:)前调用 doOnCompleted(:)就是在subscribe(onCompleted:)前面调用
        Observable.of("你","好","中","国").do(onNext: {print("Intercepter:",$0)}, onError: {print("Intercepted error:",$0)}, onCompleted: {print("Completed")})
        .subscribe(onNext: {print($0)},  onCompleted: {print("结束")})
        .addDisposableTo(disposeBag)
        
        //MARK: subject是observable和Observer之间的桥梁，一个subject既是一个observable也是一个observer，他既可以发出事件，也可以监听事件
        //订阅PublicSubject的时候，只能接收到订阅他之后发生的事件。subject.onNext()发出onNext事件,对应的还有onError()和onComplete()事件
        let subject = PublishSubject<String>()
        
        subject.onNext("")
        subject.onNext("")
        
        //MARK:订阅ReplaySubject的时候，可以接收到订阅他之后的事件，也可以接收到订阅之前发出的事件，接收几个事件取决于bufferSize的大小
        let subject2 = ReplaySubject<String>.create(bufferSize: 1)
        subject2.onNext("")
        subject2.onNext("")
        
        //MARK:Variable是BehaSubject一个包装箱，使用的时候需要调用asObserver()拆箱,里面的value是一个BehaviorSubject，他不会发出error事件，但是会自动发出completed事件
        let variable = Variable("1")
        variable.value = "1"
        variable.value = "2"
    }
    
    func mergeTest() {
        //MARK:merge 合并两个Observable流合成单个Observable流，根据时间轴发出对应的事件
        let subjectA = PublishSubject<String>()
        let subjectB = PublishSubject<String>()
        Observable.of(subjectA,subjectB)
            .merge()
            .subscribe(onNext: {print($0)})
            .addDisposableTo(disposeBag)
        subjectA.onNext("A1")
        subjectA.onNext("A2")
        
        subjectB.onNext("B1")
        subjectB.onNext("B2")
        
        subjectA.onNext("A3")
        subjectB.onNext("B3")
    }
    
    
    func zipTest() {
        //MARK: 绑定最多不超过8个的Observable流，结合在一起。Zip是一个事件对应另一个流事件
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.zip(stringSubject,intSubject){
            stringElement,intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: {print($0)})
            .addDisposableTo(disposeBag)
        
        stringSubject.onNext("A")
        stringSubject.onNext("B")
        
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        stringSubject.onNext("AB")
        intSubject.onNext(3)
        //输出结果
        // A 1
        // B 2
        // AB 3
        //将stringSubject和intSubject压缩到一起共同处理
    }
    
    func startWithTest() {
        //联合操作就是把多个Observable流合成单个Observable流
        //MARK:startWith
        //在发出事件消息之前，先发出某个特定的事件消息，比如发出事件2、3，然后在startwith(1),那木就会先发出1，然后是2、3，
        Observable.of("2,3")
            .startWith("1")
            .subscribe(onNext:{ print($0)})
            .addDisposableTo(disposeBag)
    }
    
    func combineLatestTest() {
        //MARK: combineLatest绑定最多不超过8个的Observable流，结合在一起处理。和zip不同的是combineLatest是一个流的事件对应另一个流的最新的事件，两个事件都会是最新的事件
        
        let stringSubject = PublishSubject<String>()
        let intSubject = PublishSubject<Int>()
        
        Observable.combineLatest(stringSubject,intSubject){ stringElement,intElement in
            "\(stringElement)+ \(intElement)"
            }
            .subscribe(onNext: {print($0)})
            .addDisposableTo(disposeBag)
        
        stringSubject.onNext("A")
        stringSubject.onNext("B")
        
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        stringSubject.onNext("AB")
    }
    
    
}
