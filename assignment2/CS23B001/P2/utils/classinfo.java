package utils;
import java.util.HashMap;

public class classinfo {
    public String name;
    public HashMap<String, String> vars=new HashMap<>();
    public HashMap<String, String> methods=new HashMap<>();
    public String parent="ThisIsTheFinalClassNoClassAboveThis";
    // if it is the final class, ie it has no parents its parent will be called : ThisIsTheFinalClassNoClassAboveThis
}
