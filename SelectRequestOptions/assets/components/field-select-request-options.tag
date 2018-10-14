App.Utils.renderer['select-request-options'] = function(v) {
    return App.Utils.renderer.multipleselect(v);
};

<field-select-request-options>
    <div class="{ options.length > 10 ? 'uk-scrollable-box':'' }">
        <div class="uk-margin-small-top" each="{option in options}">
            <a data-value="{ option.value }" class="{ parent.selected.indexOf(option.value)!==-1 ? 'uk-text-primary':'uk-text-muted' }" onclick="{ parent.toggle }">
                <i class="uk-icon-{ parent.selected.indexOf(option.value)!==-1 ? 'circle':'circle-o' } uk-margin-small-right"></i>
                { option.label }
                <i class="uk-icon-info uk-margin-small-right" title="{ option.info }" data-uk-tooltip if="{ option.info }"></i>
            </a>
        </div>
    </div>
    <a class="uk-text-muted" href="{ App.base(opts.modify_path) }" title="{ App.i18n.get('Add Entry') }" data-uk-tooltip data-uk-lightbox data-lightbox-type="iframe" if="{ opts.modify_path }">
        <i class="uk-icon-plus uk-margin-small-right"></i>
        ...
    </a>
    <span class="uk-text-small uk-text-muted" if="{ options.length > 10}">{selected.length} { App.i18n.get('selected') }</span>

    <script>

        var $this = this;

        this.selected = [];
        this.options  = [];

        this.on('mount', function() {

            $this.request();

        });

        this.$initBind = function() {
            this.root.$value = this.selected;
        };

        this.$updateValue = function(value, field) {

            if (!Array.isArray(value)) {
                value = [];
            }

            if (JSON.stringify(this.selected) != JSON.stringify(value)) {
                this.selected = value;
                this.update();
            }

        }.bind(this);
        
        request(e) {

            App.request(opts.request, opts.options ? opts.options : {}).then(function(data){

                if (typeof(data) === 'object' && !Array.isArray(data) && data.hasOwnProperty(opts.key)) {
                    
                    data = data[opts.key];
                    
                }

                if (Array.isArray(data)) {

                    $this.options = data.map(function(option) {
                        option = {
                            value : (option.hasOwnProperty(opts.value) ? option[opts.value].toString().trim() : ''),
                            label : (opts.label ? (typeof(option[opts.label]) !== 'undefined' ? option[opts.label].toString().trim() : 'n/a') : option[opts.value].toString().trim()),
                            info  : opts.info ? option[opts.info].toString().trim() : false
                        };
                        return option;
                    });

                } else {
                    console.log('something went wrong...: App.request(\'' + opts.request + (opts.options ? ', ' + JSON.stringify(opts.options) : '') + '\')\r\n', data);
                }

                $this.update();
            });

        }

        toggle(e) {

            var option = e.item.option.value,
                index  = this.selected.indexOf(option);

            if (index == -1) {
                this.selected.push(option);
            } else {
                this.selected.splice(index, 1);
            }

            this.$setValue(this.selected);
        }

    </script>

</field-select-request-options>