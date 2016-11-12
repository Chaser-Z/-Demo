//
//  FoldIngView.swift
//  FoldingDemo
//
//  Created by 张海南 on 2016/11/3.
//  Copyright © 2016年 枫韵海. All rights reserved.
//

import UIKit

// 折叠方向枚举
enum FoldingDirection: Int {
    
    case vertical   // 竖直方向
    case horizontal // 水平方向
}



let IMAGE_PER_HEIGIT: CFloat = 50
let ScreenWidth: CGFloat = UIScreen.main.bounds.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.height

class FoldIngView: UIView {

    // 把图片分成的四个模块
    private var oneImageView: UIImageView!
    private var twoImageView: UIImageView!
    private var threeImageView: UIImageView!
    private var fourImageView: UIImageView!
    
    // 第一和第三图片上的阴影图
    private var oneShadowView: UIView!
    fileprivate var threeShadowView: UIView!
    
    // 倒计时器
    fileprivate var timer: Timer?
    
    // 记录手指移动的y或者X点
    var recordYorX: CGFloat = 0

    
    // 动画是否正在执行 default - 否
    var isFolding: Bool = false
    
    // 折叠方向枚举
    var foldingDirection: FoldingDirection!
    
    // 记录每块图片的宽度
    var itemWidth: CGFloat!
    
    
    
    init(frame: CGRect,foldingDirection: FoldingDirection) {
        
        
        super.init(frame: frame)

        self.foldingDirection = foldingDirection
        self.itemWidth = self.frame.size.width / 4
        self.configUI()
        self.addTap()
        
    }
    private func addTap() {
        
        let tap = UIPanGestureRecognizer(target: self, action: #selector(FoldIngView.panAnimate(_:)))
        
        self.addGestureRecognizer(tap)
        
        
    }
    func panAnimate(_ sender: UIPanGestureRecognizer) {
        
        // 获取手指偏移
        let point = sender.translation(in: self)
        
        if sender.state == .changed {
            
            if self.foldingDirection == FoldingDirection.vertical {
                self.foldingAnimate(y: point.y)
                self.recordYorX = point.y

            } else {
                self.recordYorX = point.x
                self.foldingAnimate(y: point.x)

            }

            
        } else if sender.state == .ended {
            
            // 方法1
            self.addTimer()
            // 方法2
            //self.resumeLayerTransform(y: point.y)
        }
        
        
    }
    // 添加时间计时器
    func addTimer() {
       
        if self.timer == nil {
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(FoldIngView.didChangeTime), userInfo: nil, repeats: true)

        }
    }
    func didChangeTime() {
        
        if self.foldingDirection == FoldingDirection.vertical {
            
            if self.recordYorX < -45 {
                
                self.recordYorX = -45
            }
            self.recordYorX = self.recordYorX + 1.0
            
            self.foldingAnimate(y: self.recordYorX)
            
            print("self.recordY = \(self.recordYorX)")
            
            if self.recordYorX >= 0 {
                
                self.removerTimer()
            }

        } else {
            
            if self.recordYorX > 45 {
                
                self.recordYorX = 45

            }
            self.recordYorX = self.recordYorX - 1.0
            self.foldingAnimate(y: self.recordYorX)

            if self.recordYorX <= 0 {
                
                self.removerTimer()

            }
            
        }
    }
    // 移除计时器
    func removerTimer() {
        
        if self.timer != nil {
            
            self.timer?.invalidate()
            self.timer = nil
            self.resumeLayerTransform(y: 0)
        }
        
    }

