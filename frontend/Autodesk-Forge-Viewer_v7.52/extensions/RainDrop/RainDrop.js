// Content for 'my-awesome-extension.js'

var onework = onework || {};
onework.raindrop = {};

(function () {
    var freeGlobal = typeof global == 'object' && global && global.Object === Object && global;
    onework.raindrop.freeGlobal = freeGlobal;
})();

(function () {

    var freeGlobal = onework.raindrop.freeGlobal;

    /** Detect free variable `self`. */
    var freeSelf = typeof self == 'object' && self && self.Object === Object && self;

    /** Used as a reference to the global object. */
    var root = freeGlobal || freeSelf || Function('return this')();

    onework.raindrop.root = root;
})();

(function () {
    var root = onework.raindrop.root;

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

    onework.raindrop.now = now;
})();

(function () {
    function isObject(value) {
        var type = typeof value;
        return value != null && (type == 'object' || type == 'function');
    }
    onework.raindrop.isObject = isObject;
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

    onework.raindrop.trimmedEndIndex = trimmedEndIndex;
})();

(function () {
    var trimmedEndIndex = onework.raindrop.trimmedEndIndex;

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
    onework.raindrop.baseTrim = baseTrim;
})();

(function () {
    var root = onework.raindrop.root;

    /** Built-in value references. */
    var Symbol = root.Symbol;
    onework.raindrop.Symbol = Symbol;
})();

(function () {
    var Symbol = onework.raindrop.Symbol;

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
    onework.raindrop.getRawTag = getRawTag;
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

    onework.raindrop.objectToString = objectToString;
})();

(function () {
    var Symbol = onework.raindrop.Symbol,
        getRawTag = onework.raindrop.getRawTag,
        objectToString = onework.raindrop.objectToStrin;

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
    onework.raindrop.baseGetTag = baseGetTag;
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
    onework.raindrop.isObjectLike = isObjectLike;
})();

(function () {
    var baseGetTag = onework.raindrop.baseGetTag,
        isObjectLike = onework.raindrop.isObjectLike;

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

    onework.raindrop.isSymbol = isSymbol;
})();

(function () {
    var baseTrim = onework.raindrop.baseTrim,
        isObject = onework.raindrop.isObject,
        isSymbol = onework.raindrop.isSymbol;

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
    onework.raindrop.toNumber = toNumber;
})();

(function () {
    var isObject = onework.raindrop.isObject,
        now = onework.raindrop.now,
        toNumber = onework.raindrop.toNumber;

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

    onework.raindrop.debounce = debounce;
})();

(function () {
    var ShaderPass = Autodesk.Viewing.Private.ShaderPass;
    var RenderContextPostProcessExtension = Autodesk.Viewing.Private.RenderContextPostProcessExtension;

    var av = Autodesk.Viewing;

    var EdgeRenderContext = function EdgeRenderContext(renderContext, viewer) {
        RenderContextPostProcessExtension.call(this, renderContext, viewer);

        // Make sure to render Edge before other post processing passes.
        this.getOrder = function () {
            return 0;
        };

        // This flag is needed in order to render the Edge pass only after the selection overlay has been rendered - it looks a lot better.
        this.shouldRenderAfterOverlays = function () {
            return true;
        };

        this.load = function () {
            this.postProcPass = new ShaderPass(onework.raindrop.EdgeShader);
            this.renderContext.setNoDepthNoBlend(this.postProcPass);
        };
    };

    EdgeRenderContext.prototype = Object.create(RenderContextPostProcessExtension.prototype);
    EdgeRenderContext.prototype.constructor = EdgeRenderContext;
    av.GlobalManagerMixin.call(EdgeRenderContext.prototype);

    onework.raindrop.EdgeRenderContext = EdgeRenderContext;
})();

(function () {
    var debounce = onework.raindrop.debounce,
        isObject = onework.raindrop.isObject;

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

    onework.raindrop.throttle = throttle;
})();

