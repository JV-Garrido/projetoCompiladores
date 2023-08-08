package dataStructures;

public class IsiVariable extends IsiSymbol{
	public static final int NUMBER = 0;
	public static final int TEXT = 1;
	public static final int WHOLE = 2;
	
	private int type;
	private String value;
	
	public IsiVariable(String name, int type, String value){
		super(name);
		this.setType(type);
		this.setValue(value);
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		if (this.value == null) {
			this.value = value;
		}else {
			this.value += value;
		}
	}

	@Override
	public String toString() {
		return "IsiVariable [name=" + name + ", type=" + type + ", value=" + value + "]";
	}
	
	public String generateJavaCode() {
		String str; 
		if (type == NUMBER) {
			str = "double";
		}
		else
		if (type == TEXT){
			str = "String";
		}else {
			str = "int";
		}
		return str + " "+super.name+";";
	}
	
}
