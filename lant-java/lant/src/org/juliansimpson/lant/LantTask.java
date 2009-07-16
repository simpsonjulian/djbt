package org.juliansimpson.lant;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.TaskContainer;

public class LantTask extends Task implements TaskContainer {

	private Project project;

	private HashMap errors;

	public void init() {
	}

	public void addTask(Task arg0) {
		// TODO Auto-generated method stub

	}

	public void execute() {
		processProperties();
		processTargets();
		report();

	}

	private void processProperties() {
		project = super.getProject();
		

	}

	private void processTargets() {
		project = super.getProject();
		Hashtable targets = project.getTargets();
		if (targets == null) {
			handleOutput("no targets found");
		} else {
			Set keys = targets.keySet();
			for (Iterator i = keys.iterator(); i.hasNext();) {
				String targetName = i.next().toString();
				Target target = new Target(targetName);
				if (!target.isValid()) {
					handleError("Target", target + " isn't correctly named");
				}
			}
		}
	}

	private void handleError(String type, String text) {
		errors.put(type, text);
	}

	private void report() {
		if (errors == null) {
			handleOutput("no errors found");
		} else {

			Set keys = errors.keySet();
			for (Iterator i = keys.iterator(); i.hasNext();) {
				handleOutput(errors.get(i).toString());
			}
			throw new BuildException("Ant issues found");

		}

	}
}