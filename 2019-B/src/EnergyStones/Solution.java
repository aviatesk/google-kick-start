package EnergyStones;

import java.util.*;

public class Solution {

    private static Scanner sc;
    private static int t;
    private static int N;
    private static int[] S;
    private static int[] E;
    private static int[] L;

    public static void main(String[] args) {
        sc = new Scanner(System.in);
        int T = sc.nextInt();
        for (t = 0; t < T; t += 1) {
            load();
            solve();
        }
    }

    private static void load() {
        N = sc.nextInt();
        S = new int[N];
        E = new int[N];
        L = new int[N];
        for (int i = 0; i < N; i += 1) {
            S[i] = Integer.parseInt(sc.next());
            E[i] = Integer.parseInt(sc.next());
            L[i] = Integer.parseInt(sc.next());
        }
    }

    private static void solve() {
        int bestGain = bestGain();
        System.out.println(String.format("Case #%d: %d", t + 1, bestGain));
    }

    private static int bestGain() {
        int gain = 0;
        for (int i = 0; i < N; i += 1) {
            int item = bestItem();
            if (item > -1) {
                gain += E[item];
                update(item);
            }
        }
        return gain;
    }

    private static int bestItem() {
        int bestItem = -1;
        int maxLose = -1;
        for (int i = 0; i < N; i += 1) {
            if (E[i] <= 0) {
                continue;
            }
            int lose = Integer.min(E[i], S[i] * L[i]);
            if (maxLose < lose && E[i] > 0) {
                maxLose = lose;
                bestItem = i;
            }
        }

        return bestItem;
    }

    private static void update(int item) {
        for (int i = 0; i < N; i += 1) {
            if (E[i] > 0) {
                E[i] -= S[item] * L[i];
            }
        }
    }

}
