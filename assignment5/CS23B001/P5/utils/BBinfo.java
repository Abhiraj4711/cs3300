package utils;

import java.util.HashSet;
import java.util.Map;
import java.util.TreeMap;

public class BBinfo {
    public int params = 0; //if bb is a procedure, this will store the number of params of the function
    public HashSet<String> use = new HashSet<>();
    public HashSet<String> def = new HashSet<>();
    public HashSet<String> out = new HashSet<>();
    public HashSet<String> in = new HashSet<>();
    public HashSet<BBinfo> succ = new HashSet<>();
    public Map<Integer, int[]> liveRanges = new TreeMap<>();
}
