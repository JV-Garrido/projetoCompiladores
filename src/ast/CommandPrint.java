package ast;

public class CommandPrint extends AbstractCommand {

	private String id;
	
	public CommandPrint(String id) {
		this.id = id;
	}
	
	@Override
	public String generateJavaCode() {
		// TODO Auto-generated method stub
		return "System.out.println(\""+id+"\");";
	}

	@Override
	public String toString() {
		return "CommandEscrita [id=" + id + "]";
	}

}