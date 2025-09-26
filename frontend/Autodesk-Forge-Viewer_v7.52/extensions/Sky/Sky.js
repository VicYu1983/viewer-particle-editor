// Content for 'my-awesome-extension.js'

var onework = onework || {};
onework.sky = {};

(function () {
    var freeGlobal = typeof global == 'object' && global && global.Object === Object && global;
    onework.sky.freeGlobal = freeGlobal;
})();

(function () {

    var freeGlobal = onework.sky.freeGlobal;

    /** Detect free variable `self`. */
    var freeSelf = typeof self == 'object' && self && self.Object === Object && self;

    /** Used as a reference to the global object. */
    var root = freeGlobal || freeSelf || Function('return this')();

    onework.sky.root = root;
})();

(function () {
    var root = onework.sky.root;

    /**
     * Gets the timestamp of the number of milliseconds that have elapsed since
     * the Unix epoch (1 January 1970 00:00:00 UTC).
     *
     * @static
     * @memberOf _
     * @since 2.4.0
     * @category Date
     * @returns {number} Returns the timestamp.
     * @example
     *
     * _.defer(function(stamp) {
     *   console.log(_.now() - stamp);
     * }, _.now());
     * // => Logs the number of milliseconds it took for the deferred invocation.
     */
    var now = function () {
        return root.Date.now();
    };

    onework.sky.now = now;
})();

(function () {
    function isObject(value) {
        var type = typeof value;
        return value != null && (type == 'object' || type == 'function');
    }
    onework.sky.isObject = isObject;
})();

(function () {
    /** Used to match a single whitespace character. */
    var reWhitespace = /\s/;

    /**
     * Used by `_.trim` and `_.trimEnd` to get the index of the last non-whitespace
     * character of `string`.
     *
     * @private
     * @param {string} string The string to inspect.
     * @returns {number} Returns the index of the last non-whitespace character.
     */
    function trimmedEndIndex(string) {
        var index = string.length;

        while (index-- && reWhitespace.test(string.charAt(index))) { }
        return index;
    }

    onework.sky.trimmedEndIndex = trimmedEndIndex;
})();

(function () {
    var trimmedEndIndex = onework.sky.trimmedEndIndex;

    /** Used to match leading whitespace. */
    var reTrimStart = /^\s+/;

    /**
     * The base implementation of `_.trim`.
     *
     * @private
     * @param {string} string The string to trim.
     * @returns {string} Returns the trimmed string.
     */
    function baseTrim(string) {
        return string
            ? string.slice(0, trimmedEndIndex(string) + 1).replace(reTrimStart, '')
            : string;
    }
    onework.sky.baseTrim = baseTrim;
})();

(function () {
    var root = onework.sky.root;

    /** Built-in value references. */
    var Symbol = root.Symbol;
    onework.sky.Symbol = Symbol;
})();

(function () {
    var Symbol = onework.sky.Symbol;

    /** Used for built-in method references. */
    var objectProto = Object.prototype;

    /** Used to check objects for own properties. */
    var hasOwnProperty = objectProto.hasOwnProperty;

    /**
     * Used to resolve the
     * [`toStringTag`](http://ecma-international.org/ecma-262/7.0/#sec-object.prototype.tostring)
     * of values.
     */
    var nativeObjectToString = objectProto.toString;

    /** Built-in value references. */
    var symToStringTag = Symbol ? Symbol.toStringTag : undefined;

    /**
     * A specialized version of `baseGetTag` which ignores `Symbol.toStringTag` values.
     *
     * @private
     * @param {*} value The value to query.
     * @returns {string} Returns the raw `toStringTag`.
     */
    function getRawTag(value) {
        var isOwn = hasOwnProperty.call(value, symToStringTag),
            tag = value[symToStringTag];

        try {
            value[symToStringTag] = undefined;
            var unmasked = true;
        } catch (e) { }

        var result = nativeObjectToString.call(value);
        if (unmasked) {
            if (isOwn) {
                value[symToStringTag] = tag;
            } else {
                delete value[symToStringTag];
            }
        }
        return result;
    }
    onework.sky.getRawTag = getRawTag;
})();

(function () {
    /** Used for built-in method references. */
    var objectProto = Object.prototype;

    /**
     * Used to resolve the
     * [`toStringTag`](http://ecma-international.org/ecma-262/7.0/#sec-object.prototype.tostring)
     * of values.
     */
    var nativeObjectToString = objectProto.toString;

    /**
     * Converts `value` to a string using `Object.prototype.toString`.
     *
     * @private
     * @param {*} value The value to convert.
     * @returns {string} Returns the converted string.
     */
    function objectToString(value) {
        return nativeObjectToString.call(value);
    }

    onework.sky.objectToString = objectToString;
})();

