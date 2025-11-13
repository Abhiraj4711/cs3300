import syntaxtree.*;
import utils.*;

@SuppressWarnings("static-access")
public class P6 {
   public static void main(String [] args) {
      try {
         Node root = new MiniRAParser(System.in).Goal();
         FirstPassVisitor fp = new FirstPassVisitor();
         System.out.println(root.accept(fp, ""));
      }
      catch (ParseException e) {
         System.out.println("Type error");
      }
   }
}