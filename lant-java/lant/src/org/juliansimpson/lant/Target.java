package org.juliansimpson.lant;

public class Target extends AntObject {
	public String name;
	public Target (String name) {
		this.name = name;
		
	}
	
	public Target(String objectName, Object object) {
		// TODO Auto-generated constructor stub
	}

	public boolean isValid() {
		if (name.matches("\\w+\\..*")) {
			return false;
			
		}
		
		
			else {
				
				return true;
			}
			
		}
	}
	