(function () {
    var Symbol = onework.sky.Symbol,
        getRawTag = onework.sky.getRawTag,
        objectToString = onework.sky.objectToStrin;

    /** `Object#toString` result references. */
    var nullTag = '[object Null]',
        undefinedTag = '[object Undefined]';

    /** Built-in value references. */
    var symToStringTag = Symbol ? Symbol.toStringTag : undefined;

    /**
     * The base implementation of `getTag` without fallbacks for buggy environments.
     *
     * @private
     * @param {*} value The value to query.
     * @returns {string} Returns the `toStringTag`.
     */
    function baseGetTag(value) {
        if (value == null) {
            return value === undefined ? undefinedTag : nullTag;
        }
        return (symToStringTag && symToStringTag in Object(value))
            ? getRawTag(value)
            : objectToString(value);
    }
    onework.sky.baseGetTag = baseGetTag;
})();

(function () {
    /**
     * Checks if `value` is object-like. A value is object-like if it's not `null`
     * and has a `typeof` result of "object".
     *
     * @static
     * @memberOf _
     * @since 4.0.0
     * @category Lang
     * @param {*} value The value to check.
     * @returns {boolean} Returns `true` if `value` is object-like, else `false`.
     * @example
     *
     * _.isObjectLike({});
     * // => true
     *
     * _.isObjectLike([1, 2, 3]);
     * // => true
     *
     * _.isObjectLike(_.noop);
     * // => false
     *
     * _.isObjectLike(null);
     * // => false
     */
    function isObjectLike(value) {
        return value != null && typeof value == 'object';
    }
    onework.sky.isObjectLike = isObjectLike;
})();

(function () {
    var baseGetTag = onework.sky.baseGetTag,
        isObjectLike = onework.sky.isObjectLike;

    /** `Object#toString` result references. */
    var symbolTag = '[object Symbol]';

    /**
     * Checks if `value` is classified as a `Symbol` primitive or object.
     *
     * @static
     * @memberOf _
     * @since 4.0.0
     * @category Lang
     * @param {*} value The value to check.
     * @returns {boolean} Returns `true` if `value` is a symbol, else `false`.
     * @example
     *
     * _.isSymbol(Symbol.iterator);
     * // => true
     *
     * _.isSymbol('abc');
     * // => false
     */
    function isSymbol(value) {
        return typeof value == 'symbol' ||
            (isObjectLike(value) && baseGetTag(value) == symbolTag);
    }

    onework.sky.isSymbol = isSymbol;
})();

(function () {
    var baseTrim = onework.sky.baseTrim,
        isObject = onework.sky.isObject,
        isSymbol = onework.sky.isSymbol;

    /** Used as references for various `Number` constants. */
    var NAN = 0 / 0;

    /** Used to detect bad signed hexadecimal string values. */
    var reIsBadHex = /^[-+]0x[0-9a-f]+$/i;

    /** Used to detect binary string values. */
    var reIsBinary = /^0b[01]+$/i;

    /** Used to detect octal string values. */
    var reIsOctal = /^0o[0-7]+$/i;

    /** Built-in method references without a dependency on `root`. */
    var freeParseInt = parseInt;

    /**
     * Converts `value` to a number.
     *
     * @static
     * @memberOf _
     * @since 4.0.0
     * @category Lang
     * @param {*} value The value to process.
     * @returns {number} Returns the number.
     * @example
     *
     * _.toNumber(3.2);
     * // => 3.2
     *
     * _.toNumber(Number.MIN_VALUE);
     * // => 5e-324
     *
     * _.toNumber(Infinity);
     * // => Infinity
     *
     * _.toNumber('3.2');
     * // => 3.2
     */
    function toNumber(value) {
        if (typeof value == 'number') {
            return value;
        }
        if (isSymbol(value)) {
            return NAN;
        }
        if (isObject(value)) {
            var other = typeof value.valueOf == 'function' ? value.valueOf() : value;
            value = isObject(other) ? (other + '') : other;
        }
        if (typeof value != 'string') {
            return value === 0 ? value : +value;
        }
        value = baseTrim(value);
        var isBinary = reIsBinary.test(value);
        return (isBinary || reIsOctal.test(value))
            ? freeParseInt(value.slice(2), isBinary ? 2 : 8)
            : (reIsBadHex.test(value) ? NAN : +value);
    }
    onework.sky.toNumber = toNumber;
})();

