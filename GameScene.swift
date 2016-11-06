import SpriteKit
import GameplayKit

class GameScene: SKScene{
    
    
    let player = SKSpriteNode(imageNamed: "plane")
    let enemy = SKSpriteNode(imageNamed: "e_plane" )
    
    
    
    
    override func didMove(to view: SKView) {
        addBackground()
        addPlayer()
        addEnemy()
    }
    
    
    
    
    func addBackground(){
        
        
        let background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        self.addChild(background)
    }
    
    
    func addPlayer(){
        player.position = CGPoint(x: self.size.width / 2, y: player.size.height / 2)
        let shootAction = SKAction.run(addBullet)
        let shootAtionWithDelay = SKAction.sequence([shootAction, SKAction.wait(forDuration: 0.2)])
        let shootActionForever = SKAction.repeatForever(shootAtionWithDelay)
        player.run(shootActionForever)
        
        self.addChild(player)
    }
    
    func addBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + (player.size.height / 2 + bullet.size.height / 2))
        
        let moveToRoof = SKAction.moveTo(y: self.size.height, duration: 0.5)
        let moveThenDisappear = SKAction.sequence([moveToRoof, SKAction.removeFromParent()])
        
        bullet.run(moveThenDisappear)
        self.addChild(bullet)
    }

    func randomInRange(lo: Int, hi: Int) -> Int{
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    func addEnemy(){
        
        
        let randomX = randomInRange(lo: 0, hi: (Int(self.size.width)))
        
        enemy.position = CGPoint(x: randomX, y: Int(self.size.height - enemy.size.height/2))
        let enemyShootAction = SKAction.run(addBulletOfEnemy)
        let enemyShootActionWithDelay = SKAction.sequence([enemyShootAction, SKAction.wait(forDuration: 1)])
        let enemyShootForever = SKAction.repeatForever(enemyShootActionWithDelay)
        enemy.run(enemyShootForever)
        
        
        let enemyMove = SKAction.moveTo(y: 0, duration: 15)
        let enemyMoveThenDisappear = SKAction.sequence([enemyMove, SKAction.removeFromParent()])
        enemy.run(enemyMoveThenDisappear)
        
        self.addChild(enemy)
        
    }
    
    func addBulletOfEnemy(){
        let ebullet = SKSpriteNode(imageNamed: "e_bullet")
        ebullet.position = CGPoint(x: enemy.position.x, y: enemy.position.y - (ebullet.size.height / 2 + enemy.size.height / 2))
        let bulletEnemyMoveToLand = SKAction.moveTo(y: 0, duration: 5)
        let bulletEnemyMoveThenDisappear = SKAction.sequence([bulletEnemyMoveToLand, SKAction.removeFromParent()])
        
        ebullet.run(bulletEnemyMoveThenDisappear)
        
       
        self.addChild(ebullet)
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var location = touch.location(in: self )
            let previousLocation = touch.previousLocation(in: self)
            
            if player.position.x > self.size.width {
                player.position.x = self.size.width
            }
            if player.position.x < 0 {
                player.position.x = 0
            }
            if player.position.y > self.size.height {
                player.position.y = self.size.height
            }
            if player.position.y < 0 {
                player.position.y = 0
            }

            
            let vector = CGVector(dx: location.x - previousLocation.x, dy: location.y - previousLocation.y)
            
            let move = SKAction.move(by: vector, duration: 0.1)
            
                        player.run(move)
        }
    }
}