(function () {

    function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } } function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; } var throttle = onework.raindrop.throttle;

    var GlobalManagerMixin = Autodesk.Viewing.GlobalManagerMixin;

    var AnimDuration = 0.25; // s
    var ThrottleDuration = 100; // ms

    const EdgeTool = /*#__PURE__*/function () {
        function EdgeTool(viewer, edgeExtension) {
            var _this = this; _classCallCheck(this, EdgeTool);
            this.viewer = viewer;
            this.edgeExtension = edgeExtension;

            // Is tool active.
            this.active = false;

            // Tool name.
            this.names = ["edge-tool"];

            this.lastMousePos = new THREE.Vector2();

            this.onCameraChange = this.onCameraChange.bind(this);

            this.updateFocalPlaneThrottled = throttle(function (targetFocalPlane) {
                if (_this.anim) {
                    _this.anim.stop();
                    _this.anim = null;
                }

                var startValue = _this.edgeExtension.getFocalPlane();

                _this.anim = Autodesk.Viewing.Private.fadeValue(startValue, targetFocalPlane, AnimDuration, function (value) {
                    _this.edgeExtension.setFocalPlane(value);
                }, function () {
                    _this.anim = null;
                });
            }, ThrottleDuration);
        } _createClass(EdgeTool, [{
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
        }]); return EdgeTool;
    }();

    GlobalManagerMixin.call(EdgeTool.prototype);
    onework.raindrop.EdgeTool = EdgeTool;
})();

(function () {

    var TAB_ID = 'configTab';
    var TAB_LABEL = 'Configuration';

    var EdgeRenderOptionsPanel = function EdgeRenderOptionsPanel(viewer, edgeExtension) {
        var _this = this;
        var PANEL_ID = 'oneworkd_edge_renderoptions_panel_' + viewer.id;
        var opts = { heightAdjustment: 90, width: 500 };
        Autodesk.Viewing.UI.SettingsPanel.call(this, viewer.container, PANEL_ID, '窗前雨點', opts);
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

        // this.viewer.addEventListener(Autodesk.Viewing.CAMERA_CHANGE_EVENT, function () {
        //     var value = parseFloat(_this.blurQuality.value);
        //     _this.blurQuality.setValue(value);
        // });

        var dropSizeId = this.addSlider(TAB_ID, '水珠大小',
            0, 2, 1,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setDropSize(parseFloat(value));
            },
            { step: .1 });

        this.dropSize = this.getControl(dropSizeId);

        var rainResolutionXId = this.addSlider(TAB_ID, '雨點密度X',
            .5, 3, 1,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setRainResolutionX(parseFloat(value));
            },
            { step: .1 });

        this.rainResolutionX = this.getControl(rainResolutionXId);

        var rainResolutionYId = this.addSlider(TAB_ID, '雨點密度Y',
            1, 3, 1,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setRainResolutionY(parseFloat(value));
            },
            { step: .1 });

        this.rainResolutionY = this.getControl(rainResolutionYId);

        var blurRadiusId = this.addSlider(TAB_ID, '模糊半徑',
            0, 64, 32,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setBlurRadius(parseFloat(value));
            },
            { step: .1 });

        this.blurRadius = this.getControl(blurRadiusId);

        var blurQualityId = this.addSlider(TAB_ID, '模糊品質',
            1, 8, 4,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setBlurQuality(parseFloat(value));
            },
            { step: 1 });

        this.blurQuality = this.getControl(blurQualityId);

        var blurDirectionsId = this.addSlider(TAB_ID, '模糊方向',
            4, 32, 16,
            function (event) {
                var value = event.detail.value;
                edgeExtension.setBlurDirections(parseFloat(value));
            },
            { step: 1 });

        this.blurDirections = this.getControl(blurDirectionsId);

    };

    EdgeRenderOptionsPanel.prototype = Object.create(Autodesk.Viewing.UI.SettingsPanel.prototype);
    EdgeRenderOptionsPanel.prototype.constructor = EdgeRenderOptionsPanel;

    onework.raindrop.EdgeRenderOptionsPanel = EdgeRenderOptionsPanel;
})();