(function () {
    var isObject = onework.sky.isObject,
        now = onework.sky.now,
        toNumber = onework.sky.toNumber;

    /** Error message constants. */
    var FUNC_ERROR_TEXT = 'Expected a function';

    /* Built-in method references for those with the same name as other `lodash` methods. */
    var nativeMax = Math.max,
        nativeMin = Math.min;

    /**
     * Creates a debounced function that delays invoking `func` until after `wait`
     * milliseconds have elapsed since the last time the debounced function was
     * invoked. The debounced function comes with a `cancel` method to cancel
     * delayed `func` invocations and a `flush` method to immediately invoke them.
     * Provide `options` to indicate whether `func` should be invoked on the
     * leading and/or trailing edge of the `wait` timeout. The `func` is invoked
     * with the last arguments provided to the debounced function. Subsequent
     * calls to the debounced function return the result of the last `func`
     * invocation.
     *
     * **Note:** If `leading` and `trailing` options are `true`, `func` is
     * invoked on the trailing edge of the timeout only if the debounced function
     * is invoked more than once during the `wait` timeout.
     *
     * If `wait` is `0` and `leading` is `false`, `func` invocation is deferred
     * until to the next tick, similar to `setTimeout` with a timeout of `0`.
     *
     * See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
     * for details over the differences between `_.debounce` and `_.throttle`.
     *
     * @static
     * @memberOf _
     * @since 0.1.0
     * @category Function
     * @param {Function} func The function to debounce.
     * @param {number} [wait=0] The number of milliseconds to delay.
     * @param {Object} [options={}] The options object.
     * @param {boolean} [options.leading=false]
     *  Specify invoking on the leading edge of the timeout.
     * @param {number} [options.maxWait]
     *  The maximum time `func` is allowed to be delayed before it's invoked.
     * @param {boolean} [options.trailing=true]
     *  Specify invoking on the trailing edge of the timeout.
     * @returns {Function} Returns the new debounced function.
     * @example
     *
     * // Avoid costly calculations while the window size is in flux.
     * jQuery(window).on('resize', _.debounce(calculateLayout, 150));
     *
     * // Invoke `sendMail` when clicked, debouncing subsequent calls.
     * jQuery(element).on('click', _.debounce(sendMail, 300, {
     *   'leading': true,
     *   'trailing': false
     * }));
     *
     * // Ensure `batchLog` is invoked once after 1 second of debounced calls.
     * var debounced = _.debounce(batchLog, 250, { 'maxWait': 1000 });
     * var source = new EventSource('/stream');
     * jQuery(source).on('message', debounced);
     *
     * // Cancel the trailing debounced invocation.
     * jQuery(window).on('popstate', debounced.cancel);
     */
    function debounce(func, wait, options) {
        var lastArgs,
            lastThis,
            maxWait,
            result,
            timerId,
            lastCallTime,
            lastInvokeTime = 0,
            leading = false,
            maxing = false,
            trailing = true;

        if (typeof func != 'function') {
            throw new TypeError(FUNC_ERROR_TEXT);
        }
        wait = toNumber(wait) || 0;
        if (isObject(options)) {
            leading = !!options.leading;
            maxing = 'maxWait' in options;
            maxWait = maxing ? nativeMax(toNumber(options.maxWait) || 0, wait) : maxWait;
            trailing = 'trailing' in options ? !!options.trailing : trailing;
        }

        function invokeFunc(time) {
            var args = lastArgs,
                thisArg = lastThis;

            lastArgs = lastThis = undefined;
            lastInvokeTime = time;
            result = func.apply(thisArg, args);
            return result;
        }

        function leadingEdge(time) {
            // Reset any `maxWait` timer.
            lastInvokeTime = time;
            // Start the timer for the trailing edge.
            timerId = setTimeout(timerExpired, wait);
            // Invoke the leading edge.
            return leading ? invokeFunc(time) : result;
        }

        function remainingWait(time) {
            var timeSinceLastCall = time - lastCallTime,
                timeSinceLastInvoke = time - lastInvokeTime,
                timeWaiting = wait - timeSinceLastCall;

            return maxing
                ? nativeMin(timeWaiting, maxWait - timeSinceLastInvoke)
                : timeWaiting;
        }

        function shouldInvoke(time) {
            var timeSinceLastCall = time - lastCallTime,
                timeSinceLastInvoke = time - lastInvokeTime;

            // Either this is the first call, activity has stopped and we're at the
            // trailing edge, the system time has gone backwards and we're treating
            // it as the trailing edge, or we've hit the `maxWait` limit.
            return (lastCallTime === undefined || (timeSinceLastCall >= wait) ||
                (timeSinceLastCall < 0) || (maxing && timeSinceLastInvoke >= maxWait));
        }

        function timerExpired() {
            var time = now();
            if (shouldInvoke(time)) {
                return trailingEdge(time);
            }
            // Restart the timer.
            timerId = setTimeout(timerExpired, remainingWait(time));
        }

        function trailingEdge(time) {
            timerId = undefined;

            // Only invoke if we have `lastArgs` which means `func` has been
            // debounced at least once.
            if (trailing && lastArgs) {
                return invokeFunc(time);
            }
            lastArgs = lastThis = undefined;
            return result;
        }

        function cancel() {
            if (timerId !== undefined) {
                clearTimeout(timerId);
            }
            lastInvokeTime = 0;
            lastArgs = lastCallTime = lastThis = timerId = undefined;
        }

        function flush() {
            return timerId === undefined ? result : trailingEdge(now());
        }

        function debounced() {
            var time = now(),
                isInvoking = shouldInvoke(time);

            lastArgs = arguments;
            lastThis = this;
            lastCallTime = time;

            if (isInvoking) {
                if (timerId === undefined) {
                    return leadingEdge(lastCallTime);
                }
                if (maxing) {
                    // Handle invocations in a tight loop.
                    clearTimeout(timerId);
                    timerId = setTimeout(timerExpired, wait);
                    return invokeFunc(lastCallTime);
                }
            }
            if (timerId === undefined) {
                timerId = setTimeout(timerExpired, wait);
            }
            return result;
        }
        debounced.cancel = cancel;
        debounced.flush = flush;
        return debounced;
    }

    onework.sky.debounce = debounce;
})();

