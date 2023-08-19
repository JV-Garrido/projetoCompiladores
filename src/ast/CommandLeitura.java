package ast;

import dataStructures.IsiVariable;

public class CommandLeitura extends AbstractCommand {
	
	private String _helpReservadaNaoUsar;
	private String id;
	private IsiVariable var;
	
	public CommandLeitura (String id, IsiVariable var) {
		this.id = id;
		this.var = var;
	}
	
	@Override
	public String generateJavaCode() {
		return id + " = _key." + (var.getType() == IsiVariable.NUMBER? "nextDouble(); _helpReservadaNaoUsar = _key.nextLine();": (var.getType() == IsiVariable.TEXT? "nextLine();": "nextInt(); _helpReservadaNaoUsar = _key.nextLine();"));
	}

	@Override
	public String toString() {
		return "CommandLeitura [id=" + id + "]";
	}
}
