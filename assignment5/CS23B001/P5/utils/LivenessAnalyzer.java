package utils;

import java.util.*;

public class LivenessAnalyzer {

    public HashSet<BBinfo> allStartingBBs = new HashSet<>();
    public HashSet<BBinfo> allEndingBBs = new HashSet<>();
    public ArrayList<BBinfo> allBBs = new ArrayList<>();
    public ArrayList<Map<Integer, int[]>> liveRanges = new ArrayList<>();

    public void computeLiveness() {
        boolean changed;
        do {
            changed = false;
            for (int i = allBBs.size() - 1; i >= 0; i--) {
                BBinfo bb = allBBs.get(i);

                HashSet<String> oldIn = new HashSet<>(bb.in);
                HashSet<String> oldOut = new HashSet<>(bb.out);
                bb.out.clear();
                for (BBinfo succ : bb.succ) {
                    bb.out.addAll(succ.in);
                }
                HashSet<String> newIn = new HashSet<>(bb.use);
                HashSet<String> outMinusDef = new HashSet<>(bb.out);
                outMinusDef.removeAll(bb.def);
                newIn.addAll(outMinusDef);
                bb.in = newIn;

                if (!bb.in.equals(oldIn) || !bb.out.equals(oldOut)) {
                    changed = true;
                }
            }
        } while (changed);
    }

    public void computeLiveRanges() {
        liveRanges.clear();
        int params = 0;
        TreeMap<Integer, int[]> ranges = null;

        for (int i = 0; i < allBBs.size(); i++) {
            BBinfo bb = allBBs.get(i);
            if (allStartingBBs.contains(bb)) {
                if (ranges != null) {
                    liveRanges.add(ranges);
                }
                ranges = new TreeMap<>();
                params = bb.params;
            }
            for (String var : bb.in) {
                int v = Integer.parseInt(var);
                if (v < params) continue;
                ranges.putIfAbsent(v, new int[]{i + 1, i + 1});
                ranges.get(v)[0] = Math.min(ranges.get(v)[0], i + 1);
                ranges.get(v)[1] = Math.max(ranges.get(v)[1], i + 1);
            }
            for (String var : bb.out) {
                int v = Integer.parseInt(var);
                if (v < params) continue;
                ranges.putIfAbsent(v, new int[]{i + 1, i + 1});
                ranges.get(v)[1] = Math.max(ranges.get(v)[1], i + 1);
            }
        }

        if (ranges != null) {
            liveRanges.add(ranges);
        }
    }
}