(function () {
    var debounce = onework.sky.debounce,
        isObject = onework.sky.isObject;

    /** Error message constants. */
    var FUNC_ERROR_TEXT = 'Expected a function';

    /**
     * Creates a throttled function that only invokes `func` at most once per
     * every `wait` milliseconds. The throttled function comes with a `cancel`
     * method to cancel delayed `func` invocations and a `flush` method to
     * immediately invoke them. Provide `options` to indicate whether `func`
     * should be invoked on the leading and/or trailing edge of the `wait`
     * timeout. The `func` is invoked with the last arguments provided to the
     * throttled function. Subsequent calls to the throttled function return the
     * result of the last `func` invocation.
     *
     * **Note:** If `leading` and `trailing` options are `true`, `func` is
     * invoked on the trailing edge of the timeout only if the throttled function
     * is invoked more than once during the `wait` timeout.
     *
     * If `wait` is `0` and `leading` is `false`, `func` invocation is deferred
     * until to the next tick, similar to `setTimeout` with a timeout of `0`.
     *
     * See [David Corbacho's article](https://css-tricks.com/debouncing-throttling-explained-examples/)
     * for details over the differences between `_.throttle` and `_.debounce`.
     *
     * @static
     * @memberOf _
     * @since 0.1.0
     * @category Function
     * @param {Function} func The function to throttle.
     * @param {number} [wait=0] The number of milliseconds to throttle invocations to.
     * @param {Object} [options={}] The options object.
     * @param {boolean} [options.leading=true]
     *  Specify invoking on the leading edge of the timeout.
     * @param {boolean} [options.trailing=true]
     *  Specify invoking on the trailing edge of the timeout.
     * @returns {Function} Returns the new throttled function.
     * @example
     *
     * // Avoid excessively updating the position while scrolling.
     * jQuery(window).on('scroll', _.throttle(updatePosition, 100));
     *
     * // Invoke `renewToken` when the click event is fired, but not more than once every 5 minutes.
     * var throttled = _.throttle(renewToken, 300000, { 'trailing': false });
     * jQuery(element).on('click', throttled);
     *
     * // Cancel the trailing throttled invocation.
     * jQuery(window).on('popstate', throttled.cancel);
     */
    function throttle(func, wait, options) {
        var leading = true,
            trailing = true;

        if (typeof func != 'function') {
            throw new TypeError(FUNC_ERROR_TEXT);
        }
        if (isObject(options)) {
            leading = 'leading' in options ? !!options.leading : leading;
            trailing = 'trailing' in options ? !!options.trailing : trailing;
        }
        return debounce(func, wait, {
            'leading': leading,
            'maxWait': wait,
            'trailing': trailing
        });
    }

    onework.sky.throttle = throttle;
})();

(function () {

    var TAB_ID = 'configTab';
    var TAB_LABEL = 'Configuration';

    var SkyRenderOptionsPanel = function SkyRenderOptionsPanel(viewer, edgeExtension) {
        var _this = this;
        var PANEL_ID = 'oneworkd_edge_renderoptions_panel_' + viewer.id;
        var opts = { heightAdjustment: 90, width: 500 };
        Autodesk.Viewing.UI.SettingsPanel.call(this, viewer.container, PANEL_ID, '天空效果', opts);
        this.setGlobalManager(viewer.globalManager);
        this.container.classList.add('viewer-settings-panel');
        this.viewer = viewer;

        // Add a default tab called Render Options
        this.addTab(TAB_ID, TAB_LABEL, { className: 'config' });
        this.selectTab(TAB_ID);

        // Checkbox "Enabled"
        var enabledToggleId = this.addCheckbox(TAB_ID, '啓用', false, function (checked) {
            edgeExtension.setEnabled(checked);
        });

        this.enabledToggle = this.getControl(enabledToggleId);

        var scaleId = this.addSlider(TAB_ID, '縮放',
            3, 1000, 30,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setScale(parseFloat(value));
            },
            { step: .1 });

        this.scale = this.getControl(scaleId);

        var turbidityId = this.addSlider(TAB_ID, '渾濁度',
            0, 20, 10,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setTurbidity(parseFloat(value));
            },
            { step: .1 });

        this.turbidity = this.getControl(turbidityId);

        var rayleighId = this.addSlider(TAB_ID, '散射',
            0.0, 4.0, 3.0,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setRayleigh(parseFloat(value));
            },
            { step: 0.001 });

        this.rayleigh = this.getControl(rayleighId);

        var mieCoefficientId = this.addSlider(TAB_ID, '米氏散射係數',
            0, 0.1, 0.005,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setMieCoefficient(parseFloat(value));
            },
            { step: .001 });

        this.mieCoefficient = this.getControl(mieCoefficientId);

        var mieDirectionalGId = this.addSlider(TAB_ID, '米氏散射方向性係數',
            0, 1, 0.7,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setMieDirectionalG(parseFloat(value));
            },
            { step: .001 });

        this.mieDirectionalG = this.getControl(mieDirectionalGId);


        const self = this;
        var elevationId = this.addSlider(TAB_ID, '仰角',
            0, 90, 2,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setSunPosition(1, parseFloat(value), parseFloat(self.azimuth.value));
            },
            { step: .1 });

        this.elevation = this.getControl(elevationId);


        var azimuthId = this.addSlider(TAB_ID, '方位角',
            -180, 180, 180,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setSunPosition(1, parseFloat(self.elevation.value), parseFloat(value));
            },
            { step: .1 });

        this.azimuth = this.getControl(azimuthId);
    };

    SkyRenderOptionsPanel.prototype = Object.create(Autodesk.Viewing.UI.SettingsPanel.prototype);
    SkyRenderOptionsPanel.prototype.constructor = SkyRenderOptionsPanel;

    onework.sky.SkyRenderOptionsPanel = SkyRenderOptionsPanel;
})();

