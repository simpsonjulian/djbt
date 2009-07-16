package org.juliansimpson.lant;

public class Property extends AntObject {
	String name;

	String value;

	public Property(String name, String value) {
		this.name = name;
		this.value = value;
	}

	public boolean isValid() {

		if (name.matches("\\w+_.*")) {
			return false;

		} else if (name.matches("[\\w\\.]+")) {
			return true;

		} else {
			return false;
		}

	}
}
