package org.juliansimpson.lant;

import junit.framework.TestCase;

public class PropertyTest extends TestCase {
	
	public void testThatUnderscoresFail() {
		AntObject property = new Property("foo_bar", "baz");
		assertFalse(property.isValid());
	}
	
	public void testThatDotsPass() {
		AntObject property = new Property("foo.bar", "baz");
		assertTrue(property.isValid());
	}
	
	public void testThatPlainWordsPass() {
		AntObject property = new Property("foobar", "baz");
		assertTrue(property.isValid());
	}

}
