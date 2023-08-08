package ast;

import java.util.ArrayList;

public class CommandLoop extends AbstractCommand{
	public static final int WHILE = 0;
	public static final int DOWHILE = 1;
	
	private int type;
	private String condition;
	private ArrayList<AbstractCommand> listaLoop;
	
	public CommandLoop(int type, String condition, ArrayList<AbstractCommand> ll) {
		this.type = type;
		this.condition = condition;
		this.listaLoop = ll;
	}
	
	@Override
	public String generateJavaCode(){
		
		StringBuilder str = new StringBuilder();
		
		if(type == WHILE) {
			str.append("while ("+condition+") {\n");
			for (AbstractCommand cmd: listaLoop) {
				str.append(cmd.generateJavaCode());
			}
			str.append("}\n");
		} else {
			str.append("do {\n");
			for (AbstractCommand cmd: listaLoop) {
				str.append(cmd.generateJavaCode());
			}
			str.append("}\n");
			str.append("while ("+condition+");\n");
		}
		
		return str.toString();
		
	}

	@Override
	public String toString() {
		return "CommandLoop [condition=" + condition + ", listaLoop=" + listaLoop + "]";
	}
}
