App.Utils.renderer['select-request-options'] = function(v) {

    if (typeof(v[0]) === 'string') {
        return App.Utils.renderer.tags(v);
    }

    if (typeof(v[0]) === 'object') {

        if (v.length > 5) {
            // don't render too much output
            return App.Utils.renderer.repeater(v);
        }

        var out = '';
        for (k in v) {
            var tags = [];
            for (val in v[k]) {
                if (typeof(v[k][val]) !== 'string') {
                    // don't render nested output
                    return App.Utils.renderer.repeater(v);
                }
                tags.push(v[k][val]);
            }
            out += App.Utils.renderer.tags(tags) + (k < v.length ? ' ' : '');
        }
        return out;
    }
};

<field-select-request-options>
    <div class="{ options.length > 10 ? 'uk-scrollable-box':'' }">
        <div class="uk-margin-small-top" each="{option in options}">
            <a class="{ id(option.value, parent.selected) !==-1 || id(option.value_orig, parent.selected) !==-1 ? 'uk-text-primary':'uk-text-muted' }" onclick="{ parent.toggle }">
                <i class="uk-icon-{ id(option.value, parent.selected) !==-1 || id(option.value_orig, parent.selected) !==-1 ? 'circle':'circle-o' } uk-margin-small-right"></i>
                { option.label }
                <i class="uk-icon-info uk-margin-small-right" title="{ option.info }" data-uk-tooltip if="{ option.info }"></i>
                <i class="uk-icon-warning uk-margin-small-right" title="{ option.warning }" data-uk-tooltip if="{ option.warning }"></i>
            </a>
        </div>
    </div>
    <span class="uk-text-small uk-text-muted" if="{ error_message }">{ error_message }</span>
    <span class="uk-text-small uk-text-muted" if="{ options.length > 10}">{selected.length} { App.i18n.get('selected') }</span>

    <script>

        var $this = this;
        this.selected = [];
        this.options  = [];
        this.error_message  = null;

        this.id = function(needle, haystack) {
            if (typeof(needle) === 'string') {
                return haystack.indexOf(needle);
            }
            for (k in haystack) {
                if (JSON.stringify(needle) == JSON.stringify(haystack[k])) {
                    return parseInt(k);
                }
            }
            return -1;
        }

        this.on('mount', function() {
            App.request(opts.request, opts.options ? opts.options : {}).then(function(data){

                if (data === null) {
                    displayError(data);
                    data = [];
                }
                
                if (typeof(data) === 'object' && !Array.isArray(data) && data.hasOwnProperty(opts.key)) {
                    data = data[opts.key];
                }

                if (Array.isArray(data)) {

                    $this.options = data.map(function(option) {

                        if (typeof(opts.value) === 'object') {
                            var value = {};
                            for (var k in opts.value) {
                                value[k] = option.hasOwnProperty(opts.value[k]) ? option[opts.value[k]] : ''
                            }
                        }

                        option = {
                            value : value ? value : (option.hasOwnProperty(opts.value) ? option[opts.value].toString().trim() : ''),
                            label : (opts.label ? (typeof(option[opts.label]) !== 'undefined' ? option[opts.label].toString().trim() : 'n/a') : option[opts.value].toString().trim()),
                            info  : opts.info ? option[opts.info].toString().trim() : false
                        };

                        return option;
                    });

                    // add current value to options if it is not in the request options list
                    for (s in $this.selected) {

                        if ($this.id($this.selected[s], $this.options.map(function(o){return o.value;})) == -1) {

                            $this.options.push({
                                value_orig: $this.selected[s],
                                label: typeof($this.selected[s]) === 'string' ? $this.selected[s] : (opts.label ? (typeof($this.selected[s][opts.label]) !== 'undefined' ? $this.selected[s][opts.label].toString().trim() : 'n/a') : $this.selected[s][opts.value].toString().trim()),
                                info: App.i18n.get('Original data') + ': ' + (typeof($this.selected[s]) == 'object' ? Object.keys($this.selected[s]).map(function(val){return '<br>' + val + ': ' + JSON.stringify($this.selected[s][val]);}) : JSON.stringify($this.selected[s])),
                                warning: App.i18n.get('Origin or request changed')
                            });

                        }

                    }

                } else {
                    displayError(data);
                }

                $this.update();
            });

        });
        
        function displayError(data) {
            $this.error_message = App.i18n.get('No option available');
            
            console.log('something went wrong...: App.request(\'' + opts.request + (opts.options ? '\', ' + JSON.stringify(opts.options) : '') + ')\r\n', data);
        }

        // seems to have no effect...
        // this.$initBind = function() {
            // this.root.$value = this.selected;
        // };

        this.$updateValue = function(value, field) {

            if (!Array.isArray(value)) {
                value = [];
            }

            if (JSON.stringify(this.selected) != JSON.stringify(value)) {
                this.selected = value;
                this.update();
            }

        }.bind(this);

        toggle(e) {

            var option = e.item.option.value || e.item.option.value_orig,
                index  = this.id(option, this.selected);

            if (opts.multiple) {
                if (index == -1) {
                    this.selected.push(option);
                } else {
                    this.selected.splice(index, 1);
                }
            } else {
                this.selected = index == -1 ? [option] : [];
            }

            this.$setValue(this.selected);
        }

    </script>

</field-select-request-options>
