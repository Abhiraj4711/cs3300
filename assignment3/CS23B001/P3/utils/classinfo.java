package utils;
import java.util.HashMap;

public class classinfo {
    public String name;
    public HashMap<String, String> vars=new HashMap<>();
    public HashMap<String, String> methods=new HashMap<>();
    public String parent="ThisIsTheFinalClassNoClassAboveThis";
    // if it is the final class, ie it has no parents its parent will be called : ThisIsTheFinalClassNoClassAboveThis
    public void addParentVars(allclasses c) {
        if (!"ThisIsTheFinalClassNoClassAboveThis".equals(parent)) {
            classinfo ci = c.classes.get(parent);
            ci.addParentVars(c);
            ci.vars.forEach((k, v) -> vars.putIfAbsent(k, v));

        }
    }

    public void addParentMethods(allclasses c) {
        if (!"ThisIsTheFinalClassNoClassAboveThis".equals(parent)) {
            classinfo ci = c.classes.get(parent);
            ci.addParentMethods(c);
            
            ci.methods.forEach((k, v) -> {
                String methName = k.substring(k.indexOf("___") + 3);
                if (!methods.containsKey(name + "___" + methName)) {
                    methods.put(k, v);
                }
            });
        }
    }
}
