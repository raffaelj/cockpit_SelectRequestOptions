# FieldRequestOptions

Select field with options based on custom requests

Addon for [Cockpit CMS](https://github.com/agentejo/cockpit)

Copy the folder `FieldRequestOptions` to `addons/FieldRequestOptions`

Create a field "Select-Request-Options" in a collection and adjust the field options to your needs (examples below).

The field provides a multipleselect field with options from a request in the form
`App.request(opts.request, opts.options).then(function(data){...});`

**Use case**

* simple select field, that grabs some content from helper collections like categories...
* simple select field for custom helper functions, which provide some structured output
* can replace the default multipleselect field with hard-coded options

**Difference to [collection-link](https://getcockpit.com/documentation/reference/fieldtypes)**

* no population possible
* only values are stored, there is no `_id` relation etc.

## Options

`request` and `value` are mandatory.
The select field expects an array to display correctly.

```json
{
  "request": "/api/cockpit/listUsers?token=xxtokenxx",
  "value":"fieldname"
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
