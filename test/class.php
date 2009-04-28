<?php
    require_once 'some_other_file.php';

	test
    /**
     * TestClass
     *
     * Test Class to verify correct syntax highlighting of various
     * php elements
     * 
     * @author Derek Reynolds <derekr@me.com>
     */
    abstract class TestClass extends ExtendedClassName implements ImplementedClassName
    {
    	const NAME = 'test';
    	
    	public $varName = null;
    	
    	public function __construct($var, $var2 = null)
    	{
    	    // code
    	}
    	
    	static public function customFunction($var, $var2 = null)
    	{
    	    if ( 'string' == $var) 
    	    {
    	        echo 'hey';
    	    }
    	    count(count('count' /**/, [int mode]), [int mode])
    	    array
    	    (
    	        'test', // comment
    	    )
    	    
    	    implode(string glue, array pieces);
    	    
    	    myFakeFunction();
    	    
    	    header(string header, [bool replace], [int http_response_code]);
    	    
    	    isset();

    	}
    	

    }