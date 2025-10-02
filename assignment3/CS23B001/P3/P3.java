import syntaxtree.*;
import visitor.*;
import utils.*;

public class P3 {
   public static void main(String [] args) {
      try {
         Node root = new MiniJavaParser(System.in).Goal();

         FirstPassVisitor fp = new FirstPassVisitor();
         allclasses ac=new allclasses();
         root.accept(fp, ac);

         for (String className : ac.classes.keySet()) {
            classinfo ci = ac.classes.get(className);
            ci.addParentMethods(ac);
            ci.addParentVars(ac);
         }
         SecondPassVisitor<String> sp = new SecondPassVisitor<>();
         sp.ac = ac;
         System.out.println(root.accept(sp,""));
      }
      catch (ParseException e) {
         System.out.println("Type error");
      }
   }
}