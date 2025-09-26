// Content for 'my-awesome-extension.js'

var onework = onework || {};
onework.bloom = {};

(function () {
    var freeGlobal = typeof global == 'object' && global && global.Object === Object && global;
    onework.bloom.freeGlobal = freeGlobal;
})();

(function () {

    var freeGlobal = onework.bloom.freeGlobal;

    /** Detect free variable `self`. */
    var freeSelf = typeof self == 'object' && self && self.Object === Object && self;

    /** Used as a reference to the global object. */
    var root = freeGlobal || freeSelf || Function('return this')();

    onework.bloom.root = root;
})();

(function () {
    var root = onework.bloom.root;

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

    onework.bloom.now = now;
})();

(function () {
    function isObject(value) {
        var type = typeof value;
        return value != null && (type == 'object' || type == 'function');
    }
    onework.bloom.isObject = isObject;
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

    onework.bloom.trimmedEndIndex = trimmedEndIndex;
})();

(function () {
    var trimmedEndIndex = onework.bloom.trimmedEndIndex;

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
    onework.bloom.baseTrim = baseTrim;
})();

(function () {
    var root = onework.bloom.root;

    /** Built-in value references. */
    var Symbol = root.Symbol;
    onework.bloom.Symbol = Symbol;
})();

(function () {
    var Symbol = onework.bloom.Symbol;

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
    onework.bloom.getRawTag = getRawTag;
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

    onework.bloom.objectToString = objectToString;
})();

(function () {
    var Symbol = onework.bloom.Symbol,
        getRawTag = onework.bloom.getRawTag,
        objectToString = onework.bloom.objectToStrin;

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
    onework.bloom.baseGetTag = baseGetTag;
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
    onework.bloom.isObjectLike = isObjectLike;
})();

(function () {
    var baseGetTag = onework.bloom.baseGetTag,
        isObjectLike = onework.bloom.isObjectLike;

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

    onework.bloom.isSymbol = isSymbol;
})();

(function () {
    var baseTrim = onework.bloom.baseTrim,
        isObject = onework.bloom.isObject,
        isSymbol = onework.bloom.isSymbol;

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
    onework.bloom.toNumber = toNumber;
})();

(function () {
    var isObject = onework.bloom.isObject,
        now = onework.bloom.now,
        toNumber = onework.bloom.toNumber;

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

    onework.bloom.debounce = debounce;
})();

(function () {
    var ShaderPass = Autodesk.Viewing.Private.ShaderPass;
    var RenderContextPostProcessExtension = Autodesk.Viewing.Private.RenderContextPostProcessExtension;

    var av = Autodesk.Viewing;

    var BloomRenderContext = function BloomRenderContext(renderContext, viewer) {
        RenderContextPostProcessExtension.call(this, renderContext, viewer);

        // Make sure to render Bloom before other post processing passes.
        this.getOrder = function () {
            return 0;
        };

        // This flag is needed in order to render the Bloom pass only after the selection overlay has been rendered - it looks a lot better.
        this.shouldRenderAfterOverlays = function () {
            return true;
        };

        this.load = function () {
            this.postProcPass = new ShaderPass(onework.bloom.BloomShader);
            this.renderContext.setNoDepthNoBlend(this.postProcPass);
        };
    };

    BloomRenderContext.prototype = Object.create(RenderContextPostProcessExtension.prototype);
    BloomRenderContext.prototype.constructor = BloomRenderContext;
    av.GlobalManagerMixin.call(BloomRenderContext.prototype);

    onework.bloom.BloomRenderContext = BloomRenderContext;
})();

(function () {
    var debounce = onework.bloom.debounce,
        isObject = onework.bloom.isObject;

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

    onework.bloom.throttle = throttle;
})();

