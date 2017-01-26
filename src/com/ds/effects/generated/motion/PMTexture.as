/**
 * Created by Dave on 28/07/2015.
 */
package com.ds.effects.generated.motion
{
    import flash.display.BitmapData;
    import flash.display3D.textures.Texture;


    import starling.textures.Texture;

    public class PMTexture extends starling.textures.Texture
    {
        public function updateFromBitmapData(data:BitmapData, mipLevel:uint = 0):void
        {
            flash.display3D.textures.Texture(base).uploadFromBitmapData(data, mipLevel);
        }

    }
}
