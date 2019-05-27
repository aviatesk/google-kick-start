package WiggleWalk;

import java.util.*;

public class Solution {

    private enum Direction {
        NORTH,
        EAST,
        SOUTH,
        WEST,
    }

    private static Scanner sc;
    private static int t;
    private static int N;
    private static int R;
    private static int C;
    private static int Sr;
    private static int Sc;
    private static int r;
    private static int c;
    private static String instructions;
    private static Set<Long> visited;

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
        R = sc.nextInt();
        C = sc.nextInt();
        Sr = sc.nextInt();
        Sc = sc.nextInt();
        instructions = sc.next();
    }

    private static void solve() {
        visited = new HashSet<>();
        r = Sr - 1; c = Sc - 1;
        visit();

        for (char instruction : instructions.toCharArray()) {
            processInstruction(instruction);
            while (isVisited()) {
                processInstruction(instruction);
            }
            visit();
        }

        System.out.println(String.format("Case #%d: %d %d", t + 1, r + 1, c + 1));
    }

    private static long getIndex() {
        return (long) r * C + c;
    }

    private static void visit() {
        visited.add(getIndex());
    }

    private static boolean isVisited() {
        return visited.contains(getIndex());
    }

    private static void move(Direction direction) {
        switch (direction) {
            case NORTH:
                r -= 1;
                break;
            case EAST:
                c += 1;
                break;
            case SOUTH:
                r += 1;
                break;
            case WEST:
                c -= 1;
                break;
        }
    }

    private static void processInstruction(char instruction) {
        if (instruction == 'N') {
            move(Direction.NORTH);
        } else if (instruction == 'E') {
            move(Direction.EAST);
        } else if (instruction == 'S') {
            move(Direction.SOUTH);
        } else if (instruction == 'W') {
            move(Direction.WEST);
        }
    }

}
