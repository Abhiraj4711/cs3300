package utils;
import java.util.*;

@SuppressWarnings("FieldMayBeFinal")
public class RegisterAllocation {

    private static final String[] REGISTERS = {
        "s0","s1","s2","s3","s4","s5","s6","s7",
        "t0","t1","t2","t3","t4","t5","t6","t7","t8","t9"
    };
    private static final int R = REGISTERS.length;

    // Input: variable → [start, end] for all live ranges
    public ArrayList<Map<Integer, int[]>> liveRanges;

    // Output: ((temp, line) → (isSpilled, indexOfRegOrSpill))
    public Map<AbstractMap.SimpleEntry<Integer,Integer>, AbstractMap.SimpleEntry<Boolean,Integer>> allocationMap = new HashMap<>();

    // Internal
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

    /** Simple linear scan: expire old intervals, if no reg left → spill current. */
    public void allocate() {
        // Merge all live ranges into one list
        intervals.clear();
        if (liveRanges != null) {
            for (Map<Integer, int[]> lr : liveRanges) {
                for (var e : lr.entrySet()) {
                    intervals.add(new Interval(e.getKey(), e.getValue()[0], e.getValue()[1]));
                }
            }
        }

        // Sort by start time
        intervals.sort(Comparator.comparingInt(i -> i.start));

        // Initialize
        active.clear();
        allocationMap.clear();
        nextSpill = 0;
        freeRegisters.clear();
        for (int i = R - 1; i >= 0; i--) freeRegisters.push(i);

        // Linear scan
        for (Interval cur : intervals) {
            expireOldIntervals(cur);

            if (freeRegisters.isEmpty()) {
                // Spill current
                cur.spilled = true;
                cur.spillIndex = nextSpill++;
            } else {
                // Assign a free register
                cur.reg = freeRegisters.pop();
                cur.spilled = false;
                insertActive(cur);
            }

            // Fill allocation map for all lines in its range
            int mapped = cur.spilled ? cur.spillIndex : cur.reg;
            for (int line = cur.start; line <= cur.end; line++) {
                allocationMap.put(
                    new AbstractMap.SimpleEntry<>(cur.var, line),
                    new AbstractMap.SimpleEntry<>(cur.spilled, mapped)
                );
            }
        }
    }

    /** Expire intervals that ended before current starts. */
    private void expireOldIntervals(Interval current) {
        active.sort(Comparator.comparingInt(i -> i.end));
        Iterator<Interval> it = active.iterator();
        while (it.hasNext()) {
            Interval j = it.next();
            if (j.end >= current.start) break;
            it.remove();
            if (j.reg >= 0) freeRegisters.push(j.reg);
        }
    }

    /** Keep active sorted by end time. */
    private void insertActive(Interval i) {
        int pos = 0;
        while (pos < active.size() && active.get(pos).end < i.end) pos++;
        active.add(pos, i);
    }

    public void printAllocations() {
        allocationMap.entrySet().stream()
            .sorted(Comparator.<Map.Entry<
                AbstractMap.SimpleEntry<Integer,Integer>,
                AbstractMap.SimpleEntry<Boolean,Integer>>>
                comparingInt(e -> e.getKey().getKey())
                .thenComparingInt(e -> e.getKey().getValue()))
            .forEach(e -> {
                var key = e.getKey();
                var val = e.getValue();
                String res = val.getKey()
                        ? "SPILL[" + val.getValue() + "]"
                        : REGISTERS[val.getValue()];
                System.out.printf("T%-3d @ line %-3d → %s%n",
                        key.getKey(), key.getValue(), res);
            });
    }
}
