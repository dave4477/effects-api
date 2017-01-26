/**
 * Created by Dave on 11/02/2016.
 */
package com.ds.effects.particles.coinshower
{
    import com.ds.effects.filtered.AbstractEffect;

    import starling.animation.IAnimatable;

    import starling.core.Starling;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;

    public class CoinShower extends AbstractEffect
    {
        private var _velX : Number;
        private var _velY : Number;

        private var _particleScene:ParticleScene;
        private var _particleClip:ParticleClip;
        private var _numParticles : uint = 0;
        private var _target : DisplayObject;
        private var _texture : Texture;
        private var _posX : Number;
        private var _posY : Number;
        private var _velocityX : Number;
        private var _velocityY : Number;
        private var _velocityXVariance : Number;
        private var _velocityYVariance : Number;
        private var _gravity : int;
        private var _lifeTime : int;
        private var _scale : Number;
        private var _rotation : int;
        private var _blendMode : String;
        private var _blendModes : Vector.<String> = new <String>["add", "alpha", "darken", "difference", "erase", "hardlight", "invert", "layer", "lighten", "multiply", "normal", "overlay", "screen", "shader", "subtract"];
        private var _duration : Number;
        private var _durationTimer:IAnimatable;
        private var _isExpired:Boolean;

        public function CoinShower(target:DisplayObject, posX:Number, posY:Number, velX:Number, velY:Number, velXVariance:Number, velYVariance:Number, gravity:int, lifeTime:uint, scale:Number, rotation:int, blendMode:int, duration:Number)
        {
            _target = target;
            _posX = posX;
            _posY = posY;
            _velocityX = velX;
            _velocityY = velY;
            _velocityXVariance = velXVariance;
            _velocityYVariance = velYVariance;
            _gravity = gravity;
            _lifeTime = lifeTime;
            _scale = scale;
            _rotation = rotation;
            _blendMode = _blendModes[blendMode];
            _duration = duration;
            _texture = Image(target).texture;

            super(target, "CoinShower");

        }

        override public function init():void
        {
            if (!_particleScene)
            {
                _particleScene = new ParticleScene();
                target.parent.addChild(_particleScene);
            }
            _isExpired = false;
            _numParticles = 0;
        }

        override public function stop():void
        {
            Starling.juggler.removeTweens(_durationTimer);
            if (target && target.parent && _particleScene)
            {
                target.parent.removeChild(_particleScene);
            }
        }

        override public function draw():void
        {
            if (_duration == 0)
            {
                while (_numParticles < 25)
                {
                    updateParticles();
                }
            }
            else if (_duration == -1)
            {
                updateParticles();
            }
            else if (_duration > 0)
            {
                if (!_durationTimer)
                {
                    _durationTimer = Starling.juggler.delayCall(expire, _duration / 1000);
                }
                updateParticles();
            }
            _particleScene.update();

        }

        private function updateParticles():void
        {
            if (_isExpired) return;

            var image : Image = new Image(_texture);

            _particleClip = new ParticleClip();
            _particleClip.addChild(image);

            _velX = Math.random() * _velocityX + _velocityXVariance;
            _velY = Math.random() * _velocityY + _velocityYVariance;
            _rotation *= Math.random();

            _particleScene.addParticle(_particleClip, _posX, _posY, _velX, _velY, _gravity, _lifeTime, _scale, _rotation, _blendMode);
            _numParticles++;
        }

        private function expire():void
        {
            _isExpired = true;
        }

        override public function destroy() : void
        {
            if (target && target.parent && _particleScene)
            {
                target.parent.removeChild(_particleScene);
                _particleScene = null;
            }
            if (_texture) _texture.dispose();
            if (_target) _target.dispose();
            if (_particleClip) _particleClip.dispose();

            super.destroy();
        }
    }
}
