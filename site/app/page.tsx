import { FacetDivider, SectionFlag } from "./components/FacetDivider";
import { DistroMark } from "./components/DistroMark";

type Benchmark = {
  name: string;
  test: string;
  unit: string;
  mean: number;
  meanLabel: string;
  min: number;
  max: number;
  median: number;
  stddev: number;
};

const benchmarks: Benchmark[] = [
  {
    name: "C-Ray",
    test: "pts/c-ray-2.0.0 · 1080p @ 16 rpp",
    unit: "ms",
    mean: 1088.787,
    meanLabel: "1,088",
    min: 767.61,
    max: 1447.948,
    median: 1141.11,
    stddev: 222.509,
  },
  {
    name: "Tinymembench memcpy",
    test: "pts/tinymembench-1.0.2 · standard memcpy",
    unit: "MB/s",
    mean: 11209.5,
    meanLabel: "11,210",
    min: 7012.8,
    max: 14624.8,
    median: 11873.6,
    stddev: 2761.1,
  },
  {
    name: "Tinymembench memset",
    test: "pts/tinymembench-1.0.2 · standard memset",
    unit: "MB/s",
    mean: 23480.2,
    meanLabel: "23,480",
    min: 10140.9,
    max: 28912.0,
    median: 25745.6,
    stddev: 5731.1,
  },
  {
    name: "Aircrack-ng",
    test: "pts/aircrack-ng-1.3.0 · WPA dictionary attack",
    unit: "k/s",
    mean: 4542.6,
    meanLabel: "4,542",
    min: 2832.371,
    max: 5432.095,
    median: 4943.083,
    stddev: 835.1,
  },
];

function pct(x: number, min: number, max: number) {
  return ((x - min) / (max - min)) * 100;
}

function SpreadBar({ b }: { b: Benchmark }) {
  return (
    <div className="spread" aria-hidden="true">
      <div className="spread-track" />
      <div
        className="spread-range"
        style={{
          left: `${pct(b.mean - b.stddev, b.min, b.max)}%`,
          width: `${pct(b.mean + b.stddev, b.min, b.max) - pct(b.mean - b.stddev, b.min, b.max)}%`,
        }}
      />
      <div className="spread-tick" style={{ left: "0%" }} />
      <div className="spread-tick" style={{ left: "100%" }} />
      <div
        className="spread-mean"
        style={{ left: `${pct(b.mean, b.min, b.max)}%` }}
      />
    </div>
  );
}

const stack = [
  {
    label: "Capture",
    chips: ["Phoronix Test Suite", "VMware Fusion Pro 13.6"],
  },
  {
    label: "Analyze",
    chips: ["R", "xml2", "dplyr", "ggplot2", "tidyr"],
  },
  {
    label: "Dashboard",
    chips: [
      "Rails 8.0",
      "Ruby 3.3",
      "Hotwire",
      "Chartkick",
      "Groupdate",
      "Bootstrap",
    ],
  },
  {
    label: "Background",
    chips: ["Sidekiq", "Whenever"],
  },
  {
    label: "Live VM",
    chips: ["noVNC", "WebSocket"],
  },
  {
    label: "Storage",
    chips: ["SQLite", "Puma"],
  },
  {
    label: "Auth",
    chips: ["Devise"],
  },
  {
    label: "Cloud",
    chips: ["azure_mgmt_compute", "azure_mgmt_network", "azure_mgmt_resources"],
  },
  {
    label: "Deploy",
    chips: ["Docker", "Kamal"],
  },
];

type Distro = {
  slug: "ubuntu" | "fedora" | "debian";
  name: string;
  version: string;
  color: string;
  stat: { value: string; unit: string; label: string } | null;
};

const distros: Distro[] = [
  {
    slug: "ubuntu",
    name: "Ubuntu",
    version: "24.04 LTS",
    color: "var(--distro-ubuntu)",
    stat: { value: "1,088", unit: "ms", label: "C-Ray mean" },
  },
  {
    slug: "fedora",
    name: "Fedora",
    version: "41",
    color: "var(--distro-fedora)",
    stat: null,
  },
  {
    slug: "debian",
    name: "Debian",
    version: "12",
    color: "var(--distro-debian)",
    stat: null,
  },
];