(function () {

    const screen_quad_uv_vert = "varying vec2 vUv;\nvoid main() {\n    vUv = uv;\n    gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );\n}\n";
    const edge_frag_glsl = `
uniform sampler2D tDiffuse;
varying vec2 vUv;
uniform vec2 resolution;
uniform vec3 cameraPos;
uniform float time;
uniform vec2 rainResolution;
uniform float dropSize;
uniform vec4 blurParams;

vec3 N13(float p) {
    //  from DAVE HOSKINS
    vec3 p3 = fract(vec3(p) * vec3(.1031,.11369,.13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract(vec3((p3.x + p3.y)*p3.z, (p3.x+p3.z)*p3.y, (p3.y+p3.z)*p3.x));
}

vec4 N14(float t) {
    return fract(sin(t*vec4(123., 1024., 1456., 264.))*vec4(6547., 345., 8799., 1564.));
}
float N(float t) {
    return fract(sin(t*12345.564)*7658.76);
}

float Saw(float b, float t) {
    return smoothstep(0., b, t)*smoothstep(1., b, t);
}

vec2 Drops(vec2 uv, float t) {
    float size = 0.1 * dropSize;
    vec2 UV = uv;
    
    // DEFINE GRID
    uv.y += t*0.8;
    vec2 a = vec2(6., 1.) * rainResolution;
    vec2 grid = a*2.;
    vec2 id = floor(uv*grid);

    // RANDOM SHIFT Y
    float colShift = N(id.x); 
    uv.y += colShift;
    
    // DEFINE SPACES
    id = floor(uv*grid);
    vec3 n = N13(id.x*35.2+id.y*2376.1);
    vec2 st = fract(uv*grid)-vec2(.5, 0);

    // POSITION DROPS
    //clamp(2*x,0,2)+clamp(1-x*.5, -1.5, .5)+1.5-2
    float x = n.x-.5;
    
    float y = UV.y*20.;
    
    float distort = sin(y+sin(y));
    x += distort*(.5-abs(x))*(n.z-.5);
    x *= .7;
    float ti = fract(t+n.z);
    y = (Saw(.85, ti)-.5)*.9+.5;
    vec2 p = vec2(x, y);

    // DROPS
    float d = length((st-p)*a.yx);
    
    float dSize = size; 
    
    float Drop = smoothstep(dSize, .0, d);
    
    
    float r = sqrt(smoothstep(1., y, st.y));
    float cd = abs(st.x-x);

    // TRAILS
    float trail = smoothstep((dSize*.5+.03)*r, (dSize*.5-.05)*r, cd);
    float trailFront = smoothstep(-.02, .02, st.y-y);
    trail *= trailFront;
    
    // DROPLETS
    y = UV.y;
    y += N(id.x);
    float trail2 = smoothstep(dSize*r, .0, cd);
    float droplets = max(0., (sin(y*(1.-y)*120.)-st.y))*trail2*trailFront*n.z;
    y = fract(y*10.)+(st.y-.5);
    float dd = length(st-vec2(x, y));
    droplets = smoothstep(dSize*N(id.x), 0., dd);
    float m = Drop+droplets*r*trailFront;

    return vec2(m, trail);
}

float StaticDrops(vec2 uv, float t) {
    float size = 0.1;
	uv *= 30.;
    
    vec2 id = floor(uv);
    uv = fract(uv)-.5;
    vec3 n = N13(id.x*107.45+id.y*3543.654);
    vec2 p = (n.xy-.5)*0.5;
    float d = length(uv-p);
    
    float fade = Saw(.025, fract(t+n.z));
    float c = smoothstep(size, 0., d)*fract(n.z*10.)*fade;

    return c;
}

vec2 Rain(vec2 uv, float t) {
    float s = StaticDrops(uv, t); 
    vec2 r1 = Drops(uv, t);
    vec2 r2 = Drops(uv*1.8, t);
    
    float c = s+r1.x+r2.x;
    
    c = smoothstep(.3, 1., c);
    
    return vec2(c, max(r1.y, r2.y));
}

void main() {
    vec2 iResolution = vec2(1280.0, 720.0);
    vec2 fragCoord = iResolution * vUv;

    vec2 uv = (fragCoord.xy-.5*iResolution.xy) / iResolution.y;
    
    vec2 UV = vUv;
    float T = time;
    
    float t = T*.2;
    
    float rainAmount = 0.8;

    UV = (UV-.5)*(.9)+.5;
    
    vec2 c = Rain(uv, t);

   	vec2 e = vec2(.001, 0.); //pixel offset
   	float cx = Rain(uv+e, t).x;
   	float cy = Rain(uv+e.yx, t).x;
   	vec2 n = vec2(cx-c.x, cy-c.x); //normals

    
    float Pi = 6.28318530718; // Pi*2

    float Directions = blurParams.x; // BLUR DIRECTIONS (Default 16.0 - More is better but slower)
    float Quality = blurParams.y; // BLUR QUALITY (Default 4.0 - More is better but slower)
    float Size = blurParams.z; // BLUR SIZE (Radius)
    vec2 Radius = Size/vec2(1280.0, 960.0);

    vec3 col = texture2D(tDiffuse, UV).rgb;
    // Blur calculations
    for( float d=0.0; d<Pi; d+=Pi/Directions)
    {
        for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality)
        {
            vec3 tex = texture2D( tDiffuse, UV+n+vec2(cos(d),sin(d))*Radius*i).rgb;

            col += tex;            
        }
    }

    col /= Quality * Directions - 0.0;

    vec3 tex = texture2D( tDiffuse, UV+n).rgb;
    c.y = clamp(c.y, 0.0, 1.);

    col -= c.y;
    col += c.y*(tex+.6);

    gl_FragColor = vec4(col, 1.0);
}
`;

    var DepthTextureUniforms = {
        "tDepth": { type: "t", value: null },
        "projInfo": { type: "v4", value: new THREE["Vector4"]() },
        "isOrtho": { type: "f", value: 0.0 },
        "worldMatrix_mainPass": { type: "m4", value: new THREE["Matrix4"]() }
    };

    var EdgeShader = {
        uniforms: THREE["UniformsUtils"].merge([
            DepthTextureUniforms,
            {
                tDiffuse: { type: "t", value: null },
                resolution: { type: "v2", value: new THREE["Vector2"](1 / 1024, 1 / 512) },
                cameraNear: { type: "f", value: 1 },
                cameraFar: { type: "f", value: 100 },
                unitScale: { type: "f", value: 1.0 }, // conversion from model units to meters.
                cameraPos: { type: "v3", value: new THREE["Vector3"]() },
                rainResolution: { type: "v2", value: new THREE["Vector2"](1, 1) },
                blurParams: { type: "v4", value: new THREE["Vector4"](16, 4, 32, 1) },
                dropSize: { type: "f", value: 1 },
                time: { type: "f", value: 0 },
            }]),

        vertexShader: screen_quad_uv_vert,
        fragmentShader: edge_frag_glsl
    };

    onework.raindrop.EdgeShader = EdgeShader;
})();

