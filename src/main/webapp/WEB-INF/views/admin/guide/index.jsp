<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/taglib.jsp" %>
<html>
<head>
    <title>H&#432;&#7899;ng d&#7851;n s&#7917; d&#7909;ng</title>
    <style>
        .guide-shell {
            background: linear-gradient(135deg, #f8fafc 0%, #eef2ff 100%);
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 20px;
        }
        .guide-hero {
            background: linear-gradient(120deg, #0f766e 0%, #1d4ed8 70%, #312e81 100%);
            border-radius: 14px;
            color: #fff;
            padding: 22px 24px;
            box-shadow: 0 10px 30px rgba(15, 118, 110, 0.25);
            margin-bottom: 16px;
        }
        .guide-hero h2 {
            margin: 0 0 8px;
            font-size: 24px;
            font-weight: 700;
            letter-spacing: .2px;
        }
        .guide-hero p {
            margin: 0;
            opacity: .95;
            line-height: 1.6;
        }
        .guide-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 16px;
        }
        .guide-toc {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 14px;
            position: sticky;
            top: 12px;
            align-self: start;
        }
        .guide-toc-title {
            font-weight: 700;
            color: #111827;
            margin-bottom: 10px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: .06em;
        }
        .guide-toc a {
            display: block;
            padding: 9px 10px;
            border-radius: 8px;
            color: #334155;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 6px;
            border: 1px solid transparent;
            transition: all .15s ease;
        }
        .guide-toc a:hover {
            background: #eff6ff;
            border-color: #bfdbfe;
            color: #1d4ed8;
        }
        .guide-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            margin-bottom: 14px;
            overflow: hidden;
        }
        .guide-card-head {
            padding: 14px 16px;
            border-bottom: 1px solid #eef2f7;
            background: linear-gradient(180deg, #ffffff 0%, #f9fafb 100%);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .guide-card-index {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #ffffff;
            color: #111827;
            border: 1px solid #d1d5db;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            flex: 0 0 auto;
        }
        .guide-card-title {
            margin: 0;
            color: #111827;
            font-size: 18px;
            font-weight: 700;
        }
        .guide-card-body {
            padding: 14px 16px 16px;
        }
        .guide-subtitle {
            font-weight: 700;
            color: #1f2937;
            margin: 10px 0 8px;
        }
        .guide-steps {
            margin: 0 0 10px;
            padding-left: 0;
            list-style: none;
        }
        .guide-steps li {
            margin-bottom: 8px;
            line-height: 1.65;
            color: #334155;
            padding-left: 34px;
            position: relative;
        }
        .guide-steps li:before {
            content: attr(data-step);
            position: absolute;
            left: 0;
            top: 1px;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #ffffff;
            color: #111827;
            border: 1px solid #d1d5db;
            font-weight: 700;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .guide-note {
            background: #f0f9ff;
            border-left: 4px solid #0284c7;
            padding: 10px 12px;
            border-radius: 8px;
            color: #0f172a;
            margin-top: 8px;
        }
        .guide-warning {
            background: #fff7ed;
            border-left: 4px solid #ea580c;
            padding: 10px 12px;
            border-radius: 8px;
            color: #7c2d12;
            margin-top: 8px;
        }
        .guide-inline-code {
            background: #f3f4f6;
            padding: 2px 6px;
            border-radius: 6px;
            color: #111827;
            font-family: Consolas, monospace;
        }
        @media (max-width: 1100px) {
            .guide-layout {
                grid-template-columns: 1fr;
            }
            .guide-toc {
                position: static;
            }
        }
    </style>
</head>
<body>
<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="<c:url value='/admin/home'/>">Trang ch&#7911;</a>
                </li>
                <li class="active">H&#432;&#7899;ng d&#7851;n s&#7917; d&#7909;ng</li>
            </ul>
        </div>

        <div class="page-content guide-page">
            <div class="guide-shell">
                <div class="guide-hero">
                    <h2>H&#432;&#7899;ng D&#7851;n S&#7917; D&#7909;ng H&#7879; Th&#7889;ng Gia Ph&#7843;</h2>
                    <p>
                        T&#224;i li&#7879;u n&#224;y gi&#250;p qu&#7843;n tr&#7883; vi&#234;n thao t&#225;c nhanh, &#273;&#250;ng quy tr&#236;nh
                        v&#224; gi&#7843;m l&#7895;i khi qu&#7843;n l&#253; c&#226;y gia ph&#7843;, media, ng&#432;&#7901;i d&#249;ng.
                    </p>
                </div>

                <div class="guide-layout">
                    <div class="guide-toc">
                        <div class="guide-toc-title">M&#7909;c L&#7909;c Nhanh</div>
                        <a href="#sec-member">1. Th&#234;m Th&#224;nh Vi&#234;n</a>
                        <a href="#sec-search">2. T&#236;m Ki&#7871;m Tr&#234;n C&#226;y</a>
                        <a href="#sec-media">3. S&#7917; D&#7909;ng Media</a>
                        <a href="#sec-user">4. Qu&#7843;n L&#253; Ng&#432;&#7901;i D&#249;ng</a>
                        <a href="#sec-trouble">5. L&#7895;i Th&#432;&#7901;ng G&#7863;p</a>
                    </div>

                    <div>
                        <div class="guide-card" id="sec-member">
                            <div class="guide-card-head">
                                <span class="guide-card-index">1</span>
                                <h3 class="guide-card-title">Th&#234;m th&#224;nh vi&#234;n trong c&#226;y gia ph&#7843;</h3>
                            </div>
                            <div class="guide-card-body">
                                <div class="guide-subtitle">A. T&#7841;o th&#224;nh vi&#234;n g&#7889;c ban &#273;&#7847;u</div>
                                <ul class="guide-steps">
                                    <li data-step="1">V&#224;o menu <b>C&#226;y gia ph&#7843;</b>, b&#7845;m <b>T&#7841;o th&#224;nh vi&#234;n &#273;&#7847;u ti&#234;n</b> n&#7871;u c&#226;y ch&#432;a c&#243; d&#7919; li&#7879;u.</li>
                                    <li data-step="2">Nh&#7853;p c&#225;c tr&#432;&#7901;ng b&#7855;t bu&#7897;c: H&#7885; t&#234;n, Gi&#7899;i t&#237;nh, Ng&#224;y sinh, &#272;&#7901;i.</li>
                                    <li data-step="3">B&#7845;m <b>L&#432;u th&#224;nh vi&#234;n</b> v&#224; ki&#7875;m tra th&#7867; th&#224;nh vi&#234;n hi&#7875;n th&#7883; tr&#234;n c&#226;y.</li>
                                </ul>

                                <div class="guide-subtitle">B. Th&#234;m con / th&#234;m v&#7907;</div>
                                <ul class="guide-steps">
                                    <li data-step="1">B&#7845;m v&#224;o m&#7897;t th&#224;nh vi&#234;n &#273;&#7875; m&#7903; c&#7917;a s&#7893; chi ti&#7871;t.</li>
                                    <li data-step="2">Ch&#7885;n n&#250;t <b>Th&#234;m con</b> ho&#7863;c <b>Th&#234;m v&#7907;</b>.</li>
                                    <li data-step="3">Ch&#7885;n c&#225;ch th&#234;m:
                                        <span class="guide-inline-code">T&#7841;o m&#7899;i</span> ho&#7863;c
                                        <span class="guide-inline-code">Ch&#7885;n t&#7915; danh s&#225;ch c&#243; s&#7861;n</span>.
                                    </li>
                                    <li data-step="4">Nh&#7853;p/ki&#7875;m tra th&#244;ng tin r&#7891;i b&#7845;m <b>L&#432;u</b>.</li>
                                </ul>

                                <div class="guide-warning">
                                    Quy &#273;&#7883;nh hi&#7879;n t&#7841;i: <b>Th&#234;m con ch&#7881; cho chi 1 v&#224; chi 2</b>.
                                </div>
                                <div class="guide-note">
                                    H&#7879; th&#7889;ng &#273;&#227; ch&#7863;n d&#7919; li&#7879;u sai: ng&#224;y m&#7845;t &lt; ng&#224;y sinh,
                                    ng&#224;y trong t&#432;&#417;ng lai, t&#234;n ch&#7913;a m&#227; HTML, gi&#7899;i t&#237;nh kh&#244;ng h&#7907;p l&#7879;.
                                </div>
                            </div>
                        </div>

                        <div class="guide-card" id="sec-search">
                            <div class="guide-card-head">
                                <span class="guide-card-index">2</span>
                                <h3 class="guide-card-title">T&#236;m ki&#7871;m th&#224;nh vi&#234;n tr&#234;n c&#226;y gia ph&#7843;</h3>
                            </div>
                            <div class="guide-card-body">
                                <div class="guide-subtitle">B&#7897; l&#7885;c nhanh</div>
                                <ul class="guide-steps">
                                    <li data-step="1">D&#249;ng &#244; <b>T&#236;m theo t&#234;n</b> &#273;&#7875; l&#7885;c theo t&#234;n th&#224;nh vi&#234;n/v&#7907; ch&#7891;ng.</li>
                                    <li data-step="2">Ch&#7885;n <b>Chi</b> &#273;&#7875; xem theo t&#7915;ng nh&#225;nh.</li>
                                    <li data-step="3">Ch&#7885;n <b>&#272;&#7901;i</b> &#273;&#7875; xem theo th&#7871; h&#7879;.</li>
                                </ul>

                                <div class="guide-subtitle">B&#7897; l&#7885;c n&#226;ng cao</div>
                                <ul class="guide-steps">
                                    <li data-step="1">L&#7885;c theo gi&#7899;i t&#237;nh, t&#236;nh tr&#7841;ng s&#7889;ng/m&#7845;t, n&#259;m sinh.</li>
                                    <li data-step="2">B&#7845;m <b>Reset</b> &#273;&#7875; quay v&#7873; m&#7863;c &#273;&#7883;nh.</li>
                                    <li data-step="3">B&#7845;m v&#224;o m&#7897;t th&#224;nh vi&#234;n &#273;&#7875; xem nhanh chi ti&#7871;t v&#224; thao t&#225;c li&#234;n quan.</li>
                                </ul>
                            </div>
                        </div>

                        <div class="guide-card" id="sec-media">
                            <div class="guide-card-head">
                                <span class="guide-card-index">3</span>
                                <h3 class="guide-card-title">S&#7917; d&#7909;ng th&#432; vi&#7879;n Media</h3>
                            </div>
                            <div class="guide-card-body">
                                <div class="guide-subtitle">Upload media</div>
                                <ul class="guide-steps">
                                    <li data-step="1">V&#224;o menu <b>Th&#432; vi&#7879;n Media</b> v&#224; b&#7845;m t&#7843;i l&#234;n.</li>
                                    <li data-step="2">Ch&#7885;n file &#7843;nh/video t&#7915; m&#225;y.</li>
                                    <li data-step="3">Nh&#7853;p t&#234;n hi&#7875;n th&#7883;, ch&#7885;n ph&#7841;m vi hi&#7875;n th&#7883; v&#224; g&#7855;n &#273;&#7889;i t&#432;&#7907;ng.</li>
                                    <li data-step="4">X&#225;c nh&#7853;n upload v&#224; ki&#7875;m tra danh s&#225;ch file.</li>
                                </ul>

                                <div class="guide-subtitle">Qu&#7843;n l&#253; media</div>
                                <ul class="guide-steps">
                                    <li data-step="1">D&#249;ng t&#236;m ki&#7871;m/l&#7885;c theo t&#234;n file, ng&#432;&#7901;i t&#7843;i, th&#7901;i gian.</li>
                                    <li data-step="2">Xem/t&#7843;i xu&#7889;ng &#273;&#7875; ki&#7875;m tra n&#7897;i dung.</li>
                                    <li data-step="3">X&#243;a file kh&#244;ng c&#7847;n thi&#7871;t ho&#7863;c sai n&#7897;i dung.</li>
                                </ul>

                                <div class="guide-note">
                                    Ch&#7881; t&#224;i kho&#7843;n c&#243; quy&#7873;n m&#7899;i upload/x&#243;a media.
                                    N&#234;n &#273;&#7863;t t&#234;n file theo m&#7849;u:
                                    <span class="guide-inline-code">nam-su-kien-thanh-vien</span>.
                                </div>
                            </div>
                        </div>

                        <div class="guide-card" id="sec-user">
                            <div class="guide-card-head">
                                <span class="guide-card-index">4</span>
                                <h3 class="guide-card-title">Qu&#7843;n l&#253; ng&#432;&#7901;i d&#249;ng (Admin)</h3>
                            </div>
                            <div class="guide-card-body">
                                <div class="guide-subtitle">Th&#234;m / s&#7917;a t&#224;i kho&#7843;n</div>
                                <ul class="guide-steps">
                                    <li data-step="1">V&#224;o menu <b>Qu&#7843;n l&#253; ng&#432;&#7901;i d&#249;ng</b> (manager).</li>
                                    <li data-step="2">Th&#234;m m&#7899;i user, nh&#7853;p h&#7885; t&#234;n v&#224; vai tr&#242;.</li>
                                    <li data-step="3">S&#7917;a user khi c&#7847;n c&#7853;p nh&#7853;t h&#7885; t&#234;n/quy&#7873;n.</li>
                                    <li data-step="4">V&#244; hi&#7879;u h&#243;a t&#224;i kho&#7843;n kh&#244;ng c&#242;n d&#249;ng.</li>
                                </ul>

                                <div class="guide-subtitle">M&#7853;t kh&#7849;u v&#224; b&#7843;o m&#7853;t</div>
                                <ul class="guide-steps">
                                    <li data-step="1">&#272;&#7893;i m&#7853;t kh&#7849;u t&#7841;i <b>Th&#244;ng tin t&#224;i kho&#7843;n &gt; &#272;&#7893;i m&#7853;t kh&#7849;u</b>.</li>
                                    <li data-step="2">M&#7853;t kh&#7849;u m&#7899;i: t&#7889;i thi&#7875;u 8 k&#253; t&#7921;, c&#243; ch&#7919; v&#224; s&#7889;.</li>
                                    <li data-step="3">Admin d&#249;ng <b>Reset m&#7853;t kh&#7849;u</b> cho user qu&#234;n m&#7853;t kh&#7849;u.</li>
                                    <li data-step="4">Ki&#7875;m tra log b&#7843;o m&#7853;t &#273;&#7883;nh k&#7923;.</li>
                                </ul>
                            </div>
                        </div>

                        <div class="guide-card" id="sec-trouble">
                            <div class="guide-card-head">
                                <span class="guide-card-index">5</span>
                                <h3 class="guide-card-title">L&#7895;i th&#432;&#7901;ng g&#7863;p v&#224; c&#225;ch x&#7917; l&#253;</h3>
                            </div>
                            <div class="guide-card-body">
                                <ul class="guide-steps">
                                    <li data-step="1"><b>Kh&#244;ng l&#432;u &#273;&#432;&#7907;c th&#224;nh vi&#234;n:</b> ki&#7875;m tra tr&#432;&#7901;ng b&#7855;t bu&#7897;c v&#224; ng&#224;y sinh/ng&#224;y m&#7845;t.</li>
                                    <li data-step="2"><b>Kh&#244;ng th&#234;m &#273;&#432;&#7907;c con:</b> th&#224;nh vi&#234;n c&#243; th&#7875; kh&#244;ng thu&#7897;c chi 1 ho&#7863;c chi 2.</li>
                                    <li data-step="3"><b>Kh&#244;ng th&#7845;y menu qu&#7843;n l&#253; user:</b> t&#224;i kho&#7843;n ch&#432;a c&#243; role manager.</li>
                                    <li data-step="4"><b>Upload media l&#7895;i:</b> file qu&#225; l&#7899;n, sai &#273;&#7883;nh d&#7841;ng ho&#7863;c thi&#7871;u quy&#7873;n.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
