grammar IsiLang;

@header{
	import dataStructures.IsiSymbol;
	import dataStructures.IsiVariable;
	import dataStructures.IsiSymbolTable;
	import exceptions.IsiSemanticException;
	import ast.IsiProgram;
	import ast.AbstractCommand;
	import ast.CommandLeitura;
	import ast.CommandEscrita;
	import ast.CommandAttr;
	import ast.CommandDecisao;
	import ast.CommandLoop;
	import java.util.ArrayList;
	import java.util.Stack;
}

@members{
	private int _tipo;
	private int _tipoLoop;
	private String _varName;
	private String _varValue;
	private IsiSymbolTable symbolTable = new IsiSymbolTable();
	private IsiSymbol symbol;
	private IsiProgram program = new IsiProgram();
	private ArrayList<AbstractCommand> curThread;
	private Stack<ArrayList<AbstractCommand>> stack = new Stack<ArrayList<AbstractCommand>>();
	
	private String _readID;
	private String _writeID;
	private String _exprID;
	private String _exprContent;
	private String _exprDecision;
	private ArrayList<AbstractCommand> listaTrue;
	private ArrayList<AbstractCommand> listaFalse;
	private ArrayList<AbstractCommand> listaLoop;
	
	public void verificaID(String id){
		if (!symbolTable.exists(id)){
			throw new IsiSemanticException("Symbol "+id+" not declared");
		}
	}
	
	public void verificaUso(){
		ArrayList<String> goTime = symbolTable.getAllKeys();
		for (String i : goTime){
			IsiVariable var = (IsiVariable)symbolTable.get(i);
			if (var.getValue() == null){
				throw new IsiSemanticException("Symbol "+i+" declared but not used.");
			}
		}
	}
	
	public void exibeComandos(){
		for (AbstractCommand c: program.getComandos()){
			System.out.println(c);
		}
	}
	
	public void generateCode(){
		program.generateTarget();
	}
}

prog		:	'programa' decl bloco 'fimprog;' 
				{
					program.setVarTable(symbolTable);
					program.setComandos(stack.pop());
					verificaUso();
				}
				
			;

decl		:	(declaravar)*
			;
			
declaravar	:	tipo ID
				{
					_varName = _input.LT(-1).getText();	
					_varValue = null;
					symbol = new IsiVariable(_varName, _tipo, _varValue);
					if (!symbolTable.exists(_varName))
					{
						symbolTable.add(symbol);
					}
					else
					{
						throw new IsiSemanticException("Symbol "+_varName+" already declared");
					}
				}
				(
					VIR
					ID
					{
						_varName = _input.LT(-1).getText();	
						_varValue = null;
						symbol = new IsiVariable(_varName, _tipo, _varValue);
						if (!symbolTable.exists(_varName))
						{
							symbolTable.add(symbol);
						}
						else
						{
							throw new IsiSemanticException("Symbol "+_varName+" already declared");
						}
					}
				)*
				SC
			;
			
tipo		:	'numero' {_tipo = IsiVariable.NUMBER; }
			|	'texto' {_tipo = IsiVariable.TEXT; }
			|	'inteiro' {_tipo = IsiVariable.WHOLE; }
			;

bloco		:	{
					curThread = new ArrayList<AbstractCommand>();
					stack.push(curThread);
			  	}
				(cmd)+
			;

cmd			:	cmdleitura
			|	cmdescrita
			|	cmdattr
			|	cmdselecao
			|	cmdloop
			;

cmdleitura	:	'leia'
				AP
				ID 
				{
					verificaID(_input.LT(-1).getText());
					_readID = _input.LT(-1).getText();
				}
				FP
				SC
				{
					IsiVariable var = (IsiVariable)symbolTable.get(_readID);
					CommandLeitura cmd = new CommandLeitura(_readID, var);
					stack.peek().add(cmd);
				}
			;

cmdescrita	:	'escreva'
				AP
				ID
				{
					verificaID(_input.LT(-1).getText()); 
					_writeID = _input.LT(-1).getText();
				}
				FP
				SC
				{
					IsiVariable var = (IsiVariable)symbolTable.get(_writeID);
					if (var.getValue() == null) var.setValue("SET");
					CommandEscrita cmd = new CommandEscrita(_writeID);
					stack.peek().add(cmd);
				}
			;

