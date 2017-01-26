/**
 * Created by Dave on 30/07/2015.
 */
package com.ds.effects.filtered
{
    import flash.display.BitmapDataChannel;

    /**
     * Class with properties that can be set or get to create perlinNoise.
     */
    public class PerlinData
    {
        private var _baseX : Number;
        private var _baseY : Number;
        private var _numOctaves : uint;
        private var _randomSeed : int;
        private var _stitch : Boolean;
        private var _fractalNoise : Boolean;
        private var _channelOptions : uint;
        private var _greyScale : Boolean;

        public function PerlinData(baseX : Number = 150, baseY : Number = 150, numOctaves : uint = 2, randomSeed : int = 455, stitch : Boolean = true, fractalNoise : Boolean = true, channels : uint = 0, greyScale : Boolean = true)
        {
            _baseX = baseX;
            _baseY = baseY;
            _numOctaves = numOctaves;
            _randomSeed = randomSeed;
            _stitch = stitch;
            _fractalNoise = fractalNoise;
            _channelOptions = channels;
            _greyScale = greyScale;
        }

        public function get baseX() : Number
        {
            return _baseX;
        }

        public function get baseY() : Number
        {
            return _baseY;
        }

        public function get numOctaves() : uint
        {
            return _numOctaves;
        }

        public function get randomSeed() : int
        {
            return _randomSeed;
        }

        public function get stitch() : Boolean
        {
            return _stitch;
        }

        public function get fractalNoise() : Boolean
        {
            return _fractalNoise;
        }

        public function get channelOptions() : uint
        {
            return _channelOptions;
        }

        public function get greyScale() : Boolean
        {
            return _greyScale;
        }

        public function set baseX(value : Number) : void
        {
            _baseX = value;
        }

        public function set baseY(value : Number) : void
        {
            _baseY = value;
        }

        public function set numOctaves(value : uint) : void
        {
            _numOctaves = value;
        }

        public function set randomSeed(value : int) : void
        {
            _randomSeed = value;
        }

        public function set stitch(value : Boolean) : void
        {
            _stitch = value;
        }

        public function set fractalNoise(value : Boolean) : void
        {
            _fractalNoise = value;
        }

        public function set channelOptions(value : uint) : void
        {
            _channelOptions = value;
        }

        public function set greyScale(value : Boolean) : void
        {
            _greyScale = value;
        }
    }
}
