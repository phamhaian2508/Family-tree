package com.javaweb.utils;

import org.apache.commons.lang.StringUtils;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

public final class InputSanitizationUtils {
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9._-]{3,50}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,63}$", Pattern.CASE_INSENSITIVE);
    private static final Pattern PHONE_PATTERN = Pattern.compile("^[0-9+()\\-\\s]{7,20}$");
    private static final int DEFAULT_MAX_URL_LENGTH = 1000;

    private InputSanitizationUtils() {
    }

    public static String requirePlainText(String value, int maxLength, String message) {
        String normalized = normalizePlainText(value, maxLength);
        if (StringUtils.isBlank(normalized)) {
            throw new IllegalArgumentException(message);
        }
        return normalized;
    }

    public static String normalizePlainText(String value, int maxLength) {
        return normalizeText(value, maxLength, false);
    }

    public static String normalizeMultilineText(String value, int maxLength) {
        return normalizeText(value, maxLength, true);
    }

    public static String normalizeUsername(String value) {
        String normalized = StringUtils.trimToEmpty(value);
        if (!USERNAME_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("username_invalid");
        }
        return normalized;
    }

    public static String normalizeEmail(String value) {
        String normalized = StringUtils.trimToNull(value);
        if (normalized == null) {
            return null;
        }
        if (normalized.length() > 254 || !EMAIL_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("email_invalid");
        }
        return normalized;
    }

    public static String normalizePhone(String value) {
        String normalized = StringUtils.trimToNull(value);
        if (normalized == null) {
            return null;
        }
        if (!PHONE_PATTERN.matcher(normalized).matches()) {
            throw new IllegalArgumentException("phone_invalid");
        }
        return normalized;
    }

    public static String normalizeUrl(String value) {
        return normalizeUrl(value, DEFAULT_MAX_URL_LENGTH);
    }

    public static String normalizeUrl(String value, int maxLength) {
        String normalized = normalizePlainText(value, maxLength);
        if (StringUtils.isBlank(normalized)) {
            return "";
        }
        String lowered = normalized.toLowerCase(Locale.ROOT);
        if (lowered.startsWith("javascript:") || lowered.startsWith("vbscript:") || lowered.startsWith("data:")) {
            throw new IllegalArgumentException("url_invalid");
        }
        if (normalized.indexOf('"') >= 0 || normalized.indexOf('\'') >= 0 || normalized.indexOf('`') >= 0) {
            throw new IllegalArgumentException("url_invalid");
        }
        if (normalized.startsWith("/")) {
            return normalized;
        }
        try {
            URI uri = new URI(normalized);
            String scheme = StringUtils.defaultString(uri.getScheme()).toLowerCase(Locale.ROOT);
            if (!"http".equals(scheme) && !"https".equals(scheme)) {
                throw new IllegalArgumentException("url_invalid");
            }
            if (StringUtils.isBlank(uri.getHost())) {
                throw new IllegalArgumentException("url_invalid");
            }
            return normalized;
        } catch (URISyntaxException ex) {
            throw new IllegalArgumentException("url_invalid");
        }
    }

    public static String normalizeMultiUrlText(String value, int maxLength, int maxItems) {
        String normalized = normalizeMultilineText(value, maxLength);
        if (StringUtils.isBlank(normalized)) {
            return "";
        }
        String[] rawItems = normalized.split("\\n");
        List<String> items = new ArrayList<>();
        for (String rawItem : rawItems) {
            String url = normalizeUrl(rawItem, DEFAULT_MAX_URL_LENGTH);
            if (StringUtils.isNotBlank(url)) {
                items.add(url);
            }
        }
        if (items.size() > maxItems) {
            throw new IllegalArgumentException("url_invalid");
        }
        return String.join("\n", items);
    }

    public static String sanitizeContentDispositionFilename(String value, String fallback) {
        String normalized = StringUtils.trimToNull(value);
        if (normalized == null) {
            normalized = StringUtils.defaultIfEmpty(fallback, "download");
        }
        normalized = normalized.replaceAll("[\\r\\n\"]+", "_");
        normalized = normalized.replaceAll("[\\\\/:*?<>|]+", "_");
        normalized = normalized.trim();
        return normalized.isEmpty() ? "download" : normalized;
    }

    private static String normalizeText(String value, int maxLength, boolean allowNewLines) {
        String normalized = value == null ? "" : value;
        normalized = normalized.replace("\r\n", "\n").replace('\r', '\n');
        StringBuilder builder = new StringBuilder(normalized.length());
        for (int i = 0; i < normalized.length(); i++) {
            char current = normalized.charAt(i);
            if (current == '\t') {
                builder.append(' ');
                continue;
            }
            if (current == '\n') {
                if (allowNewLines) {
                    builder.append('\n');
                } else {
                    builder.append(' ');
                }
                continue;
            }
            if (Character.isISOControl(current)) {
                continue;
            }
            builder.append(current);
        }
        String result = builder.toString();
        result = allowNewLines
                ? result.replaceAll("[ \\u000B\\f]+", " ").replaceAll("\\n{3,}", "\n\n").trim()
                : result.replaceAll("\\s+", " ").trim();
        if (result.length() > maxLength) {
            throw new IllegalArgumentException("input_too_long");
        }
        return result;
    }
}
