package org.juliansimpson.lant;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;

import org.apache.tools.ant.Project;

public class NameEvaluator {
		
	public NameEvaluator(Project project, AntObject object) {
		super();
		this.project = project;
		this.type = object;
	}

	public Project project;
	public String type;
	private Hashtable objects;
	
	public ArrayList evaluate() {
		if ("properties" == type) {
			
			objects = project.getProperties();
			
		} else if ("targets" == type ) {
			
			objects = project.getTargets();
			
		}
		if (objects == null) {
			return null;
		} else {

			Set keys = objects.keySet();

			for (Iterator i = keys.iterator(); i.hasNext();) {
				String objectName = (String) i.next();
				if ("properties" == type) {
					
					Property instance = new Property(objectName, objects.get(i.next()).toString());
				} else if ("targets" == type) {
					Target instance = new Target(objectName, objects.get(i.next().toString()));
				}
				if (!instance.isValid()) {
					//handleError(type, propertyName + " is not valid");
				}
			}
		}
		
	}

}
