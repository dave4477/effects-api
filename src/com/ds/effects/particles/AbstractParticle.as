/**
 * Created by Dave on 05/08/2015.
 */
package com.ds.effects.particles
{
    import com.ds.effects.filtered.AbstractEffect;

    import de.flintfabrik.starling.display.FFParticleSystem;
    import de.flintfabrik.starling.display.FFParticleSystem.SystemOptions;

    import flash.display3D.Context3D;

    import starling.core.Starling;

    import starling.display.DisplayObject;
import starling.display.Sprite;
    import starling.errors.MissingContextError;
    import starling.textures.Texture;

    public class AbstractParticle extends AbstractEffect
    {
        protected var so : SystemOptions;
        protected var pexXML : XML;

        protected var ps : FFParticleSystem;
        protected var owner : Sprite;
        protected var texture : Texture;
        protected var emitterX : Number = 0;
        protected var emitterY : Number = 0;
        protected var settings : ParticleSettings;
        protected var particleParams : String = "";

        /**
         * Abstract particles. Do not instantiate.
         * @param target
         * @param name
         */
        public function AbstractParticle(target : DisplayObject, name : String)
        {
            super(target, name);

            //FFParticleSystem.init(1024, false, 96, 2);

            setupParticles();
        }

        private function setupParticles() : void
        {
            settings = new ParticleSettings();
        }

        override public function draw() : void
        {
            super.draw();
        }

        override public function stop() : void
        {
            super.stop();
        }

        override public function pause() : void
        {
            super.pause();
        }

        override public function resume() : void
        {
            super.resume();
        }

        override public function destroy() : void
        {
            pexXML = null;
            owner = null;
            if (texture)
            {
                texture.dispose();
                texture = null;
            }
            if (ps)
            {
                ps = null;
            }
            super.destroy();
        }
    }
}
