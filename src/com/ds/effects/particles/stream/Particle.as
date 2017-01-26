package com.ds.effects.particles.stream
{
    import flash.geom.Point;
    import flash.utils.getTimer;

    import starling.display.Image;
    import starling.textures.Texture;

    public class Particle extends Image
	{
		private var _startPoint:Point;
		private var _middlePoint:Point;
        private var _endPoint:Point;
        private var _lifeInMilliseconds:int;
		private var _startingTime:int; // stores the moment in time when the particle started
		
        public function Particle(texture : Texture, startPoint : ParticlePoint, endPoint : ParticlePoint, middlePoint : ParticlePoint, lifeInMilliseconds :int, scaleVariance : Number, alphaVariance : Number, rotationVariance : Number)
        {
            super(texture);

			// init the variables
			// creating a new texture

			_lifeInMilliseconds = lifeInMilliseconds;
            _startPoint = startPoint.createRandomPoint();
            _endPoint = endPoint.createRandomPoint();
			if(middlePoint)
				_middlePoint = middlePoint.createRandomPoint();

            this.x = _startPoint.x;
            this.y = _startPoint.y;
            this.scaleX = this.scaleY = 1 + scaleVariance;
            this.alpha -= alphaVariance;
            this.rotation += rotationVariance;
			_startingTime = getTimer();
        }

        public function nextPosition():Boolean
        {
			var xPosition:Number;
			var yPosition:Number;
            var squaredTimeLeft:Number;
            var timeLeftByTime:Number;
            var timeSquared:Number;
			var time:Number;
			
			// stop and remove the particle if it's life is over
			time = getTimer() - _startingTime;
			if(time > _lifeInMilliseconds)
				return false;
						
			// otherwise calculate the new position
			time = time / _lifeInMilliseconds;
			if(_middlePoint)
			{
				squaredTimeLeft = (1 - time) * (1 - time);
				timeLeftByTime = (1 - time) * time;
				timeSquared = (time * time);
				xPosition = squaredTimeLeft * _startPoint.x + 2 * timeLeftByTime * _middlePoint.x + timeSquared * _endPoint.x;
				yPosition = squaredTimeLeft * _startPoint.y + 2 * timeLeftByTime * _middlePoint.y + timeSquared * _endPoint.y;
			}
			// go straight from start to finish if there is no middle point
			else
			{
				xPosition = _startPoint.x + ((_endPoint.x - _startPoint.x) * time);
				yPosition = _startPoint.y + ((_endPoint.y - _startPoint.y) * time);
			}
            this.x = xPosition;
            this.y = yPosition;
			return true;
        }
	}
}