function RaindropExtension(viewer, options) {
    Autodesk.Viewing.Extension.call(this, viewer, options);

    // 記得把openPanel方法的呼叫著綁定在這個類別
    this.openPanel = this.openPanel.bind(this);
    this.animate = this.animate.bind(this);

    this.rainResolutionValue = new THREE.Vector2(1, 1);
    this.blurParamsValue = new THREE.Vector4(16, 4, 32, 1);
}

RaindropExtension.prototype = Object.create(Autodesk.Viewing.Extension.prototype);
RaindropExtension.prototype.constructor = RaindropExtension;

RaindropExtension.prototype.load = function () {
    this.edgeRenderContext = new onework.raindrop.EdgeRenderContext(this.viewer.impl.renderer(), this.viewer);
    this.edgeRenderContext.load();
    this.viewer.impl.renderer().postShadingManager().registerPostProcessingExtension(this.edgeRenderContext);

    this.tool = new onework.raindrop.EdgeTool(this.viewer, this);
    this.viewer.toolController.registerTool(this.tool);

    this.firstTime = true;
    this.time = 0;

    // Create UI by default. Panel could be found in the viewer settings panel.
    if (this.options.createUI !== false) {
        this.panel = new onework.raindrop.EdgeRenderOptionsPanel(this.viewer, this);
    }

    // debug
    // this.openPanel();

    return true;
};

RaindropExtension.prototype.animate = function () {
    requestAnimationFrame(this.animate);

    // 更新时间变量
    this.time++;

    this.setTime(this.time * .05);

    // 通知 Forge Viewer 场景需要更新
    this.viewer.impl.invalidate(true, true, true);
}

