package com.ds.effects.particles.stream
{
    import flash.geom.Point;
    import flash.utils.getTimer;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class Particle3D extends Image
    {
        private const GRAVITY:Number = -0.3;
        private const SHADOW_ALPHA:Number = 0.5;

        private var _startPoint:Point;
        private var _middlePoint:Point;
        private var _endPoint:Point;
        private var _lifeInMilliseconds:int;
        private var _startingTime:int; // stores the moment in time when the particle started
        private var _shadow:Image;
        private var _currVel:Number = 0.5;
        private var _lastDeltaTime:Number;
        private var _shadowLayer:Sprite;
        private var _startingScale:Number;

        public function Particle3D(visual:Texture, shadowLayer:Sprite,startPoint:ParticlePoint, endPoint:ParticlePoint, middlePoint:ParticlePoint, lifeInMilliseconds:int, startingScale:Number)
        {
            super(visual);
            this.touchable = false;

            // init the variables
            _shadowLayer = shadowLayer;
            _startingScale = startingScale;
            _lifeInMilliseconds = lifeInMilliseconds;
            _startPoint = startPoint.createRandomPoint();
            _endPoint = endPoint.createRandomPoint();
            if(middlePoint)
                _middlePoint = middlePoint.createFixedPoint();

            // creating the texture for the shadow
            _shadow = new Image(visual);
            _shadow.color = 0x000000;
            _shadow.alpha = SHADOW_ALPHA;
            _shadow.touchable = false;
            shadowLayer.addChild(_shadow);

            _shadow.x = _startPoint.x;
            _shadow.y = _startPoint.y;
            this.x = _startPoint.x;
            this.y = _startPoint.y;
            _shadow.scaleX = _shadow.scaleY = _startingScale;
            this.scaleX = this.scaleY = _startingScale;
            _startingTime = _lastDeltaTime = getTimer();
            _currVel = -(GRAVITY*(_lifeInMilliseconds/1000)/2);
        }

        public function nextPosition():Boolean
        {
            var xPosition:Number;
            var yPosition:Number;
            var time:Number;
            var deltaTime:Number;
            var currTime:Number;

            // stop and remove the particle if it's life is over
            time = getTimer() - _startingTime;
            if(time > _lifeInMilliseconds)
            {
                _shadowLayer.removeChild(_shadow);
                return false;
            }

            // otherwise calculate the new position
            currTime = getTimer();
            deltaTime = currTime - _lastDeltaTime;
            deltaTime /= 1000;
            _lastDeltaTime = currTime;
            time = time / _lifeInMilliseconds;

            // main object position on the plane
            xPosition = _startPoint.x + ((_endPoint.x - _startPoint.x) * time);
            yPosition = _startPoint.y + ((_endPoint.y - _startPoint.y) * time);
            this.x = xPosition;
            this.y = yPosition;

            _currVel += (GRAVITY * deltaTime);

            // scale
            _shadow.scaleX = _shadow.scaleY = _shadow.scaleX + (_currVel /2);
            this.scaleX = this.scaleY = this.scaleX + _currVel;

            // shadow position on the plane
            if (_middlePoint)
            {
                xPosition = this.x + ((_middlePoint.x - _startPoint.x) * ((this.scaleX - _startingScale) * 0.1));
                yPosition = this.y + ((_middlePoint.y - _startPoint.y) * ((this.scaleX - _startingScale) * 0.1));
            }
            _shadow.x = xPosition;
            _shadow.y = yPosition;

            return true;
        }
    }
}
