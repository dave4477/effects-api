/**
 * Created by Dave on 27/07/2015.
 */
package com.ds.effects.filtered
{
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.utils.Dictionary;

    import starling.display.DisplayObject;

    public class AbstractEffect
    {
        protected var name : String;
        protected var point : Point;
        protected var color : ColorTransform;
        protected var changedSettings : Dictionary;

        private var _target : DisplayObject;
        private var _autoStart : Boolean = true;

        /**
         * An abstract effect class.
         */
        public function AbstractEffect(target : DisplayObject, name:String = "")
        {
            this.name = name;
            this._target = target;
            changedSettings = new Dictionary();
            createEffect();
        }

        /**
         * Sets up the effect
         */
        private function createEffect():void
        {
            point = new Point();
            color = new ColorTransform();
        }

        /**
         * The proper name of the effect
         */
        public function get effectName():String
        {
            return name;
        }

        /**
         * Draws the effect
         */
        public function draw():void
        {
        }

        public function init() : void
        {
        }

        public function stop() : void
        {
        }

        public function pause() : void
        {
        }

        public function resume() : void
        {
        }

        public function get target() : DisplayObject
        {
            return _target;
        }

        public function get autoStart() : Boolean
        {
            return _autoStart;
        }

        public function set autoStart(value : Boolean) : void
        {
            _autoStart = value;
        }

        public function overrideAttribute(attribute : String, value : Number) : void
        {
        }

        public function resetAttribute(attribute : String) : void
        {
        }

        public function resetAllAttributes() : void
        {
        }

        public function hasAttribute(attribute : String) : Boolean
        {
            for (var k:String in changedSettings)
            {
                var value:Number = changedSettings[k];
                var key:String = k;
                if (key == attribute)
                {
                    return true;
                }
            }
            return false;
        }

        /**
         * Removes the effect and all other referenced objects
         */
        public function destroy():void
        {
            changedSettings = null;
            point = null;
            color = null;
            target.dispose();
        }
    }
}