    // MARK: - 创建UI
    private func configUI() {
    
        
        
        self.oneImageView = UIImageView()
        self.oneImageView.image = UIImage(named: "Kiluya.jpg")
        
        self.twoImageView = UIImageView()
        self.twoImageView.image = UIImage(named: "Kiluya.jpg")

        self.threeImageView = UIImageView()
        self.threeImageView.image = UIImage(named: "Kiluya.jpg")

        self.fourImageView = UIImageView()
        self.fourImageView.image = UIImage(named: "Kiluya.jpg")

        
        
        
        if self.foldingDirection == FoldingDirection.vertical {
            // 竖直方向
            
            /**
             Layer(图层)的一个属性contentsRect,这个属性是可以控制图片显示的尺寸，可以让图片只显示上部分或者下部分，注意:取值范围是0~1.
             */
            self.oneImageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 0.25)
            // anchorPoint 锚点 需要明确锚点，因为默认都是绕着锚点旋转的
            self.oneImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            self.oneImageView.frame = CGRect(x: 0, y: 0, width: Int(self.frame.size.width), height: Int(IMAGE_PER_HEIGIT))

            self.twoImageView.layer.contentsRect = CGRect(x: 0, y: 0.25, width: 1, height: 0.25)
            self.twoImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            self.twoImageView.frame = CGRect(x: 0, y: Int(IMAGE_PER_HEIGIT), width: Int(self.frame.size.width), height: Int(IMAGE_PER_HEIGIT))

            
            self.threeImageView.layer.contentsRect = CGRect(x: 0, y: 0.5, width: 1, height: 0.25)
            self.threeImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            self.threeImageView.frame = CGRect(x: 0, y: Int(IMAGE_PER_HEIGIT) * 2, width: Int(self.frame.size.width), height: Int(IMAGE_PER_HEIGIT))

            self.fourImageView.layer.contentsRect = CGRect(x: 0, y: 0.75, width: 1, height: 0.25)
            self.fourImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            self.fourImageView.frame = CGRect(x: 0, y: Int(IMAGE_PER_HEIGIT) * 3, width: Int(self.frame.size.width), height: Int(IMAGE_PER_HEIGIT))
        } else { // 水平方向
            
            /**
             Layer(图层)的一个属性contentsRect,这个属性是可以控制图片显示的尺寸，可以让图片只显示上部分或者下部分，注意:取值范围是0~1.
             */
            self.oneImageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 0.25, height: 1)
            // anchorPoint 锚点 需要明确锚点，因为默认都是绕着锚点旋转的
            self.oneImageView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            self.oneImageView.frame = CGRect(x: 0, y: 0, width: Int(self.frame.size.width)/4, height: Int(self.frame.size.height))
            
            self.twoImageView.layer.contentsRect = CGRect(x: 0.25, y: 0, width: 0.25, height: 1)
            self.twoImageView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.twoImageView.frame = CGRect(x: Int(self.frame.size.width)/4, y: 0, width: Int(self.frame.size.width)/4, height: Int(self.frame.size.height))
            
            
            self.threeImageView.layer.contentsRect = CGRect(x: 0.5, y: 0, width: 0.25, height: 1)
            self.threeImageView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            self.threeImageView.frame = CGRect(x: Int(self.frame.size.width)/4 * 2, y: 0, width: Int(self.frame.size.width)/4, height: Int(self.frame.size.height))
            
