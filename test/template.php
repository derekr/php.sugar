<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<?php
    $var = 'test';
    require_once 'test';
    require_once('test');
?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head profile="http://www.w3.org/2006/03/hcard">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        
        <title>Title</title>
        
    </head>
    
    <body>
        <div id="container" <?php echo 'test'; ?> class="<?= $var; ?>">
            
        </div> <!-- end container -->
    <?php count(mixed var, [int mode]); ?>
    </body>
    
</html>