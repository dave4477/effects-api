/**
 * Created by Dave on 27/07/2015.
 */
package com.ds.effects.filtered.displace
{
    import com.ds.effects.filtered.EffectsManager;

    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.filters.DisplacementMapFilter;
    import starling.textures.Texture;

    public class WaterEffect extends AbstractDisplaceEffect
    {
        private var _offset : Number = 0;
        private var _height : int = 0;
        private var _width  : int = 0;
        private var _speed : int;

        /**
         *
         * @param target    A DisplayObject to apply the filter to.
         * @param speed
         */
        public function WaterEffect(target : DisplayObject, speed : int = 20)
        {
            super(target, "Water");

            _speed = speed;

            createWater();
        }

        private function createWater() : void
        {
            if (displace) return;

            scale = 1;
            _width = target.width;
            _height = target.height;
            while (_width > 2048 || _height > 2048)
            {
                _width = _width >> 1;
                _height = _height >> 1;
                scale = scale << 1;
            }

            perlinData = new BitmapData(_width * scale, _height * scale, false);
            perlinData.perlinNoise(200 * scale, 20 * scale, 2, 5, true, true, 0, true);

            dispMap = new BitmapData(perlinData.width, perlinData.height << 1, false);
            dispMap.copyPixels(perlinData, perlinData.rect, point);
            dispMap.copyPixels(perlinData, perlinData.rect, new Point(0, perlinData.height));

            var texture : Texture = Texture.fromBitmapData(dispMap, false, false, scale);

            perlinData.dispose();
            dispMap.dispose();

            displace = new DisplacementMapFilter(texture, null, BitmapDataChannel.RED, BitmapDataChannel.RED, 40, 5);

            target.filter = displace;
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
            if (_offset > _height) _offset -= _height;
            else _offset += EffectsManager.passedTime * _speed;

            if (!displace)
            {
                init();
            }
            displace.mapPoint.y = _offset - _height;
        }

        override public function destroy() : void
        {
            target.filter = null;
            displace.mapTexture.dispose();
            displace.dispose();
            displace = null;

            super.destroy();
        }
    }
}
