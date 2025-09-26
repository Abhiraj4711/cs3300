import syntaxtree.*;
import visitor.*;
import utils.*;

public class P2 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();

         FirstPassVisitor v = new FirstPassVisitor();
         allclasses ac=new allclasses();
         root.accept(v, ac);
         try {
            SecondPassVisitor v2 = new SecondPassVisitor();
            root.accept(v2, ac);
         } catch (RuntimeException e) {
            System.out.println(e.toString().substring("java.lang.RuntimeException: ".length()));
         }
      }
      catch (ParseException e) {
         System.out.println("Type error");
      }
   }
}