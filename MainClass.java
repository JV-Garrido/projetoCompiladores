import java.util.Scanner;
public class MainClass{ 
	public static void main(String[] args){ 
		Scanner _key = new Scanner(System.in);
double a = 0;
double b = 0;
double c = 0;
double d = 0;
System.out.println("Programa_Teste");
System.out.println("Digite_A");
a = _key.nextDouble();
System.out.println("Digite_B_ou_4");
b = _key.nextDouble();
d = 3;
while (a<b) {
System.out.println(a);a = a*(5+2);d = d+1;}

c = a+b;
do {
b = b+1;d = d+1;System.out.println(b);}
while (b<c);

System.out.println("C_e_igual_a_");
System.out.println(c);
System.out.println("Total_de_Iteracoes");
System.out.println(d);
	}
}
