type DistroSlug = "ubuntu" | "fedora" | "debian";

export function DistroMark({
  distro,
  size = 44,
  className,
}: {
  distro: DistroSlug;
  size?: number;
  className?: string;
}) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 32 32"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
      role="img"
      aria-label={
        distro === "ubuntu"
          ? "Ubuntu"
          : distro === "fedora"
            ? "Fedora"
            : "Debian"
      }
    >
      {distro === "ubuntu" && <UbuntuGlyph />}
      {distro === "fedora" && <FedoraGlyph />}
      {distro === "debian" && <DebianGlyph />}
    </svg>
  );
}

function UbuntuGlyph() {
  return (
    <g>
      <circle
        cx="16"
        cy="16"
        r="13.4"
        fill="none"
        stroke="#e95420"
        strokeWidth="2.2"
      />
      <circle cx="16" cy="4.4" r="3.2" fill="#e95420" />
      <circle cx="6.2" cy="21.8" r="3.2" fill="#e95420" />
      <circle cx="25.8" cy="21.8" r="3.2" fill="#e95420" />
    </g>
  );
}

function FedoraGlyph() {
  return (
    <g>
      <circle cx="16" cy="16" r="14" fill="#3c6eb4" />
      <text
        x="17"
        y="26"
        textAnchor="middle"
        fontFamily="Georgia, 'Times New Roman', 'DejaVu Serif', serif"
        fontSize="26"
        fontWeight="700"
        fontStyle="italic"
        fill="#ffffff"
      >
        f
      </text>
    </g>
  );
}

function DebianGlyph() {
  return (
    <path
      d="M 22.4 5.6
         A 12 12 0 1 0 26.2 25.4
         L 23 22.6
         A 8.4 8.4 0 1 1 19.6 8.6
         Q 24 7 27 11
         Q 25.8 7.4 22.4 5.6 Z"
      fill="#d8a04a"
    />
  );
}
