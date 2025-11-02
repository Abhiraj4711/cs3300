package utils;
import java.util.*;

@SuppressWarnings("FieldMayBeFinal")
public class RegisterAllocation {

    private String[] REGISTERS = {
        "s0","s1","s2","s3","s4","s5","s6","s7",
        "t0","t1","t2","t3","t4","t5","t6","t7","t8","t9"
    };
    private int R = REGISTERS.length;

    public ArrayList<Map<Integer, int[]>> liveRanges;

    public Map<AbstractMap.SimpleEntry<Integer,Integer>, AbstractMap.SimpleEntry<Boolean,Integer>> allocationMap = new HashMap<>();

    private List<Interval> intervals = new ArrayList<>();
    private List<Interval> active = new ArrayList<>();
    private Stack<Integer> freeRegisters = new Stack<>();
    private int nextSpill = 0;

    private static class Interval {
        int var;
        int start, end;
        int reg = -1;
        boolean spilled = false;
        int spillIndex = -1;

        Interval(int var, int start, int end) {
            this.var = var;
            this.start = start;
            this.end = end;
        }
    }

    public void allocate() {
        intervals.clear();
        if (liveRanges != null) {
            for (Map<Integer, int[]> lr : liveRanges) {
                for (var e : lr.entrySet()) {
                    intervals.add(new Interval(e.getKey(), e.getValue()[0], e.getValue()[1]));
                }
            }
        }
        intervals.sort(Comparator.comparingInt(i -> i.start));
        active.clear();
        allocationMap.clear();
        nextSpill = 20;
        freeRegisters.clear();
        for (int i = R - 1; i >= 0; i--) 
        {
            freeRegisters.push(i);
        }
        for (Interval cur : intervals) 
        {
            expireOldIntervals(cur);

            if (freeRegisters.isEmpty()) 
            {
                cur.spilled = true;
                cur.spillIndex = nextSpill++;
            } else {
                cur.reg = freeRegisters.pop();
                cur.spilled = false;
                insertActive(cur);
            }
            int mapped = cur.spilled ? cur.spillIndex : cur.reg;
            for (int line = cur.start; line <= cur.end; line++) {
                allocationMap.put(
                    new AbstractMap.SimpleEntry<>(cur.var, line),
                    new AbstractMap.SimpleEntry<>(cur.spilled, mapped)
                );
            }
        }
    }

    private void expireOldIntervals(Interval current) {
        active.sort(Comparator.comparingInt(i -> i.end));
        Iterator<Interval> it = active.iterator();
        while (it.hasNext()) {
            Interval j = it.next();
            if (j.end >= current.start)
                break;
            it.remove();
            if (j.reg >= 0)
                freeRegisters.push(j.reg);
        }
    }
    
    private void insertActive(Interval i) {
        int pos = 0;
        while (pos < active.size() && active.get(pos).end < i.end) pos++;
        active.add(pos, i);
    }
}
