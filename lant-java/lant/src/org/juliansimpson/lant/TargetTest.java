package org.juliansimpson.lant;


import junit.framework.TestCase;

public class TargetTest extends TestCase {
	
	public void testTargetsWithDotsFail() {
		Target target = new Target("foo.bar");
		assertFalse(target.isValid());
	}
	
	public void testTargetsWithPlainNamesPass ()  {
		Target target = new  Target("foo");
		assertTrue(target.isValid());
	}
	
	public void testTargetsWithUnderscoresPass() {
		Target target = new  Target("foo_bar");
		assertTrue(target.isValid());
		
	}

}
