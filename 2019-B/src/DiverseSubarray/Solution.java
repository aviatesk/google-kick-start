package DiverseSubarray;

import java.util.*;

public class Solution {

    private static Scanner sc;
    private static int t;        // 1
    private static int N;        // 6
    private static int S;        // 2
    private static int[] A;      // [1, 1, 4, 1, 4, 4]
    private static int[] events; // [1, 1, 1, -2, 1, -2] (when `left` == 0)

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
        S = sc.nextInt();
        A = new int[N];
        for (int i = 0; i < N; i += 1) {
            A[i] = Integer.parseInt(sc.next());
        }
    }

    private static void solve() {
        int best = 0;
        for (int left = 0; left < N; left += 1) {
            updateEvents(left);
            int tmp = 0;
            for (int right = left; right < N; right += 1) {
                tmp += events[right];

                if (best < tmp) {
                    best = tmp;
                }
            }
        }

        System.out.println(String.format("Case #%d: %d", t + 1, best));
    }

    private static void updateEvents(int left) {
        events = new int[N];

        Map<Integer, Integer> map = new HashMap<>(); // Create a temporary map
        for (int i = left; i < N; i += 1) {
            int Ai = A[i];
            int count = map.getOrDefault(Ai, 0) + 1;
            if (count <= S) {
                events[i] = 1;
            } else if (count == S + 1) {
                events[i] = -S;
            } else {
                events[i] = 0;
            }
            map.put(Ai, count); // Update the map
        }
    }

}
