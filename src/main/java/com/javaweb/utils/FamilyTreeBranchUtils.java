package com.javaweb.utils;

import java.text.Normalizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class FamilyTreeBranchUtils {
    private static final Pattern FIRST_NUMBER_PATTERN = Pattern.compile("(\\d+)");

    private FamilyTreeBranchUtils() {
    }

    public static String normalizeBranchKey(String rawValue) {
        if (rawValue == null) {
            return null;
        }
        String normalized = Normalizer.normalize(rawValue.trim().replaceAll("\\s+", " "), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .replace('\u0111', 'd')
                .replace('\u0110', 'D')
                .toLowerCase();
        if (normalized.isEmpty()) {
            return null;
        }
        if ("chinh".equals(normalized) || "main".equals(normalized)) {
            return "main";
        }
        Matcher matcher = FIRST_NUMBER_PATTERN.matcher(normalized);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return normalized;
    }

    public static boolean isMainBranchName(String rawValue) {
        return "main".equals(normalizeBranchKey(rawValue));
    }

    public static Integer branchOrder(String rawValue) {
        String key = normalizeBranchKey(rawValue);
        if (key == null) {
            return Integer.MAX_VALUE;
        }
        if ("main".equals(key)) {
            return 0;
        }
        try {
            return Integer.parseInt(key);
        } catch (NumberFormatException ignored) {
            return Integer.MAX_VALUE - 1;
        }
    }
}
