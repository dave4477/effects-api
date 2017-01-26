/**
 * Created by Dave on 27/07/2015.
 */
package com.ds.effects.generated.motion
{
    import flash.display.BitmapData;
    import flash.filters.ColorMatrixFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;

    public class Clouds extends Sprite
    {
        public var numOctaves:int;
        public var cloudsHeight:int;
        public var cloudsWidth:int;
        public var periodX:Number;
        public var periodY:Number;
        public var scrollAmountX:int;
        public var scrollAmountY:int;
        public var maxScrollAmount:int;

        private var cloudsBitmapData:BitmapData;
        private var cmf:ColorMatrixFilter;
        private var displayWidth:Number;
        private var displayHeight:Number;
        private var seed:int;
        private var offsets:Array;
        private var sliceDataH:BitmapData;
        private var sliceDataV:BitmapData;
        private var sliceDataCorner:BitmapData;
        private var horizCutRect:Rectangle;
        private var vertCutRect:Rectangle;
        private var cornerCutRect:Rectangle;
        private var horizPastePoint:Point;
        private var vertPastePoint:Point;
        private var cornerPastePoint:Point;
        private var origin:Point;
        private var texture: Texture;
        private var _colorTrans : ColorTransform;

        private var img : Image;

        public function Clouds(w : int = 300, h : int = 150, scaleX:Number = 1.5, scaleY:Number = 1.5, scrollX : int = -1, scrollY : int = 0)
        {
            configureClouds(w, h, scrollX, scrollY, scaleX, scaleY);
            makeClouds();
            setRectangles();

            addEventListener(Event.ENTER_FRAME, draw)
        }


        private function configureClouds(w:int = 300, h:int = 150, scX:int = -1, scY:int = 0, scaleX:Number = 1.5, scaleY:Number = 1.5) : void
        {
            displayWidth = w;
            displayHeight = h;

            cloudsWidth = Math.floor(scaleX * displayWidth);
            cloudsHeight = Math.floor(scaleY * displayHeight);
            periodX = periodY = 150;

            scrollAmountX = scX;
            scrollAmountY = scY;
            maxScrollAmount = 50;

            numOctaves = 5;

            cloudsBitmapData = new BitmapData(cloudsWidth, cloudsHeight, true);

            origin = new Point(0,0);

            cmf = new ColorMatrixFilter([0,0,0,0,255,
                0,0,0,0,255,
                0,0,0,0,255,
                1,0,0,0,0]);
        }

        private function setRectangles():void
        {
            // clamp scroll amounts
            scrollAmountX = (scrollAmountX > maxScrollAmount) ? maxScrollAmount : ((scrollAmountX < -maxScrollAmount) ? -maxScrollAmount : scrollAmountX);
            scrollAmountY = (scrollAmountY > maxScrollAmount) ? maxScrollAmount : ((scrollAmountY < -maxScrollAmount) ? -maxScrollAmount : scrollAmountY);

            if (scrollAmountX != 0)
            {
                sliceDataV = new BitmapData(Math.abs(scrollAmountX), cloudsHeight - Math.abs(scrollAmountY), true);
            }
            if (scrollAmountY != 0)
            {
                sliceDataH = new BitmapData(cloudsWidth, Math.abs(scrollAmountY), true);
            }
            if ((scrollAmountX != 0)&&(scrollAmountY != 0))
            {
                sliceDataCorner = new BitmapData(Math.abs(scrollAmountX), Math.abs(scrollAmountY), true);
            }
            horizCutRect = new Rectangle(0, cloudsHeight - scrollAmountY, cloudsWidth - Math.abs(scrollAmountX), Math.abs(scrollAmountY));
            vertCutRect = new Rectangle(cloudsWidth - scrollAmountX, 0, Math.abs(scrollAmountX), cloudsHeight - Math.abs(scrollAmountY));
            cornerCutRect = new Rectangle(cloudsWidth - scrollAmountX, cloudsHeight - scrollAmountY,Math.abs(scrollAmountX), Math.abs(scrollAmountY));

            horizPastePoint = new Point(scrollAmountX, 0);
            vertPastePoint = new Point(0, scrollAmountY);
            cornerPastePoint = new Point(0, 0);

            if (scrollAmountX < 0)
            {
                cornerCutRect.x = vertCutRect.x = 0;
                cornerPastePoint.x = vertPastePoint.x = cloudsWidth + scrollAmountX;
                horizCutRect.x = -scrollAmountX;
                horizPastePoint.x = 0;
            }
            if (scrollAmountY < 0)
            {
                cornerCutRect.y = horizCutRect.y = 0;
                cornerPastePoint.y = horizPastePoint.y = cloudsHeight + scrollAmountY;
                vertCutRect.y = -scrollAmountY;
                vertPastePoint.y = 0;
            }

        }

        private function makeClouds() : void
        {
            seed = int(Math.random()*0xFFFFFFFF);

            //create offsets array:
            offsets = new Array();
            for (var i:int = 0; i<=numOctaves-1; i++)
            {
                offsets.push(new Point());
            }

            //draw clouds
            cloudsBitmapData.perlinNoise(periodX, periodY, numOctaves, seed, true, true, 1, true, offsets);
            cloudsBitmapData.applyFilter(cloudsBitmapData, cloudsBitmapData.rect, new Point(), cmf);

            _colorTrans = new ColorTransform();
            _colorTrans.alphaOffset = -100;
            //cloudsBitmapData.colorTransform(cloudsBitmapData.rect, _colorTrans);

            texture = Texture.fromBitmapData(cloudsBitmapData);
            img = new Image(texture);
            //img.texture = texture.updateFromBitmapData(cloudsBitmapData);

            addChild(img);
        }

        public function draw(e : Event) : void
        {
            cloudsBitmapData.lock();

            //copy to buffers the part that will be cut off
            if (scrollAmountX != 0) {
                sliceDataV.copyPixels(cloudsBitmapData, vertCutRect, origin);
            }
            if (scrollAmountY != 0) {
                sliceDataH.copyPixels(cloudsBitmapData, horizCutRect, origin);
            }
            if ((scrollAmountX != 0)&&(scrollAmountY != 0)) {
                sliceDataCorner.copyPixels(cloudsBitmapData, cornerCutRect, origin);
            }

            //scroll
            cloudsBitmapData.scroll(scrollAmountX, scrollAmountY);

            //draw the buffers on the opposite sides
            if (scrollAmountX != 0) {
                cloudsBitmapData.copyPixels(sliceDataV, sliceDataV.rect, vertPastePoint);
            }
            if (scrollAmountY != 0) {
                cloudsBitmapData.copyPixels(sliceDataH, sliceDataH.rect, horizPastePoint);
            }
            if ((scrollAmountX != 0)&&(scrollAmountY != 0)) {
                cloudsBitmapData.copyPixels(sliceDataCorner, sliceDataCorner.rect, cornerPastePoint);
            }

            cloudsBitmapData.unlock();

            //flash.display3D.textures.Texture(texture.base).uploadFromBitmapData(cloudsBitmapData)
            texture.dispose();
            texture = Texture.fromBitmapData(cloudsBitmapData);

            img.texture = texture;
        }
    }
}
