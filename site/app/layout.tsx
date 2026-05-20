import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { HexMark } from "./components/HexMark";
import { ThemeToggle } from "./components/ThemeToggle";
import "./globals.css";

const geist = Geist({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-geist",
});

const geistMono = Geist_Mono({
  subsets: ["latin"],
  display: "swap",
  variable: "--font-geist-mono",
});

export const metadata: Metadata = {
  metadataBase: new URL("https://linuxbenchhub.vercel.app"),
  title: "LinuxBenchHub — VM benchmarks for Linux distros",
  description:
    "Compare Linux distros under identical virtual hardware. Phoronix Test Suite results for Ubuntu 24.04, Fedora 41, and Debian 12 captured on VMware Fusion Pro.",
  openGraph: {
    title: "LinuxBenchHub",
    description:
      "VM benchmarks for Linux distros — Ubuntu, Fedora, Debian under identical virtual hardware.",
    images: [{ url: "/social-card.png", width: 1200, height: 630 }],
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "LinuxBenchHub",
    description:
      "VM benchmarks for Linux distros — Ubuntu, Fedora, Debian under identical virtual hardware.",
    images: ["/social-card.png"],
  },
  icons: {
    icon: [{ url: "/favicon.svg", type: "image/svg+xml" }],
    apple: "/apple-touch-icon.png",
  },
};

const themeInitScript = `
(function(){try{var t=localStorage.getItem('theme');if(t==='light'||t==='dark'){document.documentElement.setAttribute('data-theme',t);}}catch(e){}})();
`.trim();

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html
      lang="en"
      className={`${geist.variable} ${geistMono.variable}`}
      suppressHydrationWarning
    >
      <head>
        <script dangerouslySetInnerHTML={{ __html: themeInitScript }} />
      </head>
      <body>
        <div className="page">
          <nav className="nav">
            <div className="nav-brand">
              <HexMark size={20} />
              <span>LinuxBenchHub</span>
            </div>
            <div className="nav-links">
              <a href="/">Overview</a>
              <a href="/benchmarks/ubuntu/">Ubuntu</a>
              <a href="/benchmarks/fedora/">Fedora</a>
              <a href="/benchmarks/debian/">Debian</a>
              <a
                href="https://github.com/Builder106/LinuxBenchHub"
                target="_blank"
                rel="noreferrer"
              >
                GitHub ↗
              </a>
              <ThemeToggle />
            </div>
          </nav>
          {children}
          <footer className="footer">
            <div className="footer-brand">
              <HexMark size={14} />
              <span>LINUXBENCHHUB · MIT</span>
            </div>
            <div>
              BUILD 2026-05-19 ·{" "}
              <a
                href="https://github.com/Builder106"
                target="_blank"
                rel="noreferrer"
              >
                @BUILDER106
              </a>
            </div>
          </footer>
        </div>
      </body>
    </html>
  );
}
