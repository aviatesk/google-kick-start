package CircuitBoard;

import java.util.*;

public class Solution {

    private static Scanner sc;
    private static int t;
    private static int R;
    private static int C;
    private static int K;
    private static int[][] V;

    public static void main(String[] args) {
        sc = new Scanner(System.in);
        int T = sc.nextInt();
        for (t = 0; t < T; t += 1) {
            load();
            solve();
        }
    }

    private static void load() {
        R = sc.nextInt();
        C = sc.nextInt();
        K = sc.nextInt();
        V = new int[R][C];
        for (int r = 0; r < R; r += 1) {
            for (int c = 0; c < C; c += 1) {
                V[r][c] = Integer.parseInt(sc.next());
            }
        }
    }

    private static void solve() {
        int[] numGoods = new int[C * (C + 1) / 2];
        int max = Integer.MIN_VALUE;

        for (int row = 0; row < R; row += 1) {
            int[] diff2Right = makeDiff(row);
            update(numGoods, diff2Right);

            int tmpMax = Integer.MIN_VALUE;
            for (int numGood : numGoods) {
                if (tmpMax < numGood) {
                    tmpMax = numGood;
                }
            }

            if (max < tmpMax) {
                max = tmpMax;
            }
        }

        System.out.println(String.format("Case #%d: %d", t + 1, max));
    }

    private static void update(int[] numGoods, int[] diff2Right) {
        int index = 0;
        for (int c1 = 0; c1 < C; c1 += 1) {
            for (int c2 = c1; c2 < C; c2 += 1) {
                if (numGoods[index] == -1) {
                    index += 1;
                    continue;
                } else {
                    if (diff2Right[c2] - diff2Right[c1] == 0) {
                        numGoods[index] += (c2 - c1 + 1);
                    } else {
                        numGoods[index] = -1; // Dead
                    }
                }
                index += 1;
            }
        }
    }

    private static int[] makeDiff(int row) {
        int[] diff2Right = new int[C];
        for (int c = 0; c < C; c += 1) {
            if (c == 0) {
                diff2Right[c] = 0;
            } else {
                diff2Right[c] = diff2Right[c - 1] + Math.abs(V[row][c] - V[row][c - 1]);
            }
        }
        return diff2Right;
    }

}