(function () {

    function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } } function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; } var throttle = onework.bloom.throttle;

    var GlobalManagerMixin = Autodesk.Viewing.GlobalManagerMixin;

    var AnimDuration = 0.25; // s
    var ThrottleDuration = 100; // ms

    const BloomTool = /*#__PURE__*/function () {
        function BloomTool(viewer, bloomExtension) {
            var _this = this; _classCallCheck(this, BloomTool);
            this.viewer = viewer;
            this.bloomExtension = bloomExtension;

            // Is tool active.
            this.active = false;

            // Tool name.
            this.names = ["bloom-tool"];

            this.lastMousePos = new THREE.Vector2();

            this.onCameraChange = this.onCameraChange.bind(this);

            this.updateFocalPlaneThrottled = throttle(function (targetFocalPlane) {
                if (_this.anim) {
                    _this.anim.stop();
                    _this.anim = null;
                }

                var startValue = _this.bloomExtension.getFocalPlane();

                _this.anim = Autodesk.Viewing.Private.fadeValue(startValue, targetFocalPlane, AnimDuration, function (value) {
                    _this.bloomExtension.setFocalPlane(value);
                }, function () {
                    _this.anim = null;
                });
            }, ThrottleDuration);
        } _createClass(BloomTool, [{
            key: "getNames", value: function getNames() {
                return this.names;
            }
        }, {
            key: "getName", value: function getName() {
                return this.names[0];
            }
        }, {
            key: "getPriority", value: function getPriority() {
                return 1000;
            }
        }, {
            key: "isActive", value: function isActive() {
                return this.active;
            }
        }, {
            key: "activate", value: function activate() {
                if (this.isActive()) {
                    return;
                }

                this.viewer.addEventListener(Autodesk.Viewing.CAMERA_CHANGE_EVENT, this.onCameraChange);

                this.active = true;
            }
        }, {
            key: "deactivate", value: function deactivate() {
                if (!this.isActive()) {
                    return;
                }

                this.viewer.removeEventListener(Autodesk.Viewing.CAMERA_CHANGE_EVENT, this.onCameraChange);

                if (this.anim) {
                    this.anim.stop();
                    this.anim = null;
                }

                this.active = false;
            }

            // In case that the camera moved and the mouse didn't (bimwalk / wheel) - update.
        }, {
            key: "onCameraChange", value: function onCameraChange() {
                return this.handleMouseMove({ canvasX: this.lastMousePos.x, canvasY: this.lastMousePos.y });
            }
        }, {
            key: "handleMouseMove", value: function handleMouseMove(

                event) {
                this.lastMousePos.set(event.canvasX, event.canvasY);

                var result = this.viewer.impl.snappingHitTest(event.canvasX, event.canvasY);
                var cameraPos = this.viewer.getCamera().position;

                var target = result === null || result === void 0 ? void 0 : result.intersectPoint;

                if (!target) {
                    return false;
                }

                var targetFocalPlane = cameraPos.distanceTo(target) * this.viewer.impl.renderer().getUnitScale();

                this.updateFocalPlaneThrottled(targetFocalPlane);

                // don't consume event
                return false;
            }
        }]); return BloomTool;
    }();

    GlobalManagerMixin.call(BloomTool.prototype);
    onework.bloom.BloomTool = BloomTool;
})();

(function () {

    var TAB_ID = 'configTab';
    var TAB_LABEL = 'Configuration';

    var BloomRenderOptionsPanel = function BloomRenderOptionsPanel(viewer, bloomExtension) {
        var _this = this;
        var PANEL_ID = 'oneworkd_bloom_renderoptions_panel_' + viewer.id;
        var opts = { heightAdjustment: 90, width: 500 };
        Autodesk.Viewing.UI.SettingsPanel.call(this, viewer.container, PANEL_ID, '光暈效果', opts);
        this.setGlobalManager(viewer.globalManager);
        this.container.classList.add('viewer-settings-panel');
        this.viewer = viewer;

        // Add a default tab called Render Options
        this.addTab(TAB_ID, TAB_LABEL, { className: 'config' });
        this.selectTab(TAB_ID);

        // Checkbox "Enabled"
        var enabledToggleId = this.addCheckbox(TAB_ID, '啓用', false, function (checked) {
            bloomExtension.setEnabled(checked);
        });

        this.enabledToggle = this.getControl(enabledToggleId);

        this.viewer.addEventListener(Autodesk.Viewing.CAMERA_CHANGE_EVENT, function () {
            var value = parseFloat(_this.blurQuality.value);
            _this.blurQuality.setValue(value);
        });

        var blurRadiusId = this.addSlider(TAB_ID, '模糊半徑',
            1.0, 50.0, 3.0,
            function (event) {
                var value = event.detail.value;
                bloomExtension.setBlurRadius(parseFloat(value));
            },
            { step: 0.1 });

        this.blurRadius = this.getControl(blurRadiusId);

        var blurSizeId = this.addSlider(TAB_ID, '模糊品質',
            1, 16, 4,
            function (event) {
                var value = event.detail.value;
                bloomExtension.setBlurQuality(value);
            },
            { step: 1 });

        this.blurQuality = this.getControl(blurSizeId);

        var powerId = this.addSlider(TAB_ID, '光暈强度',
            0, 10, 1,
            function (event) {
                var value = event.detail.value;
                bloomExtension.setPower(parseFloat(value));
            },
            { step: .1 });

        this.power = this.getControl(powerId);

        var blurRangeId = this.addSlider(TAB_ID, '光暈範圍',
            .1, 10.0, 1.0,
            function (event) {
                var value = event.detail.value;
                bloomExtension.setBlurRange(parseFloat(value));
            },
            { step: 0.1 });

        this.blurRange = this.getControl(blurRangeId);
    };

    BloomRenderOptionsPanel.prototype = Object.create(Autodesk.Viewing.UI.SettingsPanel.prototype);
    BloomRenderOptionsPanel.prototype.constructor = BloomRenderOptionsPanel;

    onework.bloom.BloomRenderOptionsPanel = BloomRenderOptionsPanel;
})();

