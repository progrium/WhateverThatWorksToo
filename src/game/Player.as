package game {
    import org.flixel.*;
    
    public class Player extends FlxSprite {
        [Embed (source = "../../data/sprites/players.png")] private var player_spritesheet:Class;
        
        public const MOVE_SPEED:Number = 100;
        public const RUN_ACCEL:Number = 700;
        public const RUN_DRAG:Number = 300;
        public const GRAVITY:Number = 1200;
        public const JUMP_FORCE:Number = 2400;
        public const JUMP_HOLD_FORCE:Number = 150;
        
        public var player_idx:Number; 
        
        public var controls:Object = {
            1:{left:'LEFT', right:'RIGHT', up:'UP'},
            2:{left:'A', right:'D', up:'W'}
        };
        
        public function Player(X:Number=0, Y:Number=0, P:Number=1) {
            super(X, Y);
            loadGraphic( 
                player_spritesheet, 
                true, true,
                16, 16
            );
            
            player_idx = P;
            
            switch(P) {
                case 1: P=0; break;
                case 2: P=2; break;
                case 3: P=4; break;
                case 4: P=6; break;
            }
                        
            var f1:Number = (P);
            var f2:Number = (P+1);
            
            addAnimation("idle", [f1, f2], 2);
            addAnimation("run", [f1, f2], 6);
            addAnimation("jump", [f2]);
            
            maxVelocity.y = 300;
            acceleration.y = GRAVITY;
        }
        
        public function do_input(p:Number): void {
                        
            if( FlxG.keys.pressed(controls[p].left) ) {
                acceleration.x = -RUN_ACCEL;
                drag.x = 0;
            } else if ( FlxG.keys.pressed(controls[p].right) ) {
                acceleration.x = RUN_ACCEL;
                drag.x = 0;
            } else {
                acceleration.x = 0;
                drag.x = RUN_DRAG;
            }
            
            // If you're moving too quickly, stop accelerating
            if (velocity.x <= - MOVE_SPEED) {
                acceleration.x = Math.max(0, acceleration.x);
            } else if (velocity.x >= MOVE_SPEED) {
                acceleration.x = Math.min(0, acceleration.x);
            }
            
            // Jump
            if( FlxG.keys.justPressed(controls[p].up) && onFloor ) {
                velocity.y = - JUMP_FORCE;
            }
            
            // If you hold jump in the air, keep pushing him up a bit to have mario-style jumping
            if( FlxG.keys.pressed(controls[p].up) && velocity.y < 0 ) {
                velocity.y -= JUMP_HOLD_FORCE * FlxG.elapsed;
            }
        }
        
        public function do_animation(p:Number): void {
            if( FlxG.keys.pressed(controls[p].left) ) {
                facing = LEFT;
            } else if( FlxG.keys.pressed(controls[p].right) ) {
                facing = RIGHT;
            }
            
            if (onFloor) {
                
                if( FlxG.keys.pressed(controls[p].left) || FlxG.keys.pressed(controls[p].right) ) {
                    play("run");
                } else {
                    play("idle");
                }
                
            } else {
                play("jump");
            }
        }
        
        override public function update(): void {
            do_input(player_idx);
            do_animation(player_idx);
            super.update();
        }
    }
}