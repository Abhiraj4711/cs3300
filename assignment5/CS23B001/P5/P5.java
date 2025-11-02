import java.util.AbstractMap;
import java.util.Map;
import java.util.HashMap;

import syntaxtree.*;
import utils.*;

@SuppressWarnings("static-access")
public class P5 {
   public static void main(String [] args) {
      try {
         Node root = new microIRParser(System.in).Goal();
         BBinfo start = new BBinfo();
         FirstPassVisitor fp = new FirstPassVisitor();

         root.accept(fp, start);
         for (BBinfo bb : fp.allBBs) {
            bb.use.addAll(bb.def);
         }
         LivenessAnalyzer la = new LivenessAnalyzer();
         la.allBBs = fp.allBBs;
         la.allEndingBBs = fp.allEndingBBs;
         la.allStartingBBs = fp.allStartingBBs;
         la.computeLiveness();
         la.computeLiveRanges();
         Map<AbstractMap.SimpleEntry<Integer, Integer>, AbstractMap.SimpleEntry<Boolean, Integer>> allocationMap = new HashMap<>();
         RegisterAllocation ra = new RegisterAllocation();
         ra.liveRanges = la.liveRanges;
         ra.allocationMap = allocationMap;
         ra.allocate();
         SecondPassVisitor sp = new SecondPassVisitor();
         sp.allocationMap = allocationMap;
         sp.maxParams = fp.maxParams;
         System.out.println(root.accept(sp, ""));
         
      }
      catch (ParseException e) {
         System.out.println("Type error");
      }
   }
}