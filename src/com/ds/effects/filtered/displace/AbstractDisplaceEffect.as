/**
 * Created by Dave on 27/07/2015.
 */
package com.ds.effects.filtered.displace
{
    import com.ds.effects.filtered.AbstractEffect;

    import flash.display.BitmapData;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.filters.DisplacementMapFilter;

    public class AbstractDisplaceEffect extends AbstractEffect
    {
        protected var perlinData : BitmapData;
        protected var dispMap : BitmapData;

        protected var displace : DisplacementMapFilter;
        protected var scale : Number = Starling.contentScaleFactor;

        public function AbstractDisplaceEffect(target : DisplayObject, name : String = "")
        {
            super(target, name);
        }

        override public function draw() : void
        {
            super.draw();
        }

        override public function destroy() : void
        {
            if (perlinData) perlinData.dispose();
            if (dispMap) dispMap.dispose();
            if (displace) displace = null;
            super.destroy();
        }
    }
}
