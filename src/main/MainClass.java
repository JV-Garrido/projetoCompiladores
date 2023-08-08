package main;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import exceptions.IsiSemanticException;
import parser.IsiLangLexer;
import parser.IsiLangParser;

public class MainClass {
	public static void main(String[] args){
		try {
			IsiLangLexer lexer;
			IsiLangParser parser;
			
			lexer = new IsiLangLexer(CharStreams.fromFileName("input.isi"));
			
			CommonTokenStream tokenStream = new CommonTokenStream(lexer);

			parser = new IsiLangParser(tokenStream);

			parser.prog();
			
			System.out.println("SUCCESS");
			
			parser.generateCode();
		}
		catch(IsiSemanticException ex) {
			System.err.println("Semantic Error - "+ ex.getMessage());
		}
		catch (Exception ex) {
			System.err.println("ERROR "+ex.getMessage());
		}
	}

}
