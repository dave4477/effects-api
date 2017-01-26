package com.ds.effects.particles.stream
{
    import com.ds.effects.EffectsAPI;
    import com.ds.effects.filtered.AbstractEffect;
    import com.ds.effects.filtered.EffectsManager;

    import flash.utils.Dictionary;

    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;

    public class ParticleStream extends AbstractEffect
	{
		private var _texture:Texture;
		private var _sourceParent:Sprite;
		private var _particles:Vector.<Particle>;
		private var _inPoint:ParticlePoint;
		private var _outPoint:ParticlePoint;
		private var _middlePoint:ParticlePoint;
		private var _duration:Number = 3000;
		private var _durationVariance:Number = 0;
		private var _numParticles:uint = 10;
		private var _isValidEffect:Boolean;
		private var _allParticlesCreated:Boolean;
		private var _particleCreationInterval:Number = 0; // if it is 0 => all the particles are created at the very beginning, otherwise every particle is created after this interval of time
		private var _particleCreationID:uint;
		private var _particleLeft:int;
        private var _scaleVariance : Number = 0;
        private var _alphaVariance : Number = 0;
        private var _rotationVariance : Number = 0;

		public function ParticleStream(target : DisplayObject, parameters:String):void
        {
            super(target, "ParticleStream");

            _texture = Image(target).texture;

            target.visible = false;


			var i : int;
			var o : int;
			var paramList : Array;
			var pointNeeded : Vector.<String> = new <String> ["inPoint", "outPoint", "middlePoint"];

			// init all the parameters
			if (target.parent)
			{
				_sourceParent = Sprite(target.parent);

				for (i = 0; i < _sourceParent.numChildren; i++)
				{
					for (o = 0; o < pointNeeded.length; o++)
					{
						if (_sourceParent.getChildAt(i).name.substr(_sourceParent.getChildAt(i).name.length - pointNeeded[o].length, pointNeeded[o].length) == pointNeeded[o])
						{
							this["_" +pointNeeded[o]] = new ParticlePoint(_sourceParent.getChildAt(i));
							pointNeeded.splice(o,1);
							break;
						}
					}
					if (!pointNeeded.length)
						break;
				}
			}

			if (pointNeeded.length && pointNeeded[0] != "middlePoint")
			{
				trace("something went terribly wrong in the particleStream");
				return;
			}

            paramList = EffectsAPI.removeWhiteSpace(parameters);

			if (paramList[0] != "")
				_numParticles = int(paramList[0]);
			if (paramList[1] != "")
				_duration = int(paramList[1]);
			if (paramList[2] != "")
				_durationVariance = int(paramList[2]);
			if (paramList[3] != "")
				_particleCreationInterval = Number(paramList[3]);
            if (paramList[4] != "")
                _scaleVariance = Number(paramList[4]);
            if (paramList[5] != "")
                _alphaVariance = Number(paramList[5]);
            if (paramList[6] != "")
                _rotationVariance = Number(paramList[6]);
		}

        override public function init() : void
        {
            var i : int;

            _particles = new Vector.<Particle>();

            var particle : Particle;

            if (_particleCreationInterval == 0)
            {
                for (i = 0; i <_numParticles; i++)
                {
                    particle = new Particle(_texture, _inPoint, _outPoint, _middlePoint, _duration + (Math.random()*_durationVariance), Math.random() * _scaleVariance, Math.random() * _alphaVariance, Math.random() * _rotationVariance);
                    _particles.push(particle);
                    _sourceParent.addChildAt(_particles[i], 0);
                }
                _allParticlesCreated = true;
            }
            else
            {
                _particleLeft = _numParticles;
                _particleCreationID = setInterval(createParticle,_particleCreationInterval);
                createParticle();
            }

            _isValidEffect = true;
        }

        override public function stop():void
        {
            _isValidEffect = false;
            for (var i:int = 0; i < _particles.length; i++)
            {
                if (_sourceParent.contains(_particles[i]))
                {
                    _sourceParent.removeChild(_particles[i]);
                }
            }
        }

		// generate the particle any given time (if the user doesn't want all the particle being generated all toghether)
		private function createParticle() : void
		{
            var particle : Particle = new Particle(_texture,_inPoint,_outPoint,_middlePoint,_duration + (Math.random()*_durationVariance), Math.random() * _scaleVariance, Math.random() * _alphaVariance, Math.random() * _rotationVariance);
			_particles.push(particle);
			_sourceParent.addChildAt(_particles[_particles.length-1], 0);
			_particleLeft--;

			if (_particleLeft <= 0)
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

		override public function draw() : void
		{
            if (!_isValidEffect)
                return;

			// stops the effect if the time pass the duration of the effect itself.
			if (!_particles.length && _allParticlesCreated)
			{
				// destroy the effect.
                _isValidEffect = false;
                EffectsManager.getInstance().stopEffectForTarget(target.name);
				return;
			}
			
			for (var i : int = 0; i < _particles.length; i++)
			{
                if (!_particles[i].nextPosition())
				{
					_sourceParent.removeChild(_particles[i]);
                    _particles[i].dispose();
					_particles.splice(i,1);
					i--;
				}
			}
		}

        override public function destroy() : void
        {
            _particles = null;
            super.destroy();
        }
	}
}
