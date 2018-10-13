<?php

$app->on('admin.init', function() use($app){
    
    $this->helper('admin')->addAssets('selectrequestoptions:assets/component.js');
    $this->helper('admin')->addAssets('selectrequestoptions:assets/components/field-select-request-options.tag');
    
});