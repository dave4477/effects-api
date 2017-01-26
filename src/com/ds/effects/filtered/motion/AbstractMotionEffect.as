/**
 * Created by Dave on 27/07/2015.
 */
package com.ds.effects.filtered.motion
{
    import com.ds.effects.filtered.AbstractEffect;

    import starling.display.DisplayObject;

    public class AbstractMotionEffect extends AbstractEffect
    {
        protected var scrollSpeedX : Number = 0;
        protected var scrollSpeedY : Number = 0;


        public function AbstractMotionEffect(target : DisplayObject, name : String = "")
        {
            super(target, name);
        }

        override public function draw() : void
        {
            super.draw();
        }

        override public function destroy() : void
        {
            scrollSpeedX = 0;
            scrollSpeedY = 0;

            super.destroy();
        }

    }
}
