package BuildPalindromes;

import java.util.*;

public class Solution {

    private static Scanner sc;
    private static int T;
    private static int t;
    private static int N;
    private static int Q;
    private static char[] S;
    private static ArrayList<Map<Character, Integer>> maps;

    private static void load() {
        N = sc.nextInt();
        Q = sc.nextInt();
        String charS = sc.next();
        S = charS.toCharArray();

        Map<Character, Integer> cache = new HashMap<>();
        maps = new ArrayList<>(); // Keeps accumulative counts of chars
        maps.add(new HashMap<>()); // Add an empty map in the head of array
        for (int n = 0; n < N; n += 1) {
            char s = S[n];
            cache.put(s, cache.getOrDefault(s, 0) + 1); // Update the cache

            // Add a map which holds accumulative counts of chars to the array
            Map<Character, Integer> map = new HashMap<>();
            for (char ss : cache.keySet()) {
                map.put(ss, cache.get(ss));
            }
            maps.add(map);
        }
    }

    private static int isPossible() {
        int L = Integer.parseInt(sc.next());
        int R = Integer.parseInt(sc.next());
        boolean firstOdd = false; // Flag to check whether I already allow one odd character
        Map<Character, Integer> lmap = maps.get(L - 1);
        Map<Character, Integer> rmap = maps.get(R);
        for (char s : rmap.keySet()) {
            int nChar = rmap.get(s);
            if (lmap.containsKey(s)) { // Counts the count of the char within the range from L to R
                nChar -= lmap.get(s);
            }

            if (nChar % 2 != 0) {
                if (firstOdd) {
                    return 0;   // Can't make palindrome
                } else {
                    firstOdd = true;
                }
            }
        }
        return 1;               // Can make palindrome
    }

    private static void solve() {
        load();

        int cnt = 0;            // Counts palindrome-possible cases
        for (int q = 0; q < Q; q += 1) {
            cnt += isPossible();
        }
        System.out.println(String.format("Case #%d: %d", t + 1, cnt));
    }

    public static void main(String[] args) {
        sc = new Scanner(System.in);
        T = sc.nextInt();

        for (t = 0; t < T; t += 1) {
            solve();
        }
    }

}