RaindropExtension.prototype.unload = function () {

    if (this.edgeRenderContext) {
        this.viewer.impl.renderer().postShadingManager().removePostProcessingExtension(this.edgeRenderContext);
        this.viewer.impl.invalidate(true, true, true);
        this.edgeRenderContext = null;
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

RaindropExtension.prototype.onToolbarCreated = function () {
    if (this.panel) {
        this._initButtonConfig();
    }
};

RaindropExtension.prototype._initButtonConfig = function () {
    var settingsPanel = this.viewer.getSettingsPanel();
    if (!settingsPanel) {
        this.addEventListener(Autodesk.Viewing.SETTINGSpanel_CREATED_EVENT, this._initButtonConfig, { once: true });
        return;
    }
    this._configButtonId = settingsPanel.addConfigButton("窗前雨點", this.openPanel);
};

RaindropExtension.prototype.setEnabled = function (enable) {
    if (enable) {
        this.activate();
    } else {
        this.deactivate();
    }
};

RaindropExtension.prototype.openPanel = function () {
    var _this$panel;
    this.setEnabled(true);
    (_this$panel = this.panel) === null || _this$panel === void 0 ? void 0 : _this$panel.setVisible(true);
};

RaindropExtension.prototype.setTime = function (value) {
    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("time", value);
};

RaindropExtension.prototype.setDropSize = function (value) {
    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("dropSize", value);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.dropSize.setValue(value);
};

RaindropExtension.prototype.setRainResolutionX = function (value) {
    this.rainResolutionValue.x = value;

    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("rainResolution", this.rainResolutionValue);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.rainResolutionX.setValue(value);
};

RaindropExtension.prototype.setRainResolutionY = function (value) {
    this.rainResolutionValue.y = value;

    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("rainResolution", this.rainResolutionValue);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.rainResolutionY.setValue(value);
};

RaindropExtension.prototype.setBlurDirections = function (value) {
    this.blurParamsValue.x = value;

    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("blurParams", this.blurParamsValue);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.blurDirections.setValue(value);
};

RaindropExtension.prototype.setBlurQuality = function (value) {
    this.blurParamsValue.y = value;

    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("blurParams", this.blurParamsValue);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.blurQuality.setValue(value);
};

RaindropExtension.prototype.setBlurRadius = function (value) {
    this.blurParamsValue.z = value;

    var _this$panel9;
    this.edgeRenderContext.updateUniformValue("blurParams", this.blurParamsValue);
    (_this$panel9 = this.panel) === null || _this$panel9 === void 0 ? void 0 : _this$panel9.blurRadius.setValue(value);
};

RaindropExtension.prototype.loadDefaultValues = function () {
    this.setDropSize(parseFloat(Autodesk.Viewing.Private.getParameterByName('dropSize')) || this.options.dropSize || 1.0);
    this.setRainResolutionX(parseFloat(Autodesk.Viewing.Private.getParameterByName('rainResolutionX')) || this.options.rainResolutionX || 1.0);
    this.setRainResolutionY(parseFloat(Autodesk.Viewing.Private.getParameterByName('rainResolutionY')) || this.options.rainResolutionY || 1.0);
    this.setBlurRadius(parseFloat(Autodesk.Viewing.Private.getParameterByName('blurRadius')) || this.options.blurRadius || 32.0);
    this.setBlurDirections(parseFloat(Autodesk.Viewing.Private.getParameterByName('blurDirections')) || this.options.blurDirections || 16.0);
    this.setBlurQuality(parseFloat(Autodesk.Viewing.Private.getParameterByName('blurQuality')) || this.options.blurQuality || 8.0);
};

RaindropExtension.prototype.activate = function () {
    var _this$panel2;
    // Already active
    if (this.isActive()) {
        return;
    }

    if (this.firstTime) {
        this.firstTime = false;
        this.animate();
        this.loadDefaultValues();
    }

    this.edgeRenderContext.enable();

    if (this.useCursor && !this.viewer.toolController.isToolActivated(this.tool.getName())) {
        this.viewer.toolController.activateTool(this.tool.getName());
    }

    (_this$panel2 = this.panel) === null || _this$panel2 === void 0 ? void 0 : _this$panel2.enabledToggle.setValue(true);

    this.activeStatus = true;
};

RaindropExtension.prototype.deactivate = function () {
    var _this$panel3;
    // Already inactive.
    if (!this.isActive()) {
        return;
    }

    this.edgeRenderContext.disable();

    if (this.useCursor && this.viewer.toolController.isToolActivated(this.tool.getName())) {
        this.viewer.toolController.deactivateTool(this.tool.getName());
    }

    (_this$panel3 = this.panel) === null || _this$panel3 === void 0 ? void 0 : _this$panel3.enabledToggle.setValue(false);

    this.activeStatus = false;
};

Autodesk.Viewing.theExtensionManager.registerExtension('Onework.Raindrop', RaindropExtension);
