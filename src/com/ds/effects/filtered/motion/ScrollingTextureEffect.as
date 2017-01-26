/**
 * Created by Dave on 11/08/2015.
 */
package com.ds.effects.filtered.motion
{
    import com.ds.effects.filtered.EffectsManager;

    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.textures.Texture;

    /**
     * Repeating textures are currently NOT implemented in our AssetManager.
     * Will take a screenshot, expensive upon creation.
     */
    public class ScrollingTextureEffect extends AbstractMotionEffect
    {
        private var _image : Image;

        /**
         * Only works when texture repeat is set to true using TextureOptions in the AssetManager.
         * This functionality is currently NOT supported.
         *
         * @param target
         * @param scrollX
         * @param scrollY
         */
        public function ScrollingTextureEffect(target : DisplayObject, scrollX : Number = 0, scrollY : Number = 0.01)
        {
            super(target, "ScrollingTexture");

            scrollSpeedX = scrollX;
            scrollSpeedY = scrollY;

            if (!Image(target).texture.repeat)
            {
                var bmd : BitmapData = drawToBitmap(target);

                if (bmd)
                {
                    var texture : Texture = Texture.fromBitmapData(bmd, true, false, 1, 'bgra', true);
                    _image = Image(target);
                    _image.texture.dispose();
                    _image.texture = texture;

                    bmd.dispose();
                }
                else
                {
                    _image = Image(target);
                }
            }
            else
            {
                _image = Image(target);
            }
        }

        // Repeating textures need to be power of 2 to work.
        private function roundDownPow2(value : Number) : int
        {
            value |= value >> 1;
            value |= value >> 2;
            value |= value >> 4;
            value |= value >> 8;
            value |= value >> 16;
            value = (value >> 1) + 1;

            return value;
        }

        private function drawToBitmap(target : DisplayObject) : BitmapData
        {
            var stageWidth:Number = Starling.current.stage.stageWidth;
            var stageHeight:Number = Starling.current.stage.stageHeight;

            var support:RenderSupport = new RenderSupport();
            RenderSupport.clear();
            support.setProjectionMatrix(0, 0, stageWidth, stageHeight);
            support.applyBlendMode(true);

            var stageBitmapData:BitmapData = new BitmapData(stageWidth, stageHeight, true, 0x0);
            target.render(support, 1.0);
            support.finishQuadBatch();
            Starling.context.drawToBitmapData(stageBitmapData);

            var cropBounds:Rectangle = new Rectangle(0, 0, target.width / target.scaleX, target.height / target.scaleY);

            var w : Number = (scrollSpeedX > 0) ? roundDownPow2(cropBounds.width) : cropBounds.width;
            var h : Number = (scrollSpeedY > 0) ? roundDownPow2(cropBounds.height) : cropBounds.height;

            var resultBitmapData:BitmapData = new BitmapData(w, h, true, 0x0);
            resultBitmapData.copyPixels(stageBitmapData, cropBounds, new Point());

            return resultBitmapData;
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
            super.destroy();
        }
    }
}
