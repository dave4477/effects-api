/**
 * Created by Dave on 05/08/2015.
 */
package com.ds.effects.particles
{
    import com.ds.effects.EffectsAPI;
    import de.flintfabrik.starling.display.FFParticleSystem;
    import de.flintfabrik.starling.display.FFParticleSystem.SystemOptions;

    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;

    public class ParticleEffect extends AbstractParticle
    {
        private var _isActive : Boolean;
        private var _q : Quad;
        private var _arrSettings : Array;
        private var _defaultSettings : Array;

        /**
         * Creates a particle effect.
         *
         * @param target                An Image with texture to be used as particle.
         * @param particleSettings      A comma separated string with settings to be parsed, used to create a pex file.
         */
        public function ParticleEffect(target : DisplayObject, particleSettings : String = "")
        {
            var defaultSettings : ParticleSettings = new ParticleSettings();
            _defaultSettings = defaultSettings.toArray();

            _arrSettings = EffectsAPI.removeWhiteSpace(particleSettings);

            // Dirty size fix.
            var w : Number = (_arrSettings[0] == '' || _arrSettings[0] < 1) ? 1 : _arrSettings[0];
            var h : Number = (_arrSettings[1] == '' || _arrSettings[1] < 1) ? 1 : _arrSettings[1];

            _q = new Quad(w, h, 0xFF0000);
            _q.name = target.name;
            _q.alpha = 0;
            _q.visible = false;


            this.owner = Image(target).parent as Sprite;
            this.owner.addChild(_q);

            // Pass the owner (parent) in this case, for the effectsManager to notice if it's offscreen.
            super(_q, "Particle");

            this.texture = Image(target).texture;
            this.particleParams = particleSettings;

            this.owner.removeChild(target);

            parseSettings();
            createSystemObject();
            createParticle();
        }

        /**
         * Parses the settings from the given string.
         * Creates a pex xml file from the values given.
         */
        private function parseSettings() : void
        {
            for (var i : int = 0; i < _arrSettings.length; i++)
            {
                if (_arrSettings[i] == '')
                {
                    _arrSettings[i] = _defaultSettings[i];
                }
            }

            this.emitterX = _arrSettings[2];
            this.emitterY = _arrSettings[3];

            pexXML = <particleEmitterConfig>
                <texture name="particle.png" />
                <sourcePosition x={_arrSettings[4]} y={_arrSettings[5]}/>
                <sourcePositionVariance x={_arrSettings[6]} y={_arrSettings[7]}/>
                <speed value={_arrSettings[8]}/>
                <speedVariance value={_arrSettings[9]}/>
                <particleLifeSpan value={_arrSettings[10]}/>
                <particleLifespanVariance value={_arrSettings[11]}/>
                <angle value={_arrSettings[12]}/>
                <angleVariance value={_arrSettings[13]}/>
                <gravity x={_arrSettings[14]} y={_arrSettings[15]}/>
                <radialAcceleration value={_arrSettings[16]}/>
                <tangentialAcceleration value={_arrSettings[17]}/>
                <radialAccelVariance value={_arrSettings[18]}/>
                <tangentialAccelVariance value={_arrSettings[19]}/>
                <startColor red={_arrSettings[20]} green={_arrSettings[21]} blue={_arrSettings[22]} alpha={_arrSettings[23]}/>
                <startColorVariance red={_arrSettings[24]} green={_arrSettings[25]} blue={_arrSettings[26]} alpha={_arrSettings[27]}/>
                <finishColor red={_arrSettings[28]} green={_arrSettings[29]} blue={_arrSettings[30]} alpha={_arrSettings[31]}/>
                <finishColorVariance red={_arrSettings[32]} green={_arrSettings[33]} blue={_arrSettings[34]} alpha={_arrSettings[35]}/>
                <maxParticles value={_arrSettings[36]}/>
                <startParticleSize value={_arrSettings[37]}/>
                <startParticleSizeVariance value={_arrSettings[38]}/>
                <finishParticleSize value={_arrSettings[39]}/>
                <FinishParticleSizeVariance value={_arrSettings[40]}/>
                <duration value={_arrSettings[41]}/>
                <emitterType value={_arrSettings[42]}/>
                <maxRadius value={_arrSettings[43]}/>
                <maxRadiusVariance value={_arrSettings[44]}/>
                <minRadius value={_arrSettings[45]}/>
                <minRadiusVariance value={_arrSettings[46]}/>
                <rotatePerSecond value={_arrSettings[47]}/>
                <rotatePerSecondVariance value={_arrSettings[48]}/>
                <blendFuncSource value={_arrSettings[49]}/>
                <blendFuncDestination value={_arrSettings[50]}/>
                <rotationStart value={_arrSettings[51]}/>
                <rotationStartVariance value={_arrSettings[52]}/>
                <rotationEnd value={_arrSettings[53]}/>
                <rotationEndVariance value={_arrSettings[54]}/>
            </particleEmitterConfig>;

            // trace(pexXML);
        }

        private function createSystemObject() : void
        {
            so = SystemOptions.fromXML(pexXML, texture);
        }

        private function createParticle() : void
        {
            ps = new FFParticleSystem(so);
            ps.x = emitterX;
            ps.y = emitterY;

            owner.addChild(ps);

            ps.emitterX = ps.x;
            ps.emitterY = ps.y;
        }

        /**
         * Starts the particles. Unlike the other effects,
         * this does not need updating each frame, so we only
         * start it once.
         */
        override public function draw() : void
        {
            if (!_isActive)
            {
                ps.start();
                _isActive = true;
            }
        }

        /**
         * Stops the particles.
         * When starting again, it will re-start.
         */
        override public function stop() : void
        {
            super.stop();

            if (_isActive)
            {
                ps.stop();
                _isActive = false;
            }
        }

        /**
         * Pauses the particles, like suspended animation.
         */
        override public function pause() : void
        {
            super.pause();

            ps.pause();
            _isActive = false;
        }

        /**
         * Resumes the particles from suspended animation state.
         */
        override public function resume() : void
        {
            super.resume();

            if (!_isActive)
            {
                ps.resume();
                _isActive = true;
            }
        }

        public function get particleX() : Number
        {
            return ps.emitterX;
        }
        public function get particleY() : Number
        {
            return ps.emitterY;
        }
        public function set particleX(value: Number) : void
        {
            ps.emitterX = value;
        }
        public function set particleY(value : Number) : void
        {
            ps.emitterY = value;
        }
        public function set particlePos(value : Point) : void
        {
            ps.emitterX = value.x;
            ps.emitterY = value.y;
        }

        override public function overrideAttribute(attribute : String, value : Number) : void
        {
            if (attribute == "emitterX")
            {
                ps.emitterX = value;
            }
            if (attribute == "emitterY")
            {
                ps.emitterY = value;
            }
        }

        /**
         * Destroys the particles.
         */
        override public function destroy() : void
        {
            if (ps)
            {
                ps.dispose();
            }
            if (_q && owner)
            {
                owner.removeChild(_q);
            }
            _isActive = false;
            _arrSettings = null;
            _defaultSettings = null;

            super.destroy();
        }
    }
}
