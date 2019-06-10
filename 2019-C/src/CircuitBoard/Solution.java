package CircuitBoard;

import java.util.*;

public class Solution {

    private static class Node {
        int index;
        int height;
        Node(int index, int height) {
            this.index = index;
            this.height = height;
        }
    }

    private static Scanner sc;
    private static int t;
    private static int R;
    private static int C;
    private static int K;
    private static int[][] V;

    public static void main(String[] args) {
        sc = new Scanner(System.in);
        int T = sc.nextInt();
        for (t = 1; t <= T; t += 1) {
            load();
            solve();
        }
    }

    private static void load() {
        R = sc.nextInt();
        C = sc.nextInt();
        K = sc.nextInt();
        V = new int[R][C + 1];
        for (int r = 0; r < R; r += 1) {
            for (int c = 0; c < C; c += 1) {
                V[r][c] = Integer.parseInt(sc.next());
            }
            V[r][C] = Integer.MAX_VALUE;
        }
    }

    private static void solve() {
        int[][] P = makeP();

        int maxArea = maxArea(P);

        System.out.println(String.format("Case #%d: %d", t, maxArea));
    }

    private static int[][] makeP() {
        int[][] P = new int[R][C];
        for (int row = 0; row < R; row += 1) {
            makePHelper(row,  P[row], 0);
        }
        return P;
    }

    private static int makePHelper(int row, int[] pi, int index) {
        if (index == pi.length) {
            return 0;
        }
        int pij1 = makePHelper(row, pi, index + 1);
        int pij = V[row][index] == V[row][index + 1] ? pij1 + 1 : 1;
        pi[index] = pij;
        return pij;
    }

    private static int maxArea(int[][] P) {
        int maxArea = Integer.MIN_VALUE;
        for (int c = 0; c < C; c += 1) {
            maxArea = Integer.max(maxArea, maxAreaInHistogram(P, c));
        }
        return maxArea;
    }

    private static int maxAreaInHistogram(int[][] P, int c) {
        Deque<Node> stack = new LinkedList<>();

        int maxArea = Integer.MIN_VALUE;

        for (int index = 0; index < R; index += 1) {
            int height = P[index][c];

            boolean breakLoop = false;
            int newIndex = index;
            while (!breakLoop) {
                Node top = stack.peek();
                if (top == null || top.height < height) {
                    breakLoop = true;
                } else if (top.height == height) {
                    newIndex = top.index;
                    stack.removeFirst();
                    breakLoop = true;
                } else {  // top.height > height
                    maxArea = Integer.max(maxArea, top.height * (index - top.index));
                    newIndex = top.index;
                    stack.removeFirst();
                }
            }

            stack.addFirst(new Node(newIndex, height));
        }

        int index = R;
        for (Node top : stack) {
            maxArea = Integer.max(maxArea, top.height * (index - top.index));
        }
        return maxArea;
    }

}