(function () {
    class Sky extends THREE.Mesh {

        constructor(viewer) {

            const shader = Sky.SkyShader;

            const material = new THREE.ShaderMaterial({
                name: shader.name,
                uniforms: THREE.UniformsUtils.clone(shader.uniforms),
                vertexShader: shader.vertexShader,
                fragmentShader: shader.fragmentShader,
                side: THREE.BackSide,
                depthWrite: false
            });

            // 這行很重要，不加的話shader跑不動
            material.supportsMrtNormals = true;

            viewer.impl.matman().addMaterial('skyMaterial', material, true);

            super(new THREE.BoxGeometry(1, 1, 1), material);

            this.isSky = true;

        }

    }

    Sky.SkyShader = {

        name: 'SkyShader',

        uniforms: {
            'turbidity': { type: "f", value: 2 },
            'rayleigh': { type: "f", value: 1 },
            'mieCoefficient': { type: "f", value: 0.005 },
            'mieDirectionalG': { type: "f", value: 0.8 },
            'sunPosition': { type: "v3", value: new THREE.Vector3() },
            'upDir': { type: "v3", value: new THREE.Vector3(0, 0, 1) }
        },

        vertexShader: /* glsl */`

            uniform vec3 sunPosition;
		uniform float rayleigh;
		uniform float turbidity;
		uniform float mieCoefficient;
		uniform vec3 upDir;

		varying vec3 vWorldPosition;
		varying vec3 vSunDirection;
        varying vec3 vUpDir;
		varying float vSunfade;
		varying vec3 vBetaR;
		varying vec3 vBetaM;
		varying float vSunE;

		// constants for atmospheric scattering
		const float e = 2.71828182845904523536028747135266249775724709369995957;
		const float pi = 3.141592653589793238462643383279502884197169;

		// wavelength of used primaries, according to preetham
		const vec3 lambda = vec3( 680E-9, 550E-9, 450E-9 );
		// this pre-calcuation replaces older TotalRayleigh(vec3 lambda) function:
		// (8.0 * pow(pi, 3.0) * pow(pow(n, 2.0) - 1.0, 2.0) * (6.0 + 3.0 * pn)) / (3.0 * N * pow(lambda, vec3(4.0)) * (6.0 - 7.0 * pn))
		const vec3 totalRayleigh = vec3( 5.804542996261093E-6, 1.3562911419845635E-5, 3.0265902468824876E-5 );

		// mie stuff
		// K coefficient for the primaries
		const float v = 4.0;
		const vec3 K = vec3( 0.686, 0.678, 0.666 );
		// MieConst = pi * pow( ( 2.0 * pi ) / lambda, vec3( v - 2.0 ) ) * K
		const vec3 MieConst = vec3( 1.8399918514433978E14, 2.7798023919660528E14, 4.0790479543861094E14 );

		// earth shadow hack
		// cutoffAngle = pi / 1.95;
		const float cutoffAngle = 1.6110731556870734;
		const float steepness = 1.5;
		const float EE = 1000.0;

		float sunIntensity( float zenithAngleCos ) {
			zenithAngleCos = clamp( zenithAngleCos, -1.0, 1.0 );
			return EE * max( 0.0, 1.0 - pow( e, -( ( cutoffAngle - acos( zenithAngleCos ) ) / steepness ) ) );
		}

		vec3 totalMie( float T ) {
			float c = ( 0.2 * T ) * 10E-18;
			return 0.434 * c * MieConst;
		}

		void main() {

			vec4 worldPosition = modelMatrix * vec4( position, 1.0 );
			vWorldPosition = worldPosition.xyz;

			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
			gl_Position.z = gl_Position.w; // set z to camera.far

            vUpDir = upDir;
			vSunDirection = normalize( sunPosition );

			vSunE = sunIntensity( dot( vSunDirection, upDir ) );

			vSunfade = 1.0 - clamp( 1.0 - exp( ( sunPosition.y / 450000.0 ) ), 0.0, 1.0 );

			float rayleighCoefficient = rayleigh - ( 1.0 * ( 1.0 - vSunfade ) );

			// extinction (absorbtion + out scattering)
			// rayleigh coefficients
			vBetaR = totalRayleigh * rayleighCoefficient;

			// mie coefficients
			vBetaM = totalMie( turbidity ) * mieCoefficient;

		}
            `,

        fragmentShader: /* glsl */`

        precision mediump float;

        varying vec3 vWorldPosition;
		varying vec3 vSunDirection;
        varying vec3 vUpDir;
		varying float vSunfade;
		varying vec3 vBetaR;
		varying vec3 vBetaM;
		varying float vSunE;

		uniform float mieDirectionalG;

		// constants for atmospheric scattering
		const float pi = 3.141592653589793238462643383279502884197169;

		const float n = 1.0003; // refractive index of air
		const float N = 2.545E25; // number of molecules per unit volume for air at 288.15K and 1013mb (sea level -45 celsius)

		// optical length at zenith for molecules
		const float rayleighZenithLength = 8.4E3;
		const float mieZenithLength = 1.25E3;
		// 66 arc seconds -> degrees, and the cosine of that
		const float sunAngularDiameterCos = 0.999956676946448443553574619906976478926848692873900859324;

		// 3.0 / ( 16.0 * pi )
		const float THREE_OVER_SIXTEENPI = 0.05968310365946075;
		// 1.0 / ( 4.0 * pi )
		const float ONE_OVER_FOURPI = 0.07957747154594767;

		float rayleighPhase( float cosTheta ) {
			return THREE_OVER_SIXTEENPI * ( 1.0 + pow( cosTheta, 2.0 ) );
		}

		float hgPhase( float cosTheta, float g ) {
			float g2 = pow( g, 2.0 );
			float inverse = 1.0 / pow( 1.0 - 2.0 * g * cosTheta + g2, 1.5 );
			return ONE_OVER_FOURPI * ( ( 1.0 - g2 ) * inverse );
		}
        
        #ifdef _LMVWEBGL2_
            #if defined(MRT_NORMALS)
            layout(location = 1) out vec4 outNormal;
            #if defined(MRT_ID_BUFFER)
                layout(location = 2) out vec4 outId;
                #if defined(MODEL_COLOR)
                layout(location = 3) out vec4 outModelId;
                #endif
            #endif
            #elif defined(MRT_ID_BUFFER)
            layout(location = 1) out vec4 outId;
            #if defined(MODEL_COLOR)
                layout(location = 2) out vec4 outModelId;
            #endif
            #endif
        #else
            #define gl_FragColor gl_FragData[0]
            #if defined(MRT_NORMALS)
            #define outNormal gl_FragData[1]
            #if defined(MRT_ID_BUFFER)
                #define outId gl_FragData[2]
                #if defined(MODEL_COLOR)
                #define outModelId gl_FragData[3]
                #endif
            #endif
            #elif defined(MRT_ID_BUFFER)
            #define outId gl_FragData[1]
            #if defined(MODEL_COLOR)
                #define outModelId gl_FragData[2]
            #endif
            #endif
        #endif
        

        vec3 RRTAndODTFit( vec3 v ) {
            vec3 a = v * ( v + 0.0245786 ) - 0.000090537;
            vec3 b = v * ( 0.983729 * v + 0.4329510 ) + 0.238081;
            return a / b;
        }

        vec3 ACESFilmicToneMapping( vec3 color ) {
            float toneMappingExposure = 0.5;
            const mat3 ACESInputMat = mat3(
                vec3( 0.59719, 0.07600, 0.02840 ),vec3( 0.35458, 0.90834, 0.13383 ),
                vec3( 0.04823, 0.01566, 0.83777 )
            );
            const mat3 ACESOutputMat = mat3(
                vec3(  1.60475, -0.10208, -0.00327 ), vec3( -0.53108,  1.10813, -0.07276 ),
                vec3( -0.07367, -0.00605,  1.07602 )
            );
            color *= toneMappingExposure / 0.6;
            color = ACESInputMat * color;
            color = RRTAndODTFit( color );
            color = ACESOutputMat * color;
            return clamp( color, 0.0, 1.0 );
        }






        void main() {

            vec3 direction = normalize( vWorldPosition - cameraPosition );

			// optical length
			// cutoff angle at 90 to avoid singularity in next formula.
            
			float zenithAngle = acos( max( 0.0, dot( vUpDir, direction )));
			float inverse = 1.0 / ( cos( zenithAngle ) + 0.15 * pow( 93.885 - ( ( zenithAngle * 180.0 ) / pi ), -1.253 ) );
			float sR = rayleighZenithLength * inverse;
			float sM = mieZenithLength * inverse;

			// combined extinction factor
			vec3 Fex = exp( -( vBetaR * sR + vBetaM * sM ) );

			// in scattering
			float cosTheta = dot( direction, vSunDirection );

			float rPhase = rayleighPhase( cosTheta * 0.5 + 0.5 );
			vec3 betaRTheta = vBetaR * rPhase;

			float mPhase = hgPhase( cosTheta, mieDirectionalG );
			vec3 betaMTheta = vBetaM * mPhase;

			vec3 Lin = pow( vSunE * ( ( betaRTheta + betaMTheta ) / ( vBetaR + vBetaM ) ) * ( 1.0 - Fex ), vec3( 1.5 ) );
			Lin *= mix( vec3( 1.0 ), pow( vSunE * ( ( betaRTheta + betaMTheta ) / ( vBetaR + vBetaM ) ) * Fex, vec3( 1.0 / 2.0 ) ), clamp( pow( 1.0 - dot( vUpDir, vSunDirection ), 5.0 ), 0.0, 1.0 ) );

			// nightsky
			float theta = acos( direction.y ); // elevation --> y-axis, [-pi/2, pi/2]
			float phi = atan( direction.z, direction.x ); // azimuth --> x-axis [-pi/2, pi/2]
			vec2 uv = vec2( phi, theta ) / vec2( 2.0 * pi, pi ) + vec2( 0.5, 0.0 );
			vec3 L0 = vec3( 0.1 ) * Fex;

			// composition + solar disc
			float sundisk = smoothstep( sunAngularDiameterCos, sunAngularDiameterCos + 0.00002, cosTheta );
			L0 += ( vSunE * 19000.0 * Fex ) * sundisk;

			vec3 texColor = ( Lin + L0 ) * 0.04 + vec3( 0.0, 0.0003, 0.00075 );

			vec3 retColor = pow( texColor, vec3( 1.0 / ( 1.2 + ( 1.2 * vSunfade ) ) ) );

			gl_FragColor = vec4( retColor, 1.0 );

            // toneMapping;
            gl_FragColor.rgb = ACESFilmicToneMapping( gl_FragColor.rgb );


            #ifdef MRT_ID_BUFFER
            outId = vec4(0.0);
            #endif
            #ifdef MODEL_COLOR
            outModelId = vec4(0.0);
            #endif
            #ifdef MRT_NORMALS
            outNormal = vec4(0.0);
            #endif
        }
            
        `

    };

    onework.sky.Sky = Sky;
})();

