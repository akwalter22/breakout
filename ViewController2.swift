//
//  ViewController2.swift
//  Games
//
//  Created by period6 on 4/27/21.
//

import UIKit

class ViewController2: UIViewController, UICollisionBehaviorDelegate {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var panelView: UIView!
    
    @IBOutlet weak var brickOne: UIView!
    @IBOutlet weak var brickTwo: UIView!
    @IBOutlet weak var brickThree: UIView!
    @IBOutlet weak var brickFour: UIView!
    
    @IBOutlet weak var restartButton: UIButton!
    var bricks = [UIView]()
    
    var dynamicAnimater: UIDynamicAnimator!
    var pushBehavior: UIPushBehavior!
    var collisionBehaviour: UICollisionBehavior!
    var ballDynamicBehavior: UIDynamicItemBehavior!
    var panelDynamicBehavior: UIDynamicItemBehavior!
    var bricksDynamicBehavior: UIDynamicItemBehavior!
    var brickCount = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleView.bounds.width/2
       dynamicBehaviors()
        collisionBehaviour.collisionDelegate = self
        panelView.isHidden = true
        circleView.isHidden = true
        
        bricks = [brickOne, brickTwo, brickThree, brickFour]
        
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        panelView.center = CGPoint(x: sender.location(in: view).x, y: panelView.center.y)
        dynamicAnimater.updateItem(usingCurrentState: panelView)
    }
    
    func dynamicBehaviors(){
        dynamicAnimater = UIDynamicAnimator(referenceView: view)
        
        pushBehavior = UIPushBehavior(items: [circleView], mode: .instantaneous)
        pushBehavior.active = true
        pushBehavior.pushDirection = CGVector(dx: 0.7, dy: 0.6)
        pushBehavior.magnitude = 0.3
        dynamicAnimater.addBehavior(pushBehavior)
        
        collisionBehaviour = UICollisionBehavior(items: [circleView, panelView] + bricks)
        collisionBehaviour.collisionMode = .everything
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        dynamicAnimater.addBehavior(collisionBehaviour)
        collisionBehaviour.collisionDelegate = self
        
        ballDynamicBehavior = UIDynamicItemBehavior(items: [circleView])
        ballDynamicBehavior.allowsRotation = true
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.friction = 0
        ballDynamicBehavior.resistance = 0
        dynamicAnimater.addBehavior(ballDynamicBehavior)

        panelDynamicBehavior = UIDynamicItemBehavior(items: [panelView])
        panelDynamicBehavior.allowsRotation = false
        panelDynamicBehavior.density = 1000.0
        dynamicAnimater.addBehavior(panelDynamicBehavior)
        
        bricksDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        bricksDynamicBehavior.density = 1000.0
        bricksDynamicBehavior.allowsRotation = false
        dynamicAnimater.addBehavior(bricksDynamicBehavior)
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        dynamicBehaviors()
        panelView.isHidden = false
        circleView.isHidden = false
        sender.isHidden = true
        
        }
    
    func alert(){
        let alert = UIAlertController(title: "You Win!", message: "Game Over", preferredStyle: .alert)
        let newGame = UIAlertAction(title: "New Game", style: .default) { (action) in
            self.brickCount = 4
            self.restartButton.isHidden = false
        }
        alert.addAction(newGame)
        present(alert, animated: true, completion: nil)
    }
    
    func alert2(){
        let alert = UIAlertController(title: "You Lost", message: "Game Over", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if p.y > panelView.center.y {
            alert2()
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        for wes in bricks {
            if item1.isEqual(circleView) && item2.isEqual(wes) {
                wes.isHidden = true
                collisionBehaviour.removeItem(wes)
                brickCount -= 1
                print (brickCount)
            }
            
            
                if brickCount == 0 {
                    alert()
                    self.circleView.isHidden = true
                    self.panelView.isHidden = true
                    collisionBehaviour.removeItem(circleView)
            }
        }
    }
    


}