(function () {

    const screen_quad_uv_vert = "varying vec2 vUv;\nvoid main() {\n    vUv = uv;\n    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\n}\n";
    const bloom_frag_glsl = `
uniform sampler2D tDiffuse;
varying vec2 vUv;
uniform vec2 resolution;
uniform vec3 cameraPos;
uniform float unitScale;
uniform float blurRadius;
uniform float blurRange;
uniform float power;
#include<depth_texture>
#define TAU 6.28318530718
#define DIRECTIONS 16.
float COC = 0.03;

vec4 gaussianBlur(float blurAmount) {
    vec4 color=texture2D(tDiffuse,vUv);
    float quality = float(BLUR_QUALITY);
    float radius = 8. * blurAmount;
    for(float d = 0.; d < DIRECTIONS; d++)
    {
        float angle= d * TAU / DIRECTIONS;
        vec2 angleVec = vec2(cos(angle),sin(angle));
        for(int i = 1; i <= BLUR_QUALITY; i++)
        {
            float distance = radius * (float(i) / quality);
            color += texture2D(tDiffuse, vUv.xy + angleVec * resolution * distance );
        }
    }
    
    color /= quality * DIRECTIONS;
    return color;
}
void main() {
    vec4 oriColor = texture2D(tDiffuse,vUv);
    vec4 blurColor = gaussianBlur(blurRadius);

    blurColor.r = pow(blurColor.r, blurRange);
    blurColor.g = pow(blurColor.g, blurRange);
    blurColor.b = pow(blurColor.b, blurRange);
    gl_FragColor = oriColor + blurColor * power;
}
`;

    var DepthTextureUniforms = {
        "tDepth": { type: "t", value: null },
        "projInfo": { type: "v4", value: new THREE["Vector4"]() },
        "isOrtho": { type: "f", value: 0.0 },
        "worldMatrix_mainPass": { type: "m4", value: new THREE["Matrix4"]() }
    };

    var BloomShader = {
        uniforms: THREE["UniformsUtils"].merge([
            DepthTextureUniforms,
            {
                tDiffuse: { type: "t", value: null },
                resolution: { type: "v2", value: new THREE["Vector2"](1 / 1024, 1 / 512) },
                cameraNear: { type: "f", value: 1 },
                cameraFar: { type: "f", value: 100 },
                unitScale: { type: "f", value: 1.0 }, // conversion from model units to meters.
                cameraPos: { type: "v3", value: new THREE["Vector3"]() },
                blurRadius: { type: "f", value: 3.0 },
                blurRange: { type: "f", value: 1.0 },
                power: { type: "f", value: 1.0 }
            }]),

        vertexShader: screen_quad_uv_vert,
        fragmentShader: bloom_frag_glsl
    };

    onework.bloom.BloomShader = BloomShader;
})();

function BloomExtension(viewer, options) {
    Autodesk.Viewing.Extension.call(this, viewer, options);

    // 記得把openPanel方法的呼叫著綁定在這個類別
    this.openPanel = this.openPanel.bind(this);
}

BloomExtension.prototype = Object.create(Autodesk.Viewing.Extension.prototype);
BloomExtension.prototype.constructor = BloomExtension;

BloomExtension.prototype.load = function () {
    this.bloomRenderContext = new onework.bloom.BloomRenderContext(this.viewer.impl.renderer(), this.viewer);
    this.bloomRenderContext.load();
    this.viewer.impl.renderer().postShadingManager().registerPostProcessingExtension(this.bloomRenderContext);

    this.tool = new onework.bloom.BloomTool(this.viewer, this);
    this.viewer.toolController.registerTool(this.tool);

    this.firstTime = true;

    // Create UI by default. Panel could be found in the viewer settings panel.
    if (this.options.createUI !== false) {
        this.panel = new onework.bloom.BloomRenderOptionsPanel(this.viewer, this);
    }

    // debug
    // this.openPanel();

    return true;
};