function SkyExtension(viewer, options) {
    Autodesk.Viewing.Extension.call(this, viewer, options);

    // 記得把openPanel方法的呼叫著綁定在這個類別
    this.openPanel = this.openPanel.bind(this);
}

SkyExtension.prototype = Object.create(Autodesk.Viewing.Extension.prototype);
SkyExtension.prototype.constructor = SkyExtension;

SkyExtension.prototype.load = function () {

    this.firstTime = true;

    // Create UI by default. Panel could be found in the viewer settings panel.
    if (this.options.createUI !== false) {
        this.panel = new onework.sky.SkyRenderOptionsPanel(this.viewer, this);
    }

    // debug
    // this.openPanel();

    return true;
};

SkyExtension.prototype.unload = function () {

    if (this.panel) {
        if (this._configButtonId !== null) {
            this.viewer.viewerSettingsPanel.removeConfigButton(this._configButtonId);
            this._configButtonId = null;
        }

        this.panel.setVisible(false);
        this.panel.destroy();
        this.panel = null;
    }

    return true;
};

SkyExtension.prototype.onToolbarCreated = function () {
    if (this.panel) {
        this._initButtonConfig();
    }
};

SkyExtension.prototype._initButtonConfig = function () {
    var settingsPanel = this.viewer.getSettingsPanel();
    if (!settingsPanel) {
        this.addEventListener(Autodesk.Viewing.SETTINGSpanel_CREATED_EVENT, this._initButtonConfig, { once: true });
        return;
    }
    this._configButtonId = settingsPanel.addConfigButton("天空效果", this.openPanel);
};