cmdattr		: 	ID
				{
					verificaID(_input.LT(-1).getText()); 
					_exprID = _input.LT(-1).getText();
				} 
				ATTR { _exprContent = ""; }
				expr
				SC
				{
					IsiVariable var = (IsiVariable)symbolTable.get(_exprID);
					CommandAttr cmd = new CommandAttr(_exprID, _exprContent);
					stack.peek().add(cmd);
				}
				;

cmdselecao	:	'se'
				AP
				ID
				{
					verificaID(_input.LT(-1).getText()); 
					_exprDecision = _input.LT(-1).getText();
					IsiVariable var = (IsiVariable)symbolTable.get(_exprDecision);
					if (var.getValue() == null) var.setValue("SET");
				} 
				OPREL { _exprDecision += _input.LT(-1).getText(); }
				(ID | NUMBER) { _exprDecision += _input.LT(-1).getText(); }
				FP
				ACH
				{
					curThread = new ArrayList<AbstractCommand>();
					stack.push(curThread);
				}
				cmd+
				FCH
				{
					listaTrue = stack.pop();
				}
				(
					'senao'
					ACH
					{
						curThread = new ArrayList<AbstractCommand>();
						stack.push(curThread);
					}
					cmd+
					FCH 
					{
						listaFalse = stack.pop();
					}
				)?
				{
					CommandDecisao cmd = new CommandDecisao(_exprDecision, listaTrue, listaFalse);
					stack.peek().add(cmd);
				}
			;
			
cmdloop		:	(
					{ _tipoLoop = CommandLoop.WHILE; }
					'enquanto'
					AP
					ID
					{
						verificaID(_input.LT(-1).getText()); 
						_exprDecision = _input.LT(-1).getText();
						IsiVariable var = (IsiVariable)symbolTable.get(_exprDecision);
						if (var.getValue() == null) var.setValue("SET");
					}
					OPREL { _exprDecision += _input.LT(-1).getText(); }
					(ID | NUMBER) { _exprDecision += _input.LT(-1).getText(); }
					FP
					ACH
					{
						curThread = new ArrayList<AbstractCommand>();
						stack.push(curThread);
					}
					cmd+
					FCH
				|	{ _tipoLoop = CommandLoop.DOWHILE; }
					'faca'
					ACH
					{
						curThread = new ArrayList<AbstractCommand>();
						stack.push(curThread);
					}
					cmd+
					FCH
					'enquanto'
					AP
					ID
					{
						verificaID(_input.LT(-1).getText()); 
						_exprDecision = _input.LT(-1).getText();
						IsiVariable var = (IsiVariable)symbolTable.get(_exprDecision);
						if (var.getValue() == null) var.setValue("SET");
					}
					OPREL { _exprDecision += _input.LT(-1).getText(); }
					(ID | NUMBER) { _exprDecision += _input.LT(-1).getText(); }
					FP
					SC
				)
				
				{
					listaLoop = stack.pop();
					CommandLoop cmd = new CommandLoop(_tipoLoop, _exprDecision, listaLoop);
					stack.peek().add(cmd);
				}
			;
				

expr		:	termo
				(
					OP { _exprContent += _input.LT(-1).getText(); }
					termo
				)*
			|	AP { _exprContent += "("; }
				expr
				FP { _exprContent += ")"; }
				(
					OP { _exprContent += _input.LT(-1).getText(); }
					expr
				)?
			;

termo		:	ID
				{
					verificaID(_input.LT(-1).getText());
					_exprContent += _input.LT(-1).getText();
					IsiVariable var = (IsiVariable)symbolTable.get(_input.LT(-1).getText());
					if (var.getValue() == null) var.setValue("SET");
				}
			|	NUMBER { _exprContent += _input.LT(-1).getText(); }
			|	QTE { _exprContent += "\""; } 
				ID  { _exprContent += _input.LT(-1).getText(); } 
				QTE { _exprContent += "\""; } 
			;

AP			:	'(' ;

FP			:	')' ;

SC			: 	';' ;

ATTR		: 	'=' ;

OP			: 	'+' | '-' | '*' | '/'  ;

VIR			: 	',' ;
			
ACH			: 	'{' ;
			
FCH			: 	'}' ;

OPREL		: 	'>' | '<' | '>=' | '<=' | '==' | '!=' ;

ID			: 	[a-z] ([a-z] | [A-Z] | [0-9])* ;

NUMBER		: 	[0-9]+ ('.' [0-9]+)? ;

QTE			:	'"';

WS			: 	(' ' | '\t' | '\n' | '\r') -> skip ;