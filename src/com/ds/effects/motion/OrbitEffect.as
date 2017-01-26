/**
 * Created by fabrizio on 11/09/2015.
 */
package com.ds.effects.motion
{
    import com.ds.effects.filtered.AbstractEffect;
    import com.ds.effects.filtered.EffectsManager;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class OrbitEffect extends AbstractEffect
    {
        private var  _deltaScale:Number = 0.90;
        private var _rayX : Number;
        private var _rayY : Number;
        private var _speedX : Number;
        private var _speedY : Number;
        private var _startingScale : Number;
        private var _oldY:Number = 0;
        private var _centerX:Number;
        private var _centerY:Number;
        private var _bottomLayer:Sprite;
        private var _topLayer:Sprite;
        private var _numParticles : int;

        private var _currentDeltaScale : Number;
        private var _orbitY : Boolean;
        private var _texture : Texture;
        private var _particles : Vector.<Image>;
        private var _positions : Vector.<OrbitPosition>;
        private var _topLayerVec:Vector.<Image> = new Vector.<Image>();
        private var _bottomLayerVec:Vector.<Image> = new Vector.<Image>();

        public function OrbitEffect(target : Image, numParticles : int, rayX : Number, speedX : Number, rayY : Number, speedY : Number, layer : int, deltaScale : Number = 0.9, orbitY : Boolean = true)
        {
            _particles = new Vector.<Image>();
            _positions = new Vector.<OrbitPosition>();
            _deltaScale = deltaScale;

            if (_deltaScale > 0.99) _deltaScale = 0.99;

            _texture = target.texture;
            _numParticles = numParticles;

            _orbitY = orbitY;

            _startingScale = target.scaleX;
            _currentDeltaScale = (_startingScale * _deltaScale);

            var i : int;
            for (i = 0; i < _numParticles; i++)
            {
                _particles[i] = new Image(_texture);
                _particles[i].x = _centerX = target.x;
                _particles[i].y = _centerY = _oldY = target.y;
                _particles[i].scaleX = _particles[i].scaleY = _startingScale;
            }

            _rayX = rayX;
            _rayY = rayY;
            _speedX = speedX * 10;
            _speedY = speedY * 10;

            _bottomLayer = target.parent.getChildByName("bottomLayer" +layer) as Sprite;
            _topLayer = target.parent.getChildByName("topLayer" +layer) as Sprite;

            target.x = _bottomLayer.x;

            target.visible = false;
            target.alpha = 0;

            super(target, "Orbit");

            // set a random init position
            for (i = 0; i < _numParticles; i++)
            {
                _positions[i] = new OrbitPosition(Math.random() * 360, Math.random() * 360, 0);
            }

            for (i = 0; i < _numParticles; i++)
            {
                _particles[i].visible = true;
                _bottomLayer.addChild(_particles[i]);
            }
        }

        override public function stop():void
        {
            for (var i:int = 0; i < _particles.length; i++)
            {
                if (_particles[i].parent)
                {
                    _particles[i].parent.removeChild(_particles[i]);
                }
            }
        }

        override public function init():void
        {
            // set a random init position
            for (var i:int = 0; i < _numParticles; i++)
            {
                _bottomLayer.addChild(_particles[i]);
            }
        }

        override public function draw():void
        {
            var i : int;
            var ni : int;

            var sinX : Number;
            var sinY : Number;
            var cos  : Number;
            var deltaSin : Number;
            var currScale : Number;

            // set the horizontal and vertical position
            _topLayerVec = new Vector.<Image>();
            _bottomLayerVec = new Vector.<Image>();

            for (i = 0; i < _numParticles; i++)
            {
                _positions[i].currSinX += _speedX * EffectsManager.passedTime;
                _positions[i].currSinY += _speedY * EffectsManager.passedTime;

                // Wrap back to 0 degrees if we reach more than 359 degrees.
                // This prevents currSinX and currSinY from growing too large.
                _positions[i].currSinX %= 359;
                _positions[i].currSinY %= 359;

                sinX = Math.sin(_positions[i].currSinX * Math.PI / 180);

                sinY = Math.sin(_positions[i].currSinY * Math.PI / 180);

                cos = _orbitY ? Math.cos(_positions[i].currSinY * Math.PI / 180) : Math.cos(_positions[i].currSinX * Math.PI / 180);

                _particles[i].x = _centerX + (sinX * _rayX);
                _particles[i].y = _centerY + (sinY * _rayY);
                _particles[i].visible = true;

                // check the position and the z rotation of the diamond to determinate the scale of the diamond itself
                deltaSin = (_orbitY) ? _particles[i].y - _positions[i].oldY : _particles[i].x - _positions[i].oldY;
                currScale = _currentDeltaScale * cos;

                _particles[i].scaleX = _particles[i].scaleY = _startingScale + currScale;
                _positions[i].oldY = (_orbitY) ? _particles[i].y : _particles[i].x;

                // set the z buffer
                if (deltaSin <= 0)
                {
                    _bottomLayerVec[_bottomLayerVec.length] = _particles[i];
                }
                else if (deltaSin > 0)
                {
                    _topLayerVec[_topLayerVec.length] = _particles[i];
                }

                if (_particles[i].parent)
                {
                    _particles[i].parent.removeChild(_particles[i]);
                }
            }

            // bubble sort the position of the particles basing on their scale value
            var particleSorted : Array;
            var currPos : int;

            particleSorted = [];

            for (i = 0, ni = _bottomLayerVec.length; i < ni ; i++)
            {
                currPos = _bottomLayerVec[i].scaleX * 1000;
                while (particleSorted[currPos] != null)
                    currPos++;

                particleSorted[currPos] = _bottomLayerVec[i];
            }

            for (i = 0, ni = particleSorted.length; i < ni; i++)
            {
                if(particleSorted[i])
                    _bottomLayer.addChild(particleSorted[i]);
            }

            particleSorted = [];

            for (i = 0, ni = _topLayerVec.length; i < ni; i++)
            {
                currPos = _topLayerVec[i].scaleX * 1000;
                while (particleSorted[currPos] != null)
                    currPos++;

                particleSorted[currPos] = _topLayerVec[i];
            }

            for (i = 0, ni = particleSorted.length; i < ni; i++)
            {
                if(particleSorted[i])
                {
                    _topLayer.addChild(particleSorted[i]);
                }
            }
        }

        override public function destroy():void
        {
            _topLayerVec = null;
            _bottomLayerVec = null;
            _particles = null;
            _positions = null;
            _texture.dispose();
            _texture = null;

            _topLayer.removeChildren(0, -1, true);
            _bottomLayer.removeChildren(0, -1, true);

            super.destroy();
        }
    }
}

internal class OrbitPosition {
    public var currSinX : Number;
    public var currSinY : Number;
    public var oldY : Number;

    public function OrbitPosition(sinX : Number, sinY : Number, oldY : Number) : void {
        currSinX = sinX;
        currSinY = sinY;
        this.oldY = oldY;
    }
}
