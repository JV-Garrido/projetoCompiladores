package ast;

public class CommandAttr extends AbstractCommand{

	private String id;
	private String expr;
	
	public CommandAttr(String id, String expr) {
		this.id = id;
		this.expr = expr;
	}
	
	@Override
	public String generateJavaCode() {
		// TODO Auto-generated method stub
		return id + " = "+expr+";";
	}

	@Override
	public String toString() {
		return "CommandAttr [id=" + id + ", expr=" + expr + "]";
	}

}
