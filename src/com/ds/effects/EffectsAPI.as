/**
 * Created by Dave on 30/07/2015.
 */
package com.ds.effects
{
    import com.ds.effects.filtered.AbstractEffect;
    import com.ds.effects.filtered.EffectType;
    import com.ds.effects.filtered.EffectsManager;
    import com.ds.effects.filtered.PerlinData;
    import com.ds.effects.filtered.displace.WaterEffect;
    import com.ds.effects.filtered.motion.ScrollingNoiseEffect;
    import com.ds.effects.filtered.motion.ScrollingTextureEffect;
    import com.ds.effects.motion.OrbitEffect;
    import com.ds.effects.particles.ParticleEffect;
    import com.ds.effects.particles.coinshower.CoinShower;
    import com.ds.effects.particles.stream.ParticleStream;
    import com.ds.effects.particles.stream.ParticleStream3D;

    import de.flintfabrik.starling.display.FFParticleSystem;

    import flash.utils.Dictionary;
    import starling.display.DisplayObject;
    import starling.display.Image;

    /**
     * EffectsAPI for managing effects, can be used as is, but useful to use in conjunction with the tool.
     * If not being used with a tool to generate the effects, look at the EffectManager to add effects by code.
     */
    public class EffectsAPI
    {
        private var _currentEffects : Dictionary;
        private var _effectAttributes : Dictionary;
        private var _effectNames : Vector.<String>;

        /**
         * Creates a new instance of the EffectsAPI.
         */
        public function EffectsAPI()
        {
            FFParticleSystem.init(1024, false, 96, 2);

            _currentEffects = new Dictionary();
            _effectAttributes = new Dictionary();
            _effectNames = new <String>[EffectType.WATER,
                EffectType.SCROLLING_NOISE,
                EffectType.SCROLLING_TEXTURE,
                EffectType.PARTICLE,
                EffectType.PARTICLE_STREAM,
                EffectType.PARTICLE_STREAM3D,
                EffectType.ORBIT,
                EffectType.COIN_SHOWER];


            _effectAttributes[EffectType.WATER] = new <String>["speed", "autoStart"];
            _effectAttributes[EffectType.SCROLLING_NOISE] = new <String>["scrollX", "scrollY", "useColorFilter", "baseX", "baseY", "numOctaves", "greyScale", "autoStart"];
            _effectAttributes[EffectType.SCROLLING_TEXTURE] = new <String>["scrollX", "scrollY", "autoStart"];
            _effectAttributes[EffectType.PARTICLE_STREAM] = new <String>["numParticles", "duration", "durationVariance", "particleCreationInterval", "scaleVariance", "alphaVariance", "rotationVariance", "autoStart"];
            _effectAttributes[EffectType.PARTICLE_STREAM3D] = new <String>["numParticles", "duration", "durationVariance", "particleTimeCreation", "autoStart"];
            _effectAttributes[EffectType.ORBIT] = new <String>["numParticles", "rayX", "speedX", "rayY", "speedY", "layer", "deltaScale", "orbitY", "autoStart"];
            _effectAttributes[EffectType.COIN_SHOWER] = new <String>["posX", "posY", "velocityX", "velocityY", "velocityXVariance", "velocityYVariance", "gravity", "lifeTime", "scale", "rotation", "blendMode", "duration", "autoStart"];
            _effectAttributes[EffectType.PARTICLE] = new <String>["width",
                "height",
                "emitterX",
                "emitterY",
                "sourceX",
                "sourceY",
                "sourceVarianceX",
                "sourceVarianceY",
                "speed",
                "speedVariance",
                "lifeSpan",
                "lifeSpanVariance",
                "angle",
                "angleVariance",
                "gravityX",
                "gravityY",
                "radialAcceleration",
                "tangentialAcceleration",
                "radialAccelVariance",
                "tangentialAccelVariance",
                "startColorRed",
                "startColorGreen",
                "startColorBlue",
                "startColorAlpha",
                "startColorVarianceRed",
                "startColorVarianceGreen",
                "startColorVarianceBlue",
                "startColorVarianceAlpha",
                "finishColorRed",
                "finishColorGreen",
                "finishColorBlue",
                "finishColorAlpha",
                "finishColorVarianceRed",
                "finishColorVarianceGreen",
                "finishColorVarianceBlue",
                "finishColorVarianceAlpha",
                "maxParticles",
                "startParticleSize",
                "startParticleSizeVariance",
                "finishParticleSize",
                "FinishParticleSizeVariance",
                "duration",
                "emitterType",
                "maxRadius",
                "maxRadiusVariance",
                "minRadius",
                "minRadiusVariance",
                "rotatePerSecond",
                "rotatePerSecondVariance",
                "blendFuncSource",
                "blendFuncDestination",
                "rotationStart",
                "rotationStartVariance",
                "rotationEnd",
                "rotationEndVariance",
                "autoStart"];
        }

        /**
         * Adds an effect.
         *
         * @param origin        A String representing the name of the target.
         * @param surface       A DisplayObject to apply the effect on.
         * @param effectName    A String that is the name of the effect
         * @param parameters    The parameters for the effect, as comma separated string.
         */
        public function addEffect(origin : String, surface : DisplayObject, effectName : String, parameters : String) : void
        {
            _currentEffects[origin] = effectName;

            var effect : AbstractEffect;
            var params : Array = removeWhiteSpace(parameters);

            // If alwaysPlay boolean is not set, set default to <code>false</code>.
            var autoStart : Boolean = (params[params.length-1] == '') ? true : Boolean(int(params[params.length-1]));

            switch (effectName)
            {
                case EffectType.WATER:

                    params[0] = (params[0] == '') ? 20 : Number(params[0]);
                    effect = new WaterEffect(surface, params[0]);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);
                    break;

                case EffectType.SCROLLING_NOISE:

                    params[0] = (params[0] == '') ? 0 : Number(params[0]);
                    params[1] = (params[1] == '') ? 0.01 : Number(params[1]);
                    params[2] = (params[2] == '') ? false : Boolean(int(params[2]));

                    if (params[0] > 0.99) params[0] = 0.99;
                    if (params[1] > 0.99) params[1] = 0.99;

                    var perlinData : PerlinData = null;

                    if (params[3] != '' || params[4] != '' || params[5] != '' || params[6] != '')
                    {
                        perlinData = new PerlinData();
                        if (params[3] != '') perlinData.baseX = Number(params[3]);
                        if (params[4] != '') perlinData.baseY = Number(params[4]);
                        if (params[5] != '') perlinData.numOctaves = Number(params[5]);
                        if (params[6] != '') perlinData.greyScale = Boolean(int(params[6]));
                    }
                    effect = new ScrollingNoiseEffect(surface, params[0], params[1], params[2], perlinData);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);

                    break;

                case EffectType.SCROLLING_TEXTURE:
                    params[0] = (params[0] == '') ? 0 : Number(params[0]);
                    params[1] = (params[1] == '') ? 0.01 : Number(params[1]);

                    effect = new ScrollingTextureEffect(surface, params[0], params[1]);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);

                    break;

                case EffectType.PARTICLE:
                    effect = new ParticleEffect(surface, parameters);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);
                    break;

                case EffectType.PARTICLE_STREAM:
                    effect = new ParticleStream(surface, parameters);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);
                    break;

                case EffectType.PARTICLE_STREAM3D:
                    effect = new ParticleStream3D(surface, parameters);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);
                    break;

                case EffectType.ORBIT:
                    params[0] = (params[0] == '') ? 1 : int(params[0]);
                    params[1] = (params[1] == '') ? 0 : Number(params[1]);
                    params[2] = (params[2] == '') ? 1 : Number(params[2]);
                    params[3] = (params[3] == '') ? 0 : Number(params[3]);
                    params[4] = (params[4] == '') ? 1 : Number(params[4]);
                    params[5] = (params[5] == '') ? 0 : int(params[5]);
                    params[6] = (params[6] == '') ? 0.9 : Number(params[6]);
                    params[7] = (params[7] == '') ? false : Boolean(int(params[7]));

                    effect = new OrbitEffect(surface as Image, params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);
                    break;

                case EffectType.COIN_SHOWER:
                    params[0] = (params[0] == '') ? 0 : Number(params[0]);                          // posX
                    params[1] = (params[1] == '') ? 0 : Number(params[1]);                          // posY
                    params[2] = (params[2] == '') ? 250 : Number(params[2]);                        // velX
                    params[3] = (params[3] == '') ? -220 : Number(params[3]);                       // velY
                    params[4] = (params[4] == '') ? -75 : Number(params[4]);                        // velX Variance
                    params[5] = (params[5] == '') ? -300 : Number(params[5]);                       // velY Variance
                    params[6] = (params[6] == '') ? 700 : int(params[6]);                           // gravity
                    params[7] = (params[7] == '') ? 3000 : uint(params[7]);                         // lifetime
                    params[8] = (params[8] == '') ? 1 : Number(params[8]);                          // scale
                    params[9] = (params[9] == '') ? 0 : int(params[9]);                             // rotation
                    params[10] = (params[10] == '') ? 10 : int(params[10]);                         // blendmode
                    params[11] = (params[11] == '') ? 0 : Number(params[11]);                       // duration.
                    effect = new CoinShower(surface as DisplayObject, params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8], params[9], params[10], params[11]);
                    effect.autoStart = autoStart;
                    EffectsManager.getInstance().addEffect(effect);
                    break;

                default:
                    trace(this + ":" +effectName +" is a non existing effect");
                    break;
            }

            EffectsManager.getInstance().startTicker();
        }

        /**
         * Stops all effects.
         *
         * @param needToDelete  A Boolean value, if set to <code>true</code>
         *                      The effect will be deleted.
         */
        public function stopAllEffects(needToDelete : Boolean = false) : void
        {
            EffectsManager.getInstance().stopAllEffects();

            if (needToDelete)
            {
                EffectsManager.getInstance().destroyAllEffects();
            }
        }

        /**
         * Resumes all effects from paused state.
         */
        public function resumeAllEffects() : void
        {
            EffectsManager.getInstance().resumeAllEffects();
        }

        /**
         * Stops a single effect.
         *
         * @param origin        A String that is the name of the displayObject to stop the effect on.
         * @param needToDelete  A Boolean value that if set to <code>true</code> will delete the effect.
         */
        public function stopEffect(origin : String, needToDelete : Boolean = false) : void
        {
            EffectsManager.getInstance().stopEffectForTarget(origin, needToDelete);
        }

        public function startEffect(origin : String) : void
        {
            EffectsManager.getInstance().startEffectForTarget(origin);
        }

        /**
         * Returns a list of all effects.
         * @return  Vector with strings that represent the names of the availlable effects.
         */
        public function effectList() : Vector.<String>
        {
            return _effectNames;
        }

        /**
         * Returns the attributes for the effects.
         * @return  A Dictionary with the effect attributes.
         */
        public function effectAttribNames() : Dictionary
        {
            return _effectAttributes;
        }

        public function overrideAttribute(targetName : String, attribute : String, value : Number) : void
        {
            EffectsManager.getInstance().overrideAttribute(targetName, attribute, value);
        }

        public function resetAttribute(targetName : String, attribute : String) : void
        {
            EffectsManager.getInstance().resetAttribute(targetName, attribute);
        }

        public function resetAllAttributes(targetName : String) : void
        {
            EffectsManager.getInstance().resetAllAttributes(targetName);
        }

        /////////////////////////////////////////
        // Private.
        /////////////////////////////////////////

        public static function removeWhiteSpace(parameters : String) : Array
        {
            var params : Array = parameters.split(",");
            // Remove whitespace if any.
            for (var i : int = 0; i < params.length; i++)
            {
                params[i].replace(/\s+/g, '');
            }
            return params;
        }
    }
}