SkyExtension.prototype.setEnabled = function (enable) {
    if (enable) {
        this.activate();
    } else {
        this.deactivate();
    }
};

SkyExtension.prototype.openPanel = function () {
    var _this$panel;
    this.setEnabled(true);
    (_this$panel = this.panel) === null || _this$panel === void 0 ? void 0 : _this$panel.setVisible(true);
};

SkyExtension.prototype.setTurbidity = function (value) {
    var _this$panel9;
    this.sky.material.uniforms.turbidity.value = value;
    this.viewer.impl.sceneUpdated(true);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.turbidity.setValue(value);
};

SkyExtension.prototype.setRayleigh = function (value) {
    var _this$panel9;
    this.sky.material.uniforms.rayleigh.value = value;
    this.viewer.impl.sceneUpdated(true);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.rayleigh.setValue(value);
};

SkyExtension.prototype.setMieCoefficient = function (value) {
    var _this$panel9;
    this.sky.material.uniforms.mieCoefficient.value = value;
    this.viewer.impl.sceneUpdated(true);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.mieCoefficient.setValue(value);
};

SkyExtension.prototype.setMieDirectionalG = function (value) {
    var _this$panel9;
    this.sky.material.uniforms.mieDirectionalG.value = value;
    this.viewer.impl.sceneUpdated(true);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.mieDirectionalG.setValue(value);
};

