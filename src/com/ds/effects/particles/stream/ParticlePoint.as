package com.ds.effects.particles.stream
{
	import starling.display.DisplayObject;
	import flash.geom.Point;

	public class ParticlePoint 
	{
		private var _startX:Number;
		private var _startY:Number;
		private var _widthVariance:Number;
		private var _heightVariance:Number;
        private var _fixedPoint:Point;

        public function ParticlePoint(dataStorage : DisplayObject)
		{
			// extract all the useful data from the given display object
			_startX = dataStorage.x;
			_startY = dataStorage.y;
			_widthVariance = dataStorage.width;
			_heightVariance = dataStorage.height;
		}

		// create a random point within the bounding box of the object we used to create the particlepoint
		public function createRandomPoint() : Point
		{
			var _return:Point = new Point();
			
			_return.x = (Math.random()*_widthVariance) + _startX;
			_return.y = (Math.random()*_heightVariance) + _startY;
			return _return;
		}

        // create a random point , store the result and use this a fixed point reference
        public function createFixedPoint():Point
        {
            if(!_fixedPoint)
                _fixedPoint = createRandomPoint();

            return _fixedPoint;
        }

	}
}
