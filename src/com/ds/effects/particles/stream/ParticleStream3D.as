package com.ds.effects.particles.stream
{
    import com.ds.effects.EffectsAPI;
    import com.ds.effects.filtered.AbstractEffect;
    import com.ds.effects.filtered.EffectsManager;

    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class ParticleStream3D extends AbstractEffect
    {
        private var _sourceParent:Sprite;
        private var _particles:Vector.<Particle3D>;
        private var _inPoint:ParticlePoint;
        private var _outPoint:ParticlePoint;
        private var _middlePoint:ParticlePoint;
        private var _duration:Number = 3000;
        private var _durationVariance:Number = 0;
        private var _numParticles:uint = 10;
        private var _isValidEffect:Boolean;
        private var _allParticlesCreated:Boolean;
        private var _particleTimeCreation:Number = 0; // if it is 0 => all the particles are created at the very beginning, otherwise every particle is created after this interval of time
        private var _particleCreationID:uint;
        private var _particleLeft:int;
        private var _shadowLayer:Sprite;
        private var _graphSource:DisplayObject;
        private var _bitmapData:Texture;
        private var _particleStartingScale:Number = 1;

        public function ParticleStream3D(target : DisplayObject,parameters:String)
        {
            super(target, "ParticleStream3D");

            target.visible = false;

            var paramList : Array;
            if (target.parent)
            {
                _sourceParent = Sprite(target.parent);
                _shadowLayer = new Sprite();
                _sourceParent.addChildAt(_shadowLayer, 0);

                // init all the parameters
                preInit();
            }



            _graphSource = target;
            _particleStartingScale = target.scaleX;

            // create all the particles if we need them all togheter
            _bitmapData = Image(target).texture;
            paramList = EffectsAPI.removeWhiteSpace(parameters);
            if (paramList[0] != "")
                _numParticles = int(paramList[0]);
            if (paramList[1] != "")
                _duration = int(paramList[1]);
            if (paramList[2] != "")
                _durationVariance = int(paramList[2]);
            if (paramList[3] != "")
                _particleTimeCreation = Number(paramList[3]);

        }

        private function preInit():Boolean
        {
            var pointNeeded : Vector.<String> = new <String> ["inPoint", "outPoint", "middlePoint"];

            for (var i:int = 1; i < _sourceParent.numChildren; i++)
            {
                for (var o:int = 0; o < pointNeeded.length; o++)
                {
                    if (_sourceParent.getChildAt(i).name.substr(_sourceParent.getChildAt(i).name.length - pointNeeded[o].length, pointNeeded[o].length) == pointNeeded[o])
                    {
                        this["_" + pointNeeded[o]] = new ParticlePoint(_sourceParent.getChildAt(i));
                        pointNeeded.splice(o, 1);
                        break;
                    }
                }
                if (!pointNeeded.length)
                    break;
            }

            if (pointNeeded.length > 1)
            {
                trace("Missed important points in particlestream3d. something went terribly wrong in the particleStream3D");
                return false;
            }
            else if(pointNeeded.length == 1 && pointNeeded[0] != "middlePoint")
            {
                trace("Missed important points in particlestream3d (2). something went terribly wrong in the particleStream3D");
                return false;
            }
            return true;
        }

        override public function init() : void
        {
            preInit();

            _particles = new Vector.<Particle3D>;
            if(_particleTimeCreation == 0)
            {
                for(var i:int = 0; i < _numParticles; i++)
                {
                    _particles.push(new Particle3D(_bitmapData,_shadowLayer,_inPoint,_outPoint,_middlePoint,_duration + (Math.random()*_durationVariance),_particleStartingScale));
                    _sourceParent.addChildAt(_particles[i],0);
                }
                _allParticlesCreated = true;
            }
            else
            {
                _particleLeft = _numParticles;
                _allParticlesCreated = false;
                _particleCreationID = setInterval(createParticle,_particleTimeCreation);
            }

            _isValidEffect = true;

        }

        // generate the particle any given time (if the user doesn't want all the particle being generated all together)
        private function createParticle():void
        {
            _particles.push(new Particle3D(_bitmapData,_shadowLayer,_inPoint,_outPoint,_middlePoint,_duration + (Math.random()*_durationVariance),_particleStartingScale));
            _sourceParent.addChildAt(_particles[_particles.length-1],0);
            _particleLeft--;
            if(_particleLeft<=0)
            {
                _allParticlesCreated = true;
                clearInterval(_particleCreationID);
            }
        }

        override public function overrideAttribute(attribute : String, value : Number) : void
        {
            if (!hasAttribute(attribute))
            {
                changedSettings["_" + attribute] = this["_" + attribute];
            }
            this["_" +attribute] = value;
            trace("Overriding " +attribute +" = "+ this["_" +attribute]);
            //init();
        }

        override public function resetAttribute(attribute : String) : void
        {
            this["_" +attribute] = changedSettings["_" +attribute];
        }

        override public function resetAllAttributes() : void
        {
            for (var k:String in changedSettings)
            {
                var value:Number = changedSettings[k];
                var key:String = k;
                this[key] = value;
            }
        }

        override public function draw():void
        {
            var i:int;
            var particleSorted:Array;
            var currPos:int;

            if(!_isValidEffect)
                return;

            // stops the effect if the time pass the duration of the effect itself.
            if(!_particles.length && _allParticlesCreated)
            {
                // destroy the effect.
                trace(" the effect is over ");
                _isValidEffect = false;

                EffectsManager.getInstance().stopEffectForTarget(target.name);
                return;
            }

            for(i=0;i<_particles.length;i++)
            {
                if(_sourceParent.contains(_particles[i]))
                    _sourceParent.removeChild(_particles[i]);
                if(!_particles[i].nextPosition())
                {

                    _particles.splice(i,1);
                    i--;
                }
            }

            // bubble sort the position of the particles basing on their scale value
            particleSorted = new Array();
            for(i = 0;i<_particles.length;i++)
            {
                currPos = _particles[i].scaleX * 100;
                while(particleSorted[currPos]!=null)
                    currPos++;
                particleSorted[currPos] = _particles[i];

            }
            for(i=0;i<particleSorted.length;i++)
            {
                if(particleSorted[i])
                    _sourceParent.addChild(particleSorted[i]);
            }

        }

        override public function destroy() : void
        {
            if(_sourceParent.contains(_shadowLayer))
                _sourceParent.removeChild(_shadowLayer);

            _particles = null;
            super.destroy();

        }
    }
}