SkyExtension.prototype.setScale = function (value) {
    var _this$panel9;
    this.sky.scale.x = this.sky.scale.y = this.sky.scale.z = value;
    this.viewer.impl.sceneUpdated(true);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.scale.setValue(value);
};

SkyExtension.prototype.setSunPosition = function (radius, elevation, azimuth) {

    const phi = THREE.Math.degToRad(90 - elevation);
    const theta = THREE.Math.degToRad(azimuth);

    const sunPosition = new THREE.Vector3();

    const sinPhiRadius = Math.sin(phi) * radius;
    sunPosition.x = sinPhiRadius * Math.sin(theta);

    // 這裏的z和y決定哪一個是仰角，哪一個是方位角
    sunPosition.z = Math.cos(phi) * radius;
    sunPosition.y = sinPhiRadius * Math.cos(theta);

    var _this$panel9;
    this.sky.material.uniforms.sunPosition.value = sunPosition;
    this.viewer.impl.sceneUpdated(true);

    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.elevation.setValue(elevation);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.azimuth.setValue(azimuth);
};

SkyExtension.prototype.loadDefaultValues = function () {

    if (this.sky != null) return;

    const sky = new onework.sky.Sky(viewer);
    this.viewer.scene.add(sky);

    this.sky = sky;
    
    var defaultTurbidity = parseFloat(Autodesk.Viewing.Private.getParameterByName('turbidity')) || this.options.turbidity || 10.0;
    var defaultrayleight = parseFloat(Autodesk.Viewing.Private.getParameterByName('rayleight')) || this.options.rayleigh || 3.0;
    var defaultMieCoefficient = parseFloat(Autodesk.Viewing.Private.getParameterByName('mieCoefficient')) || this.options.mieCoefficient || 0.005;
    var defaultMieDirectionalG = parseFloat(Autodesk.Viewing.Private.getParameterByName('mieDirectionalG')) || this.options.mieDirectionalG || 0.7;
    var defaultElevation = parseFloat(Autodesk.Viewing.Private.getParameterByName('elevation')) || this.options.elevation || 0.2;
    var defaultAzimuth = parseFloat(Autodesk.Viewing.Private.getParameterByName('azimuth')) || this.options.azimuth || 180;
    var defaultScale = parseFloat(Autodesk.Viewing.Private.getParameterByName('scale')) || this.options.scale || 30;

    this.setTurbidity(defaultTurbidity);
    this.setRayleigh(defaultrayleight);
    this.setMieCoefficient(defaultMieCoefficient);
    this.setMieDirectionalG(defaultMieDirectionalG);
    this.setSunPosition(1, defaultElevation, defaultAzimuth);
    this.setScale(defaultScale);

    this.viewer.impl.sceneUpdated(true);
};

SkyExtension.prototype.activate = function () {
    var _this$panel2;
    // Already active
    if (this.isActive()) {
        return;
    }

    if (this.firstTime) {
        this.firstTime = false;
    }
    this.loadDefaultValues();

    if (this.useCursor && !this.viewer.toolController.isToolActivated(this.tool.getName())) {
        this.viewer.toolController.activateTool(this.tool.getName());
    }

    (_this$panel2 = this.panel) === null || _this$panel2 === void 0 ? void 0 : _this$panel2.enabledToggle.setValue(true);

    this.activeStatus = true;
};

SkyExtension.prototype.deactivate = function () {
    var _this$panel3;
    // Already inactive.
    if (!this.isActive()) {
        return;
    }

    if (this.sky) {
        this.viewer.scene.remove(this.sky);
        this.sky = null;
        this.viewer.impl.sceneUpdated(true);
    }

    if (this.useCursor && this.viewer.toolController.isToolActivated(this.tool.getName())) {
        this.viewer.toolController.deactivateTool(this.tool.getName());
    }

    (_this$panel3 = this.panel) === null || _this$panel3 === void 0 ? void 0 : _this$panel3.enabledToggle.setValue(false);

    this.activeStatus = false;
};

Autodesk.Viewing.theExtensionManager.registerExtension('Onework.Sky', SkyExtension);
