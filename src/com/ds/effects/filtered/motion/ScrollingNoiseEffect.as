/**
 * Created by Dave on 30/07/2015.
 */
package com.ds.effects.filtered.motion
{
    import com.ds.effects.filtered.EffectsManager;
    import com.ds.effects.filtered.PerlinData;

    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.geom.ColorTransform;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;

    /**
     * Creates a scrolling sprite with perlinNoise map.
     * Good to create effects like moving clouds or water.
     */
    public class ScrollingNoiseEffect extends AbstractMotionEffect
    {
        private var _texture : Texture;
        private var _image : Image;

        private var _useColorFilter : Boolean;
        private var _perlinData : PerlinData;

        public function ScrollingNoiseEffect(target : DisplayObject, scrollX : Number = 0, scrollY : Number = 0.01, useColorFilter : Boolean = false, perlinData : PerlinData = null)
        {
            super(target, "ScrollingNoise");

            _perlinData = perlinData;
            scrollSpeedX = scrollX;
            scrollSpeedY = scrollY;

            _useColorFilter = useColorFilter;

            createNoiseTexture();
        }

        private function createNoiseTexture() : void
        {
            _image = Image(target);

            var w : Number = (scrollSpeedX > 0) ? 256 : target.width;
            var h : Number = (scrollSpeedY > 0) ? 256 : target.height;
            var bmd : BitmapData = new BitmapData(w, h, true, 0);

            if (_perlinData)
            {
                bmd.perlinNoise(_perlinData.baseX, _perlinData.baseY, _perlinData.numOctaves, _perlinData.randomSeed, _perlinData.stitch, _perlinData.fractalNoise, _perlinData.channelOptions, _perlinData.greyScale, [point, point]);
            }
            else
            {
                bmd.perlinNoise(
                        6,                                  // baseX:Number
                        24,                                 // baseY:Number
                        2,                                  // numOctaves:uint
                        Math.floor(Math.random() * 999),    // randomSeed:int
                        true,                               // stitch:Boolean
                        true,                               // fractalNoise:Boolean
                        BitmapDataChannel.ALPHA,            // channelOptions:uint
                        true,                               //  grayScale:Boolean
                        [point, point]                      // offsets:Array
                );
            }

            if (_useColorFilter)
            {
                applyColorMatrix(bmd);
            }

            _texture = Texture.fromBitmapData(bmd, true, false, 1, "bgra", true);

            // Don't need the bitmapData and old texture no more.
            bmd.dispose();
            bmd = null;

            _image.texture.dispose();
            _image.texture = _texture;
        }

        private function applyColorMatrix(bmd : BitmapData) : void
        {
            var colorTrans : ColorTransform = new ColorTransform();
            colorTrans.redOffset = 90;
            colorTrans.greenOffset = 100;
            colorTrans.blueOffset = 130;
            bmd.colorTransform(bmd.rect, colorTrans);
        }

        override public function overrideAttribute(attribute : String, value : Number) : void
        {
            if (!hasAttribute(attribute))
            {
                changedSettings["_" + attribute] = this["_" + attribute];
            }
            this["_" +attribute] = value;
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
            for (var i : int = 0; i < 4; i++)
            {
                point = _image.getTexCoords(i);

                point.y -= EffectsManager.passedTime * scrollSpeedY;
                point.x -= EffectsManager.passedTime * scrollSpeedX;
                _image.setTexCoords(i, point);
            }
        }

        override public function destroy() : void
        {
            _image.texture.dispose();
            _image.dispose();
            _texture.dispose();

            super.destroy();
        }
    }
}