function HexTile({ distro }: { distro: Distro }) {
  return (
    <a className="hex-tile" href={`/benchmarks/${distro.slug}/`}>
      <div className="hex-tile-inner">
        <div className="hex-tile-mark">
          <DistroMark distro={distro.slug} size={44} />
        </div>
        <div className="hex-tile-name">{distro.name}</div>
        <div className="hex-tile-version">{distro.version}</div>
        {distro.stat ? (
          <>
            <div className="hex-tile-stat">
              {distro.stat.value}
              <small>{distro.stat.unit}</small>
            </div>
            <div className="hex-tile-stat-label">{distro.stat.label}</div>
          </>
        ) : (
          <div className="hex-tile-stat-pending">capture pending</div>
        )}
        <div className="hex-tile-cta">View writeup →</div>
      </div>
    </a>
  );
}

function FlowchartNode({
  x,
  y,
  l1,
  l2,
  emphasis = false,
}: {
  x: number;
  y: number;
  l1: string;
  l2?: string;
  emphasis?: boolean;
}) {
  const R = 56;
  const points = [
    [R, 0],
    [R / 2, -R * 0.866],
    [-R / 2, -R * 0.866],
    [-R, 0],
    [-R / 2, R * 0.866],
    [R / 2, R * 0.866],
  ]
    .map(([px, py]) => `${px.toFixed(2)},${py.toFixed(2)}`)
    .join(" ");
  return (
    <g transform={`translate(${x},${y})`}>
      <polygon
        points={points}
        fill={emphasis ? "var(--panel-emphasis)" : "var(--panel)"}
        stroke={emphasis ? "var(--accent)" : "var(--border-warm-bright)"}
        strokeWidth={emphasis ? "1.4" : "1"}
      />
      <text
        textAnchor="middle"
        dy={l2 ? "-2" : "5"}
        fontFamily="var(--font-mono)"
        fontSize="11"
        fontWeight="600"
        fill="var(--fg)"
        letterSpacing="0.02em"
      >
        {l1}
      </text>
      {l2 && (
        <text
          textAnchor="middle"
          dy="14"
          fontFamily="var(--font-mono)"
          fontSize="10"
          fill="var(--fg-muted)"
          letterSpacing="0.04em"
        >
          {l2}
        </text>
      )}
    </g>
  );
}

function FlowArrow({
  x1,
  y1,
  x2,
  y2,
  label,
}: {
  x1: number;
  y1: number;
  x2: number;
  y2: number;
  label?: string;
}) {
  const dx = x2 - x1;
  const dy = y2 - y1;
  const len = Math.sqrt(dx * dx + dy * dy);
  const ux = dx / len;
  const uy = dy / len;
  // back the arrow off so the head doesn't penetrate the target hex
  const ax = x2 - ux * 4;
  const ay = y2 - uy * 4;
  const angle = (Math.atan2(dy, dx) * 180) / Math.PI;
  return (
    <g>
      <line
        x1={x1}
        y1={y1}
        x2={ax}
        y2={ay}
        stroke="var(--accent)"
        strokeWidth="1.2"
        opacity="0.85"
      />
      <polygon
        points="0,0 -8,-4 -8,4"
        fill="var(--accent)"
        opacity="0.95"
        transform={`translate(${ax},${ay}) rotate(${angle})`}
      />
      {label && (
        <text
          x={(x1 + x2) / 2}
          y={(y1 + y2) / 2 - 6}
          textAnchor="middle"
          fontFamily="var(--font-mono)"
          fontSize="9"
          fill="var(--fg-dim)"
          letterSpacing="0.1em"
        >
          {label}
        </text>
      )}
    </g>
  );
}

const flowNodes = {
  vmware: { x: 80, y: 200 },
  pts: { x: 240, y: 200 },
  composite: { x: 420, y: 200 },
  rparser: { x: 600, y: 90 },
  writeups: { x: 800, y: 90 },
  rails: { x: 600, y: 310 },
  dashboard: { x: 800, y: 310 },
};

