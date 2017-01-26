/**
 * Created by Dave on 05/08/2015.
 */
package com.ds.effects.particles
{
    import com.ds.effects.EffectsAPI;

    /**
     * Class to set and / or get typed properties for particle settings.
     */
    public class ParticleSettings
    {
        private var _particleSceneWidth : Number = 1;
        private var _particleSceneHeight : Number = 1;
        private var _emitterX : Number = 0;
        private var _emitterY : Number = 0;
        private var _sourceX : Number = 300;
        private var _sourceY : Number = 300;
        private var _sourceXVariance : Number = 0;
        private var _sourceYVariance : Number = 0;
        private var _speed : Number = 100;
        private var _speedVariance : Number = 30;
        private var _particleLifeSpan : Number = 2;
        private var _particleLifeSpanVariance : Number = 1.9;
        private var _angle : Number = 270;
        private var _angleVariance : Number = 2;
        private var _gravityX : Number = 0;
        private var _gravityY : Number = 0;
        private var _radialAcceleration : Number = 0;
        private var _tangentialAcceleration : Number = 0;
        private var _radialAccelVariance : Number = 0;
        private var _tangentialAccelVariance : Number = 0;
        private var _startColorRed : Number = 1;
        private var _startColorGreen : Number = 0.31;
        private var _startColorBlue : Number = 0;
        private var _startColorAlpha : Number = 0.62;
        private var _startColorVarianceRed : Number = 0;
        private var _startColorVarianceGreen : Number = 0;
        private var _startColorVarianceBlue : Number = 0;
        private var _startColorVarianceAlpha : Number = 0;
        private var _finishColorRed : Number = 1;
        private var _finishColorGreen : Number = 0.31;
        private var _finishColorBlue : Number = 0;
        private var _finishColorAlpha : Number = 0;
        private var _finishColorVarianceRed : Number = 0;
        private var _finishColorVarianceGreen : Number = 0;
        private var _finishColorVarianceBlue : Number = 0;
        private var _finishColorVarianceAlpha : Number = 0;
        private var _maxParticles : int = 200;
        private var _startParticleSize : Number = 70;
        private var _startParticleSizeVariance : Number = 49.53;
        private var _finishParticleSize : Number = 10;
        private var _finishParticleSizeVariance : Number = 5;
        private var _duration : Number = -1;
        private var _emitterType : Number = 0;
        private var _maxRadius : Number = 100;
        private var _maxRadiusVariance : Number = 0;
        private var _minRadius : Number = 0;
        private var _minRadiusVariance : Number = 0;
        private var _rotatePerSecond : Number = 0;
        private var _rotatePerSecondVariance : Number = 0;
        private var _blendFuncSource : Number = 770;
        private var _blendFuncDestination : Number = 1;
        private var _rotationStart : Number = 0;
        private var _rotationStartVariance : Number = 0;
        private var _rotationEnd : Number = 0;
        private var _rotationEndVariance : Number = 0;

        public function ParticleSettings()
        {
        }

        public function get emitterX():Number
        {
            return _emitterX;
        }

        public function set emitterX(value:Number):void
        {
            _emitterX = value;
        }

        public function get emitterY():Number
        {
            return _emitterY;
        }

        public function set emitterY(value:Number):void
        {
            _emitterY = value;
        }

        public function get sourceX() : Number
        {
            return _sourceX;
        }

        public function set sourceX(value : Number) : void
        {
            _sourceX = value;
        }

        public function get sourceY() : Number
        {
            return _sourceY;
        }

        public function set sourceY(value : Number) : void
        {
            _sourceY = value;
        }

        public function get sourceXVariance() : Number
        {
            return _sourceXVariance;
        }

        public function set sourceXVariance(value : Number) : void
        {
            _sourceXVariance = value;
        }

        public function get sourceYVariance() : Number
        {
            return _sourceYVariance;
        }

        public function set sourceYVariance(value : Number) : void
        {
            _sourceYVariance = value;
        }

        public function get speed() : Number
        {
            return _speed;
        }

        public function set speed(value : Number) : void
        {
            _speed = value;
        }

        public function get speedVariance() : Number
        {
            return _speedVariance;
        }

        public function set speedVariance(value : Number) : void
        {
            _speedVariance = value;
        }

        public function get particleLifeSpan() : Number
        {
            return _particleLifeSpan;
        }

        public function set particleLifeSpan(value : Number) : void
        {
            _particleLifeSpan = value;
        }

        public function get particleLifeSpanVariance() : Number
        {
            return _particleLifeSpanVariance;
        }

        public function set particleLifeSpanVariance(value : Number) : void
        {
            _particleLifeSpanVariance = value;
        }

        public function get angle() : Number
        {
            return _angle;
        }

        public function set angle(value : Number) : void
        {
            _angle = value;
        }

        public function get angleVariance() : Number
        {
            return _angleVariance;
        }

        public function set angleVariance(value : Number) : void
        {
            _angleVariance = value;
        }

        public function get gravityX() : Number
        {
            return _gravityX;
        }

        public function set gravityX(value : Number) : void
        {
            _gravityX = value;
        }

        public function get gravityY() : Number
        {
            return _gravityY;
        }

        public function set gravityY(value : Number) : void
        {
            _gravityY = value;
        }

        public function get radialAcceleration() : Number
        {
            return _radialAcceleration;
        }

        public function set radialAcceleration(value : Number) : void
        {
            _radialAcceleration = value;
        }

        public function get tangentialAcceleration() : Number
        {
            return _tangentialAcceleration;
        }

        public function set tangentialAcceleration(value : Number) : void
        {
            _tangentialAcceleration = value;
        }

        public function get radialAccelVariance() : Number
        {
            return _radialAccelVariance;
        }

        public function set radialAccelVariance(value : Number) : void
        {
            _radialAccelVariance = value;
        }

        public function get tangentialAccelVariance() : Number
        {
            return _tangentialAccelVariance;
        }

        public function set tangentialAccelVariance(value : Number) : void
        {
            _tangentialAccelVariance = value;
        }

        public function get startColorRed() : Number
        {
            return _startColorRed;
        }

        public function set startColorRed(value : Number) : void
        {
            _startColorRed = value;
        }

        public function get startColorGreen() : Number
        {
            return _startColorGreen;
        }

        public function set startColorGreen(value : Number) : void
        {
            _startColorGreen = value;
        }

        public function get startColorBlue() : Number
        {
            return _startColorBlue;
        }

        public function set startColorBlue(value : Number) : void
        {
            _startColorBlue = value;
        }

        public function get startColorAlpha() : Number
        {
            return _startColorAlpha;
        }

        public function set startColorAlpha(value : Number) : void
        {
            _startColorAlpha = value;
        }

        public function get finishColorRed() : Number
        {
            return _finishColorRed;
        }

        public function set finishColorRed(value : Number) : void
        {
            _finishColorRed = value;
        }

        public function get finishColorGreen() : Number
        {
            return _finishColorGreen;
        }

        public function set finishColorGreen(value : Number) : void
        {
            _finishColorGreen = value;
        }

        public function get finishColorBlue() : Number
        {
            return _finishColorBlue;
        }

        public function set finishColorBlue(value : Number) : void
        {
            _finishColorBlue = value;
        }

        public function get finishColorAlpha() : Number
        {
            return _finishColorAlpha;
        }

        public function set finishColorAlpha(value : Number) : void
        {
            _finishColorAlpha = value;
        }

        public function get startColorVarianceRed() : Number
        {
            return _startColorVarianceRed;
        }

        public function set startColorVarianceRed(value : Number) : void
        {
            _startColorVarianceRed = value;
        }

        public function get startColorVarianceGreen() : Number
        {
            return _startColorVarianceGreen;
        }

        public function set startColorVarianceGreen(value : Number) : void
        {
            _startColorVarianceGreen = value;
        }

        public function get startColorVarianceBlue() : Number
        {
            return _startColorVarianceBlue;
        }

        public function set startColorVarianceBlue(value : Number) : void
        {
            _startColorVarianceBlue = value;
        }

        public function get startColorVarianceAlpha() : Number
        {
            return _startColorVarianceAlpha;
        }

        public function set startColorVarianceAlpha(value : Number) : void
        {
            _startColorVarianceAlpha = value;
        }

        public function get finishColorVarianceRed() : Number
        {
            return _finishColorVarianceRed;
        }

        public function set finishColorVarianceRed(value : Number) : void
        {
            _finishColorVarianceRed = value;
        }

        public function get finishColorVarianceGreen() : Number
        {
            return _finishColorVarianceGreen;
        }

        public function set finishColorVarianceGreen(value : Number) : void
        {
            _finishColorVarianceGreen = value;
        }

        public function get finishColorVarianceBlue() : Number
        {
            return _finishColorVarianceBlue;
        }

        public function set finishColorVarianceBlue(value : Number) : void
        {
            _finishColorVarianceBlue = value;
        }

        public function get finishColorVarianceAlpha() : Number
        {
            return _finishColorVarianceAlpha;
        }

        public function set finishColorVarianceAlpha(value : Number) : void
        {
            _finishColorVarianceAlpha = value;
        }

        public function get maxParticles() : int
        {
            return _maxParticles;
        }

        public function set maxParticles(value : int) : void
        {
            _maxParticles = value;
        }

        public function get startParticleSize() : Number
        {
            return _startParticleSize;
        }

        public function set startParticleSize(value : Number) : void
        {
            _startParticleSize = value;
        }

        public function get startParticleSizeVariance() : Number
        {
            return _startParticleSizeVariance;
        }

        public function set startParticleSizeVariance(value : Number) : void
        {
            _startParticleSizeVariance = value;
        }

        public function get finishParticleSize() : Number
        {
            return _finishParticleSize;
        }

        public function set finishParticleSize(value : Number) : void
        {
            _finishParticleSize = value;
        }

        public function get finishParticleSizeVariance() : Number
        {
            return _finishParticleSizeVariance;
        }

        public function set finishParticleSizeVariance(value : Number) : void
        {
            _finishParticleSizeVariance = value;
        }

        public function get duration() : Number
        {
            return _duration;
        }

        public function set duration(value : Number) : void
        {
            _duration = value;
        }

        public function get emitterType() : Number
        {
            return _emitterType;
        }

        public function set emitterType(value : Number) : void
        {
            _emitterType = value;
        }

        public function get maxRadius() : Number
        {
            return _maxRadius;
        }

        public function set maxRadius(value : Number) : void
        {
            _maxRadius = value;
        }

        public function get maxRadiusVariance() : Number
        {
            return _maxRadiusVariance;
        }

        public function set maxRadiusVariance(value : Number) : void
        {
            _maxRadiusVariance = value;
        }

        public function get minRadius() : Number
        {
            return _minRadius;
        }

        public function set minRadius(value : Number) : void
        {
            _minRadius = value;
        }

        public function get minRadiusVariance() : Number
        {
            return _minRadiusVariance;
        }

        public function set minRadiusVariance(value : Number) : void
        {
            _minRadiusVariance = value;
        }

        public function get rotatePerSecond() : Number
        {
            return _rotatePerSecond;
        }

        public function set rotatePerSecond(value : Number) : void
        {
            _rotatePerSecond = value;
        }

        public function get rotatePerSecondVariance() : Number
        {
            return _rotatePerSecondVariance;
        }

        public function set rotatePerSecondVariance(value : Number) : void
        {
            _rotatePerSecondVariance = value;
        }

        public function get blendFuncSource() : Number
        {
            return _blendFuncSource;
        }

        public function set blendFuncSource(value : Number) : void
        {
            _blendFuncSource = value;
        }

        public function get blendFuncDestination() : Number
        {
            return _blendFuncDestination;
        }

        public function set blendFuncDestination(value : Number) : void
        {
            _blendFuncDestination = value;
        }

        public function get rotationStart() : Number
        {
            return _rotationStart;
        }

        public function set rotationStart(value : Number) : void
        {
            _rotationStart = value;
        }

        public function get rotationStartVariance() : Number
        {
            return _rotationStartVariance;
        }

        public function set rotationStartVariance(value : Number) : void
        {
            _rotationStartVariance = value;
        }

        public function get rotationEnd() : Number
        {
            return _rotationEnd;
        }

        public function set rotationEnd(value : Number) : void
        {
            _rotationEnd = value;
        }

        public function get rotationEndVariance() : Number
        {
            return _rotationEndVariance;
        }

        public function set rotationEndVariance(value : Number) : void
        {
            _rotationEndVariance = value;
        }

        public function get particleSceneWidth():Number
        {
            return _particleSceneWidth;
        }

        public function set particleSceneWidth(value:Number):void
        {
            _particleSceneWidth = value;
        }

        public function get particleSceneHeight():Number
        {
            return _particleSceneHeight;
        }

        public function set particleSceneHeight(value:Number):void
        {
            _particleSceneHeight = value;
        }

        /**
         * Returns a string that holding the particle's properties
         * @return  A comma separated string.
         */
        public function toString() : String
        {
            var str : String = "";
            str += "" +_particleSceneWidth +",";
            str += "" +_particleSceneHeight + ",";
            str += "" +_emitterX + ",";
            str += "" +_emitterY + ",";
            str += "" +_sourceX+ ",";
            str += "" +_sourceY+ ",";
            str += "" +_sourceXVariance+ ",";
            str += "" +_sourceYVariance+ ",";
            str += "" +_speed+ ",";
            str += "" +_speedVariance+ ",";
            str += "" +_particleLifeSpan+ ",";
            str += "" +_particleLifeSpanVariance+ ",";
            str += "" +_angle+ ",";
            str += "" +_angleVariance+ ",";
            str += "" +_gravityX+ ",";
            str += "" +_gravityY+ ",";
            str += "" +_radialAcceleration+ ",";
            str += "" +_tangentialAcceleration+ ",";
            str += "" +_radialAccelVariance+ ",";
            str += "" +_tangentialAccelVariance+ ",";
            str += "" +_startColorRed+ ",";
            str += "" +_startColorGreen+ ",";
            str += "" +_startColorBlue+ ",";
            str += "" +_startColorAlpha+ ",";
            str += "" +_startColorVarianceRed+ ",";
            str += "" +_startColorVarianceGreen+ ",";
            str += "" +_startColorVarianceBlue+ ",";
            str += "" +_startColorVarianceAlpha+ ",";
            str += "" +_finishColorRed+ ",";
            str += "" +_finishColorGreen+ ",";
            str += "" +_finishColorBlue+ ",";
            str += "" +_finishColorAlpha+ ",";
            str += "" +_finishColorVarianceRed+ ",";
            str += "" +_finishColorVarianceGreen+ ",";
            str += "" +_finishColorVarianceBlue+ ",";
            str += "" +_finishColorVarianceAlpha+ ",";
            str += "" +_maxParticles+ ",";
            str += "" +_startParticleSize+ ",";
            str += "" +_startParticleSizeVariance+ ",";
            str += "" +_finishParticleSize+ ",";
            str += "" +_finishParticleSizeVariance+ ",";
            str += "" +_duration+ ",";
            str += "" +_emitterType+ ",";
            str += "" +_maxRadius+ ",";
            str += "" +_maxRadiusVariance+ ",";
            str += "" +_minRadius+  ",";
            str += "" +_minRadiusVariance+ ",";
            str += "" +_rotatePerSecond+ ",";
            str += "" +_rotatePerSecondVariance+ ",";
            str += "" +_blendFuncSource+ ",";
            str += "" +_blendFuncDestination+ ",";
            str += "" +_rotationStart+ ",";
            str += "" +_rotationStartVariance+ ",";
            str += "" +_rotationEnd+ ",";
            str += "" +_rotationEndVariance+ "";
            return str;
        }

        /**
         * Returns an array holding the particle's properties
         * @return  An array with the particle's properties.
         */
        public function toArray() : Array
        {
            var str : String = toString();
            return EffectsAPI.removeWhiteSpace(str);

        }
    }
}
