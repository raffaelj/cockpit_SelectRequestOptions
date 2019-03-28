# SelectRequestOptions

Select field with options based on custom requests

Addon for [Cockpit CMS](https://github.com/agentejo/cockpit)

## Installation

Copy this repository into `/addons` and name it `SelectRequestOptions` or

```bash
cd path/to/cockpit
git clone https://github.com/raffaelj/cockpit_SelectRequestOptions.git addons/SelectRequestOptions
```

## Usage

Create a field "Select-Request-Options" in a collection and adjust the field options to your needs (examples below).

The field provides a (multiple) select field with options from a request in the form
`App.request(opts.request, opts.options).then(function(data){...});`

**Use case**

* simple select field, that grabs some content from helper collections like categories...
* simple select field for custom helper functions, which provide some structured output
* can replace the default select and multipleselect field with hard-coded options

**Difference to [collection-link](https://getcockpit.com/documentation/reference/fieldtypes)**

* no population possible
* only values are stored, there is no `_id` relation etc.

## Options

`request` and `value` are mandatory.
The select field expects an array to display correctly.

```
{
  "request": "/api/cockpit/listUsers?token=xxtokenxx",
  "value":"fieldname",
  "multiple": true    # default: false --> select or multipleselect field
}
```

If you want a different fieldname as label and an optional info icon:

```json
{
  "request": "/api/cockpit/listUsers?token=xxtokenxx",
  "value": "fieldname",
  "label": "fieldname2",
  "info": "fieldname3"
}
```

If the response of your request looks like this

```json
{
  "accounts": [
    {
      "fieldname1" : "value1"
    }
  ],
  "count": 1
}
```

add the key to the options:

```json
{
  "request": "/accounts/find",
  "key": "accounts",
  "value": "_id"
}
```

## Field options examples

**built-in helper functions**

```json
{
  "request": "/collections/find",
  "key": "entries",
  "options": {
    "collection": "pages",
    "options": {
      "fields": {
        "title": "true",
        "_id": "0"
      },
      "limit": "3"
    }
  },
  "label": "title",
  "value": "title"
}
```

```json
{
  "request": "/accounts/find",
  "key": "accounts",
  "label": "name",
  "value": "_id",
  "info": "email"
}
```

```json
{
  "request": "/collections/_find",
  "options": {
    "collection": "products",
    "options": {
      "fields": {
        "image": "0"
      }
    }
  },
  "label": "title",
  "value": "published",
  "info": "tags"
}
```

**value can be an object with mapped keys**

```json
{
  "request": "/collections/find",
  "options": {
    "collection": "pages"
  },
  "key": "entries",
  "label": "title",
  "value": {
    "name": "title",
    "description": "content",
    "index": "_id"
  },
  "multiple": true
}
```

Notice: To adjust/restrict the output of the built-in helpers, have a look at
https://github.com/raffaelj/cockpit-scripts/blob/master/restrict-built-in-helpers/bootstrap.php

**api**

```json
{
  "request": "/api/cockpit/listUsers?token=xxtokenxx",
  "value":"user"
}
```

```json
{
  "request": "/api/cockpit/assets",
  "key": "assets",
  "options":{
    "token":"xxtokenxx"
  },
  "value": "_id",
  "label": "title",
  "info": "mime"
}
```

Notice: To adjust/restrict the output of `listUsers`, have a look at
https://github.com/raffaelj/cockpit-scripts/blob/master/custom-api-endpoints/listUsers.php

**create a custom request**

```php
$app->on('admin.init', function(){
    $this->bind('/custom', function(){
        return [
            ['name' => 'Alice', 'location' => 'Wonderland'],
            ['name' => 'Dorothy', 'location' => 'Oz']
        ];
    });
});
```

```json
{
  "request": "/custom",
  "value":"location",
  "label":"name"
}
```

## Changelog

**2019-03-28**

* added new option `renderer_display` if you use e. g. che color field rendere, but want to store a different value than the hex value

**2018-10-21**

* added renderer to display pretty select options, example: `"renderer": "color"`
* added experimental option to pass options and to display nested riot tag instead of default, option: `"display_field": "tags"`

**2018-10-20**

* added `multiple` option, default: `"multiple": false`

**2018-10-19**

* improved entries view renderer
* display existing data, that is not part of the request as option with a warning
* values can now be arrays of objects, only arrays of single values were possible before