function Flowchart() {
  const n = flowNodes;
  const r = 56;
  // horizontal arrow endpoints: edges of hex are at x±R
  return (
    <div className="flowchart">
      <svg viewBox="0 0 900 400" xmlns="http://www.w3.org/2000/svg">
        <text
          x={n.vmware.x}
          y="30"
          textAnchor="middle"
          fontFamily="var(--font-mono)"
          fontSize="10"
          fill="var(--fg-dim)"
          letterSpacing="0.18em"
          fontWeight="700"
        >
          CAPTURE
        </text>
        <text
          x={n.composite.x}
          y="30"
          textAnchor="middle"
          fontFamily="var(--font-mono)"
          fontSize="10"
          fill="var(--fg-dim)"
          letterSpacing="0.18em"
          fontWeight="700"
        >
          INGEST
        </text>
        <text
          x={(n.rparser.x + n.writeups.x) / 2}
          y="30"
          textAnchor="middle"
          fontFamily="var(--font-mono)"
          fontSize="10"
          fill="var(--fg-dim)"
          letterSpacing="0.18em"
          fontWeight="700"
        >
          ANALYZE (R)
        </text>
        <text
          x={(n.rails.x + n.dashboard.x) / 2}
          y="370"
          textAnchor="middle"
          fontFamily="var(--font-mono)"
          fontSize="10"
          fill="var(--fg-dim)"
          letterSpacing="0.18em"
          fontWeight="700"
        >
          DASHBOARD (RUBY)
        </text>

        <FlowArrow
          x1={n.vmware.x + r}
          y1={n.vmware.y}
          x2={n.pts.x - r}
          y2={n.pts.y}
          label="ssh"
        />
        <FlowArrow
          x1={n.pts.x + r}
          y1={n.pts.y}
          x2={n.composite.x - r}
          y2={n.composite.y}
          label="run"
        />
        <FlowArrow
          x1={n.composite.x + 28}
          y1={n.composite.y - 30}
          x2={n.rparser.x - 28}
          y2={n.rparser.y + 30}
        />
        <FlowArrow
          x1={n.composite.x + 28}
          y1={n.composite.y + 30}
          x2={n.rails.x - 28}
          y2={n.rails.y - 30}
        />
        <FlowArrow
          x1={n.rparser.x + r}
          y1={n.rparser.y}
          x2={n.writeups.x - r}
          y2={n.writeups.y}
        />
        <FlowArrow
          x1={n.rails.x + r}
          y1={n.rails.y}
          x2={n.dashboard.x - r}
          y2={n.dashboard.y}
        />

        <FlowchartNode
          x={n.vmware.x}
          y={n.vmware.y}
          l1="VMware"
          l2="Fusion Pro"
        />
        <FlowchartNode x={n.pts.x} y={n.pts.y} l1="Phoronix" l2="Test Suite" />
        <FlowchartNode
          x={n.composite.x}
          y={n.composite.y}
          l1="composite"
          l2=".xml"
        />
        <FlowchartNode
          x={n.rparser.x}
          y={n.rparser.y}
          l1="Parse_*.R"
          l2="dplyr · ggplot2"
        />
        <FlowchartNode
          x={n.writeups.x}
          y={n.writeups.y}
          l1=".md"
          l2="writeups"
        />
        <FlowchartNode
          x={n.rails.x}
          y={n.rails.y}
          l1="Rails 8"
          l2="+ Sidekiq"
          emphasis
        />
        <FlowchartNode
          x={n.dashboard.x}
          y={n.dashboard.y}
          l1="Chartkick"
          l2="+ noVNC"
          emphasis
        />
      </svg>
    </div>
  );
}

