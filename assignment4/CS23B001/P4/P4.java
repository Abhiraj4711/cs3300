import syntaxtree.*;
import visitor.*;
import utils.*;

public class P4 {
   public static void main(String [] args) {
      try {
         Node root = new MiniIRParser(System.in).Goal();

         FirstPassVisitor fp = new FirstPassVisitor();

         System.out.println(root.accept(fp, ""));
      }
      catch (ParseException e) {
         System.out.println("Type error");
      }
   }
}