            self.fourImageView.layer.contentsRect = CGRect(x: 0.75, y: 0, width: 0.25, height: 1)
            self.fourImageView.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.fourImageView.frame = CGRect(x: Int(self.frame.size.width)/4 * 3, y: 0, width: Int(self.frame.size.width)/4 , height: Int(self.frame.size.height))
            
            
        }
        
        

        self.addSubview(oneImageView)
        self.addSubview(twoImageView)
        self.addSubview(threeImageView)
        self.addSubview(fourImageView)
        
        
        // 给第一张和第三张添加阴影
        self.oneShadowView = UIView(frame: self.oneImageView.bounds)
        self.oneShadowView.backgroundColor = UIColor.black
        self.oneShadowView.alpha = 0
        
        self.threeShadowView = UIView(frame: self.threeImageView.bounds)
        self.threeShadowView.backgroundColor = UIColor.black
        self.threeShadowView.alpha = 0
        
        self.oneImageView.addSubview(self.oneShadowView)
        self.threeImageView.addSubview(self.threeShadowView)
    }
    
    // MARK: - 执行动画
    func foldingAnimate(y: CGFloat) {
        
        if self.foldingDirection == FoldingDirection.vertical {// 竖直折叠
            
            // 阴影显示
            if y >= 0 {
                
                self.oneShadowView.alpha = 0
                self.threeShadowView.alpha = 0
                
            } else {
                
                self.oneShadowView.alpha = 0.2
                self.threeShadowView.alpha = 0.2
                
            }
            
            if y < -45 || y > 0 {
                
                return
            }

        } else {
            
            // 阴影显示
            if y <= 0 {
                
                self.oneShadowView.alpha = 0
                self.threeShadowView.alpha = 0
                
            } else {
                
                self.oneShadowView.alpha = 0.2
                self.threeShadowView.alpha = 0.2
                
            }
            
            if  y > 45 || y < 0 {
                

                return

            }
        }
        //print("x == \(y)")

        
        if self.foldingDirection == FoldingDirection.vertical {// 竖直折叠
            
            // 折叠  -45或者45是旋转-45或者45度角
            self.oneImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: -y, y: 0)
            self.twoImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: y, y: -100 + 2 * self.oneImageView.frame.size.height)
            self.threeImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: -y, y: -100 + 2 * self.oneImageView.frame.size.height)
            self.fourImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: y, y: -200 + 4 * self.oneImageView.frame.size.height)
        } else { // 水平折叠
            
            // 折叠
            // 注： 以fourImageView的宽度为基准
            self.fourImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: -y, y: 0)
            self.oneImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: y, y: self.itemWidth * 4 - 4 * self.fourImageView.frame.size.width)
            self.twoImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: -y, y: self.itemWidth * 2 - 2 * self.fourImageView.frame.size.width)
            self.threeImageView.layer.transform = self.config3DTransformWithRotateAngle(angle: y, y: self.itemWidth * 2 - 2 * self.fourImageView.frame.size.width)


            
        }

        
    }
    // MARK: - 恢复原来样子
    func resumeLayerTransform(y: CGFloat) {
        
        self.isFolding = false
        
        // 阴影隐藏
        self.oneShadowView.alpha = 0.0
        self.threeShadowView.alpha = 0.0
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
        
            // 图片恢复原样
            self.oneImageView.layer.transform = CATransform3DIdentity
            self.twoImageView.layer.transform = CATransform3DIdentity
            self.threeImageView.layer.transform = CATransform3DIdentity
            self.fourImageView.layer.transform = CATransform3DIdentity

            }) { (finish) in
                
                
                
        }
        
        
    }
    
    
    // MARK: - 3D动画
    private func config3DTransformWithRotateAngle(angle: CGFloat,y: CGFloat) -> CATransform3D {
        
        // CATransform3DIdentity -  单位矩阵 该矩阵没有缩放，旋转，歪斜，透视。该矩阵应用到图层上，就是设置默认值。
        var transform: CATransform3D = CATransform3DIdentity
        
        // 立体  m34透视效果
        /**
         m11（x缩放）,m12（y切变）,m13（旋转）,m14（）;
         m21（x切变）,m22（y缩放）,m23（）, m24（）;
         m31（旋转） ,m32（ ）,m33（） , m34（透视效果，要操作的这个对象要有旋转的角度，否则没有效果。正直/负值都有意义）;
         m41（x平移）,m42（y平移）,m43（z平移）, m44（）;
         
         */
        transform.m34 = -1 / 1000.0
        
        // 旋转 (函数的叠加，效果的叠加  transform->透明效果 （CGFloat(M_PI) * angle / 180, 1, 0, 0）->产生旋转效果)
        /*
         CATransform3DRotate(<#T##t: CATransform3D##CATransform3D#>, <#T##angle: CGFloat##CGFloat#>, <#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##z: CGFloat##CGFloat#>)
         <#T##t: CATransform3D##CATransform3D#>-> 3d效果 <#T##angle: CGFloat##CGFloat#>-> 旋转角度
         <#T##x: CGFloat##CGFloat#>->向X轴方向旋转。值范围-1 --- 1之间
         <#T##y: CGFloat##CGFloat#>->向Y轴方向旋转。值范围-1 --- 1之间
         <#T##z: CGFloat##CGFloat#>->向Z轴方向旋转。值范围-1 --- 1之间
         */
        var rotateTransform: CATransform3D!
        var moveTransform: CATransform3D!
        if self.foldingDirection == FoldingDirection.vertical {// 竖直折叠
            
           rotateTransform = CATransform3DRotate(transform, CGFloat(M_PI) * angle / 180, 1, 0, 0)
            // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
            moveTransform = CATransform3DMakeAffineTransform(CGAffineTransform(translationX: 0, y: y))

            
        } else {
            
            rotateTransform = CATransform3DRotate(transform, CGFloat(M_PI) * angle / 180, 0, 1, 0)
            // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
            moveTransform = CATransform3DMakeAffineTransform(CGAffineTransform(translationX: y, y: 0))

        }
        
        //CATransform3DMakeAffineTransform(<#T##m: CGAffineTransform##CGAffineTransform#>)
        
        
        
        // 合并（既可以移动又可以旋转效果）
        let concatTransform: CATransform3D = CATransform3DConcat(rotateTransform, moveTransform)
        
        return concatTransform
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    

}