export default function Home() {
  return (
    <main>
      <img
        className="banner banner-dark"
        src="/banner-dark.svg"
        alt="LinuxBenchHub — compare Linux distros under identical virtual hardware"
        width={1200}
        height={420}
      />
      <img
        className="banner banner-light"
        src="/banner-light.svg"
        alt=""
        aria-hidden="true"
        width={1200}
        height={420}
      />

      <div className="badges">
        <a
          href="https://github.com/Builder106/LinuxBenchHub/actions/workflows/ci.yml"
          target="_blank"
          rel="noreferrer"
        >
          <img
            src="https://github.com/Builder106/LinuxBenchHub/actions/workflows/ci.yml/badge.svg"
            alt="CI"
          />
        </a>
        <img
          src="https://img.shields.io/badge/Ruby-3.3.0-CC342D.svg?logo=ruby&logoColor=white"
          alt="Ruby 3.3"
        />
        <img
          src="https://img.shields.io/badge/Rails-8.0-D30001.svg?logo=rubyonrails&logoColor=white"
          alt="Rails 8"
        />
        <img
          src="https://img.shields.io/badge/license-MIT-blue.svg"
          alt="MIT"
        />
        <img
          src="https://img.shields.io/badge/status-in--development-orange.svg"
          alt="In development"
        />
      </div>

      <p className="lede">
        A VM benchmarking platform for Linux distros — run Phoronix Test Suite
        across identical virtual hardware on Ubuntu, Fedora, and Debian, see
        the results in a Rails dashboard, and connect to the live VM through
        an embedded noVNC viewer.
      </p>

      <div className="callout">
        <strong>Note</strong> this site is the static showcase for the
        LinuxBenchHub project. The interactive Rails dashboard with embedded
        noVNC and Sidekiq-driven VM benchmarks runs on a Docker host deployed
        with Kamal — see the{" "}
        <a
          href="https://github.com/Builder106/LinuxBenchHub#setup"
          target="_blank"
          rel="noreferrer"
        >
          README setup section
        </a>{" "}
        to run it locally.
      </div>

      <FacetDivider />

      <section className="section">
        <SectionFlag>Sample results — Ubuntu 24.04</SectionFlag>
        <p style={{ color: "var(--fg-muted)", maxWidth: "60ch" }}>
          The fully parsed sample runs on 2× Intel Core i5-7360U (3 cores),
          4 GB RAM, 21 GB disk, in VMware Fusion Pro 13.6.1. Each benchmark
          ran 9 times; the dot shows the mean, the band shows ±1σ around it.
        </p>

        <div className="data-panel">
          {benchmarks.map((b) => (
            <div className="data-row" key={b.name}>
              <div className="data-label">
                {b.name}
                <small>{b.test}</small>
              </div>
              <div className="data-unit">{b.unit}</div>
              <div className="data-value">{b.meanLabel}</div>
              <SpreadBar b={b} />
            </div>
          ))}
          <div className="data-footnote">
            n = 9 runs · ±1σ band around mean · min/max as range
          </div>
        </div>
      </section>

      <FacetDivider />

      <section className="section">
        <SectionFlag withTux>Per-distro writeups</SectionFlag>
        <p style={{ color: "var(--fg-muted)", maxWidth: "60ch" }}>
          Three distros, same VM specs. Ubuntu is the parsed sample; Fedora
          and Debian have captured runs but the parsed-out hero numbers are
          still pending.
        </p>
        <div className="hex-cluster">
          {distros.map((d) => (
            <HexTile key={d.slug} distro={d} />
          ))}
        </div>
      </section>

      <FacetDivider />

      <section className="section">
        <SectionFlag>How the pieces fit</SectionFlag>
        <p style={{ color: "var(--fg-muted)", maxWidth: "60ch" }}>
          The R parsers and the Rails ingester are interchangeable consumers
          of the same <code>pts/composite.xml</code> — run the static
          analysis with R alone, or use the dashboard alone, or both.
        </p>
        <Flowchart />
      </section>

      <FacetDivider />

      <section className="section">
        <SectionFlag>Tech stack</SectionFlag>
        <div style={{ marginTop: 20 }}>
          {stack.map((g) => (
            <div className="stack-group" key={g.label}>
              <div className="stack-label">{g.label}</div>
              <div className="stack-chips">
                {g.chips.map((c) => (
                  <span className="chip" key={c}>
                    {c}
                  </span>
                ))}
              </div>
            </div>
          ))}
        </div>
      </section>

      <FacetDivider />

      <section className="section">
        <SectionFlag>Project status</SectionFlag>
        <div className="status-panel">
          <div className="status-row">
            <span className="status-pill done">DONE</span>
            <span>
              Per-distro Phoronix captures for Ubuntu, Fedora, Debian
            </span>
          </div>
          <div className="status-row">
            <span className="status-pill done">DONE</span>
            <span>
              R parser pipeline producing markdown writeups from{" "}
              <code>pts/composite.xml</code>
            </span>
          </div>
          <div className="status-row">
            <span className="status-pill wip">WIP</span>
            <span>
              Rails dashboard — scaffolded with Devise, Sidekiq, Chartkick,
              noVNC; rough edges
            </span>
          </div>
          <div className="status-row">
            <span className="status-pill todo">TODO</span>
            <span>Cross-distro comparison page</span>
          </div>
          <div className="status-row">
            <span className="status-pill todo">TODO</span>
            <span>Live Kamal deploy of the Rails dashboard</span>
          </div>
        </div>
      </section>
    </main>
  );
}
