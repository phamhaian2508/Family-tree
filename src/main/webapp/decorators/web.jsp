<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="Livestream" /></title>
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <link rel="shortcut icon" href="/favicon.svg" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --gpo-primary: #047857;
            --gpo-primary-hover: #065f46;
            --gpo-primary-light: #d1fae5;
            --gpo-dark: #0f172a;
            --gpo-text: #1e293b;
            --gpo-text-muted: #64748b;
            --gpo-bg-light: #fafaf9;
            --gpo-border: #e7e5e4;
            --gpo-radius: 0.75rem;
        }

        * {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }

        body {
            color: var(--gpo-text);
            background-color: var(--gpo-bg-light);
        }

        /* HEADER */
        .gpo-header {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--gpo-border);
            z-index: 1050;
        }

        .gpo-header .navbar {
            padding: 0.75rem 0;
        }

        .gpo-logo-icon {
            color: var(--gpo-primary);
        }

        .gpo-logo-text {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--gpo-text);
            letter-spacing: -0.02em;
        }

        .gpo-header .nav-link {
            color: var(--gpo-text-muted);
            font-size: 0.875rem;
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: color 0.2s;
        }

        .gpo-header .nav-link:hover {
            color: var(--gpo-primary);
        }

        /* Nút chung */
        .btn-gpo {
            background-color: var(--gpo-primary);
            color: #fff;
            border: none;
            border-radius: var(--gpo-radius);
            font-weight: 600;
            font-size: 0.875rem;
            padding: 0.5rem 1.25rem;
            transition: background-color 0.2s, box-shadow 0.2s;
        }

        .btn-gpo:hover {
            background-color: var(--gpo-primary-hover);
            color: #fff;
            box-shadow: 0 4px 12px rgba(4, 120, 87, 0.25);
        }

        .btn-outline-gpo {
            color: var(--gpo-text-muted);
            border: 1px solid var(--gpo-border);
            border-radius: var(--gpo-radius);
            font-weight: 500;
            font-size: 0.875rem;
            padding: 0.5rem 1.25rem;
            background: transparent;
            transition: all 0.2s;
        }

        .btn-outline-gpo:hover {
            color: var(--gpo-primary);
            border-color: var(--gpo-primary);
            background: var(--gpo-primary-light);
        }

        .btn-lg.btn-gpo,
        .btn-lg.btn-outline-gpo {
            font-size: 1rem;
            padding: 0.75rem 1.75rem;
        }

        /* HERO SECTION */
        .gpo-hero {
            padding: 10rem 0 5rem;
            background-image:
                linear-gradient(rgba(255, 255, 255, 0.40), rgba(255, 255, 255, 0.40)),
                url('/web/images/paper-texture.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        .gpo-hero-title {
            font-size: 3.25rem;
            font-weight: 800;
            line-height: 1.15;
            color: var(--gpo-text);
            margin-bottom: 1.25rem;
            letter-spacing: -0.03em;
        }

        .gpo-text-primary {
            color: var(--gpo-primary);
        }

        .gpo-hero-subtitle {
            font-size: 1.2rem;
            color: var(--gpo-text-muted);
            max-width: 640px;
            margin-bottom: 2rem;
            line-height: 1.7;
        }

        .gpo-stats {
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: none;
        }

        .gpo-stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gpo-text);
        }

        .gpo-stat-label {
            font-size: 0.85rem;
            color: var(--gpo-text-muted);
            font-weight: 500;
        }

        /* FEATURES SECTION */
        .gpo-features {
            padding: 5rem 0;
            background: #fff;
        }

        .gpo-section-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gpo-text);
            letter-spacing: -0.02em;
        }

        .gpo-section-subtitle {
            font-size: 1.05rem;
            color: var(--gpo-text-muted);
            max-width: 600px;
        }

        .gpo-feature-card {
            padding: 2rem;
            border-radius: var(--gpo-radius);
            background: var(--gpo-bg-light);
            border: 1px solid var(--gpo-border);
            height: 100%;
            transition: border-color 0.25s, box-shadow 0.25s;
        }

        .gpo-feature-card:hover {
            border-color: #a7f3d0;
            box-shadow: 0 4px 20px rgba(4, 120, 87, 0.08);
        }

        .gpo-feature-icon {
            width: 48px;
            height: 48px;
            border-radius: 0.5rem;
            background: #fff;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.25rem;
            color: var(--gpo-primary);
            font-size: 1.25rem;
            transition: all 0.25s;
        }

        .gpo-feature-card:hover .gpo-feature-icon {
            background: var(--gpo-primary);
            color: #fff;
        }

        .gpo-feature-card h3 {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            color: var(--gpo-text);
        }

        .gpo-feature-card p {
            font-size: 0.9rem;
            color: var(--gpo-text-muted);
            line-height: 1.7;
            margin-bottom: 0;
        }

        /* ABOUT SECTION */
        .gpo-about {
            padding: 5rem 0;
            background: var(--gpo-bg-light);
        }

        .gpo-check-list {
            list-style: none;
            padding: 0;
            margin-top: 1.5rem;
        }

        .gpo-check-list li {
            padding: 0.5rem 0;
            font-size: 0.95rem;
            color: var(--gpo-text);
        }

        .gpo-check-list li i {
            color: var(--gpo-primary);
            margin-right: 0.75rem;
            font-size: 0.85rem;
        }

        .gpo-about-visual {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 300px;
        }

        .gpo-about-card {
            background: #fff;
            border-radius: var(--gpo-radius);
            padding: 3rem;
            text-align: center;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            border: 1px solid var(--gpo-border);
            max-width: 320px;
        }

        .gpo-about-card h4 {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .gpo-about-card p {
            color: var(--gpo-text-muted);
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        /* CTA SECTION */
        .gpo-cta {
            padding: 5rem 0;
            background: var(--gpo-dark);
        }

        .gpo-cta .gpo-section-title {
            color: #fff;
        }

        /* FOOTER */
        .gpo-footer {
            background: var(--gpo-dark);
            color: #94a3b8;
            padding: 3rem 0 0;
            border-top: 1px solid #1e293b;
        }

        .gpo-footer-brand {
            color: #fff;
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 0.75rem;
        }

        .gpo-footer-desc {
            font-size: 0.9rem;
            max-width: 320px;
            line-height: 1.7;
        }

        .gpo-footer-heading {
            color: #fff;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .gpo-footer-links {
            list-style: none;
            padding: 0;
        }

        .gpo-footer-links li {
            margin-bottom: 0.5rem;
        }

        .gpo-footer-links a {
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.875rem;
            transition: color 0.2s;
        }

        .gpo-footer-links a:hover {
            color: #fff;
        }

        .gpo-footer-bottom {
            padding: 1.5rem 0;
            border-top: 1px solid #1e293b;
            margin-top: 1rem;
        }

        .gpo-footer-bottom p {
            font-size: 0.85rem;
            margin: 0;
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .gpo-hero {
                padding: 7rem 0 3rem;
            }
            .gpo-hero-title {
                font-size: 2.25rem;
            }
            .gpo-hero-subtitle {
                font-size: 1rem;
            }
            .gpo-section-title {
                font-size: 1.6rem;
            }
            .gpo-stat-number {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/common/web/header.jsp" %>

    <dec:body/>

    <%@ include file="/common/web/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
