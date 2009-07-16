package org.juliansimpson.lant;

import org.apache.tools.ant.Project;

import junit.framework.TestCase;

public class LantTaskTest extends TestCase {
	
	public void testCanDoAnything() {
		
		Project project = new Project();
		project.setProperty("foo", "bar");
	}

}