BloomExtension.prototype.unload = function () {

    if (this.bloomRenderContext) {
        this.viewer.impl.renderer().postShadingManager().removePostProcessingExtension(this.bloomRenderContext);
        this.viewer.impl.invalidate(true, true, true);
        this.bloomRenderContext = null;
    }

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

BloomExtension.prototype.onToolbarCreated = function () {
    if (this.panel) {
        this._initButtonConfig();
    }
};

BloomExtension.prototype._initButtonConfig = function () {
    var settingsPanel = this.viewer.getSettingsPanel();
    if (!settingsPanel) {
        this.addEventListener(Autodesk.Viewing.SETTINGSpanel_CREATED_EVENT, this._initButtonConfig, { once: true });
        return;
    }
    this._configButtonId = settingsPanel.addConfigButton("光暈效果", this.openPanel);
};

BloomExtension.prototype.setEnabled = function (enable) {
    if (enable) {
        this.activate();
    } else {
        this.deactivate();
    }
};

BloomExtension.prototype.openPanel = function () {
    var _this$panel;
    this.setEnabled(true);
    (_this$panel = this.panel) === null || _this$panel === void 0 ? void 0 : _this$panel.setVisible(true);
};

BloomExtension.prototype.setBlurQuality = function (value) {
    var _this$panel9;
    this.bloomRenderContext.updateDefineValue("BLUR_QUALITY", value);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.blurQuality.setValue(value);
};

BloomExtension.prototype.setBlurRadius = function (value) {
    var _this$panel9;
    this.bloomRenderContext.updateUniformValue("blurRadius", value);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.blurRadius.setValue(value);
};

BloomExtension.prototype.setPower = function (value) {
    var _this$panel9;
    this.bloomRenderContext.updateUniformValue("power", value);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.power.setValue(value);
};

BloomExtension.prototype.setBlurRange = function (value) {
    var _this$panel9;
    this.bloomRenderContext.updateUniformValue("blurRange", value);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.blurRange.setValue(value);
};

BloomExtension.prototype.loadDefaultValues = function () {
    var defaultPower = parseFloat(Autodesk.Viewing.Private.getParameterByName('power')) || this.options.power || 1.0;
    var defaultBlurRadius = parseFloat(Autodesk.Viewing.Private.getParameterByName('blurRadius')) || this.options.blurRadius || 3.0;
    var defaultBlurRange = parseFloat(Autodesk.Viewing.Private.getParameterByName('blurRange')) || this.options.blurRange || 1.0;
    var defaultBlurQuality = parseFloat(Autodesk.Viewing.Private.getParameterByName('blurQuality')) || this.options.blurQuality || 4.0;

    this.setBlurRadius(defaultBlurRadius);
    this.setPower(defaultPower);
    this.setBlurRange(defaultBlurRange);
    this.setBlurQuality(defaultBlurQuality);
};

BloomExtension.prototype.activate = function () {
    var _this$panel2;
    // Already active
    if (this.isActive()) {
        return;
    }

    if (this.firstTime) {
        this.firstTime = false;

        this.loadDefaultValues();
    }

    this.bloomRenderContext.enable();

    if (this.useCursor && !this.viewer.toolController.isToolActivated(this.tool.getName())) {
        this.viewer.toolController.activateTool(this.tool.getName());
    }

    (_this$panel2 = this.panel) === null || _this$panel2 === void 0 ? void 0 : _this$panel2.enabledToggle.setValue(true);

    this.activeStatus = true;
};

BloomExtension.prototype.deactivate = function () {
    var _this$panel3;
    // Already inactive.
    if (!this.isActive()) {
        return;
    }

    this.bloomRenderContext.disable();

    if (this.useCursor && this.viewer.toolController.isToolActivated(this.tool.getName())) {
        this.viewer.toolController.deactivateTool(this.tool.getName());
    }

    (_this$panel3 = this.panel) === null || _this$panel3 === void 0 ? void 0 : _this$panel3.enabledToggle.setValue(false);

    this.activeStatus = false;
};

Autodesk.Viewing.theExtensionManager.registerExtension('Onework.Bloom', BloomExtension);
